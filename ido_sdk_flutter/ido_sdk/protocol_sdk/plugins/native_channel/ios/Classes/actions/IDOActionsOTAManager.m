//
//  IDOActionsOTAManager.m
//  IDOOTASDK
//
//  结构对齐 Sifli SFOTAManager：Manager 负责搜索/连接/收发，OtaManager 负责协议。
//  ActionsOTASDK 头文件仅在此 .m 内引用，不对外公开。
//

#import "IDOActionsOTAManager.h"
#import "LETransceiver.h"
#import "OtaManager.h"
#import "RemoteStatus.h"
#import "OTAStatus.h"

typedef NS_ENUM(NSInteger, ActionsOTAManagerStatus) {
    ActionsOTAManagerStatusLeisure = 0,
    ActionsOTAManagerStatusSearching,
    ActionsOTAManagerStatusConnecting,
    ActionsOTAManagerStatusWorking,
    /// 对齐思澈 waitingDevReboot：进 OTA 模式后设备重启，等待重连
    ActionsOTAManagerStatusWaitingDevReboot,
};

/// 设备重启后延迟再搜/连，给固件重启留时间
static const NSTimeInterval kActionsOTARebootReconnectDelay = 2.0;
static const NSInteger kActionsOTAMaxReconnectAttempts = 5;
/// 首次 Central 未就绪时等待 poweredOn 的超时（对齐思澈 / Nordic）
static const NSTimeInterval kActionsOTABleWaitTimeout = 8.0;

@interface IDOActionsOTAManager () <LEConnctionDelegate, LEDataDelegate, OtaDelegate>
@property (nonatomic, strong) LETransceiver *leTransceiver;
@property (nonatomic, strong) OtaManager *otaManager;
@property (nonatomic, copy, nullable) NSString *targetDevIdentifier;
@property (nonatomic, assign) ActionsOTAManagerStatus status;
@property (nonatomic, assign) BOOL hasStartedUpgrade;
@property (nonatomic, assign) BOOL hasFinished;
@property (nonatomic, strong, nullable) NSTimer *searchTimer;
/// 设备重启后的重连次数（对齐思澈 otaModuleReconnectRequest）
@property (nonatomic, assign) NSInteger reconnectAttempt;
/// 首次创建 Central 时 state 可能仍为 unknown，排队等待 poweredOn
@property (nonatomic, copy, nullable) NSString *pendingTargetId;
@property (nonatomic, copy, nullable) NSString *pendingFilePath;
@property (nonatomic, strong, nullable) dispatch_block_t bleWaitTimeoutBlock;
@end

@implementation IDOActionsOTAManager

+ (IDOActionsOTAManager *)share {
    static IDOActionsOTAManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[IDOActionsOTAManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _searchingTimeout = 20;
        _status = ActionsOTAManagerStatusLeisure;
        // 提前创建 Central，避免 start 时 bleState 未就绪
        [self leTransceiver];
    }
    return self;
}

- (LETransceiver *)leTransceiver {
    if (!_leTransceiver) {
        _leTransceiver = [[LETransceiver alloc] init];
        _leTransceiver.connectionDelegate = self;
        _leTransceiver.dataDelegate = self;
        [_leTransceiver setUUIDs:[self gattUUIDs]];
    }
    return _leTransceiver;
}

- (OtaManager *)otaManager {
    if (!_otaManager) {
        _otaManager = [[OtaManager alloc] init];
        _otaManager.delegate = self;
    }
    return _otaManager;
}

- (NSDictionary *)gattUUIDs {
    NSString *serviceUUID = @"e49a25f8-f69a-11e8-8eb2-f2801f1b9fd1";
    NSString *writeUUID = @"e49a25e0-f69a-11e8-8eb2-f2801f1b9fd1";
    NSString *indicateUUID = @"e49a28e1-f69a-11e8-8eb2-f2801f1b9fd1";
    return @{
        KeyWriteServiceUUID: serviceUUID,
        KeyWriteCharacteristicUUID: writeUUID,
        KeyIndicateServiceUUID: serviceUUID,
        KeyIndicateCharacteristicUUID: indicateUUID,
    };
}

- (BOOL)isBusy {
    return self.status != ActionsOTAManagerStatusLeisure || self.pendingTargetId.length > 0;
}

- (CBManagerState)bleState {
    return [self.leTransceiver bleState];
}

- (void)startOTAWithTargetDeviceIdentifier:(NSString *)targetDeviceIdentifier
                                  filePath:(NSString *)filePath {
    if (self.isBusy) {
        [self otaLog:@"⚠️ Manager 正忙，忽略本次 start"];
        return;
    }

    self.hasFinished = NO;

    if (targetDeviceIdentifier.length == 0 || filePath.length == 0) {
        [self notifyFailWithCode:-2001 message:@"Actions OTA 参数无效：UUID 或文件路径为空" clearBeforeNotify:YES];
        return;
    }

    NSString *path = [self resolveFilePath:filePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [self notifyFailWithCode:-2002 message:[NSString stringWithFormat:@"Actions OTA 文件不存在: %@", path] clearBeforeNotify:YES];
        return;
    }

    // 确保 Central 已创建
    (void)self.leTransceiver;
    CBManagerState state = self.bleState;
    if (state != CBManagerStatePoweredOn) {
        // 对齐思澈：unknown/resetting 时排队等待，不直接失败（避免第一次点无效）
        if (state == CBManagerStateUnknown || state == CBManagerStateResetting) {
            [self otaLog:@"ble not ready state=%ld, wait poweredOn...", (long)state];
            [self queuePendingStartWithTarget:targetDeviceIdentifier filePath:path];
            return;
        }
        [self notifyFailWithCode:-2005
                         message:[NSString stringWithFormat:@"蓝牙不可用: %ld", (long)state]
               clearBeforeNotify:YES];
        return;
    }

    [self proceedStartWithTarget:targetDeviceIdentifier filePath:path];
}

- (void)queuePendingStartWithTarget:(NSString *)targetId filePath:(NSString *)path {
    self.pendingTargetId = targetId;
    self.pendingFilePath = path;
    [self cancelBleWaitTimeout];

    __weak typeof(self) weakSelf = self;
    dispatch_block_t block = dispatch_block_create(0, ^{
        __strong typeof(weakSelf) self = weakSelf;
        if (!self || self.pendingTargetId.length == 0) {
            return;
        }
        [self otaLog:@"wait poweredOn timeout, state=%ld", (long)self.bleState];
        [self clearPendingBleWait];
        [self notifyFailWithCode:-2005
                         message:@"Actions 蓝牙未就绪超时，请确认系统蓝牙已开启后重试"
               clearBeforeNotify:YES];
    });
    self.bleWaitTimeoutBlock = block;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kActionsOTABleWaitTimeout * NSEC_PER_SEC)),
                   dispatch_get_main_queue(),
                   block);

    // 防止等待期间已经 poweredOn、错过回调
    if (self.bleState == CBManagerStatePoweredOn) {
        [self resumePendingStartIfNeeded];
    }
}

- (void)resumePendingStartIfNeeded {
    NSString *targetId = self.pendingTargetId;
    NSString *path = self.pendingFilePath;
    if (targetId.length == 0 || path.length == 0) {
        return;
    }
    [self otaLog:@"ble poweredOn, resume pending start"];
    [self clearPendingBleWait];
    [self proceedStartWithTarget:targetId filePath:path];
}

- (void)clearPendingBleWait {
    [self cancelBleWaitTimeout];
    self.pendingTargetId = nil;
    self.pendingFilePath = nil;
}

- (void)cancelBleWaitTimeout {
    if (self.bleWaitTimeoutBlock) {
        dispatch_block_cancel(self.bleWaitTimeoutBlock);
        self.bleWaitTimeoutBlock = nil;
    }
}

- (void)proceedStartWithTarget:(NSString *)targetDeviceIdentifier filePath:(NSString *)path {
    [self clearCaches];
    self.targetDevIdentifier = targetDeviceIdentifier;
    self.hasStartedUpgrade = NO;
    self.hasFinished = NO;
    self.reconnectAttempt = 0;
    [self.otaManager setOTAFile:path];

    [self otaLog:@"start target=%@ file=%@", targetDeviceIdentifier, path];
    [self requestReconnect];
}

- (void)stop {
    BOOL busy = self.isBusy;
    [self clearPendingBleWait];
    [self clearCaches];
    [self.leTransceiver disconnect];
    if (busy) {
        [self notifyFailWithCode:-2006 message:@"Manager 主动终止了升级" clearBeforeNotify:NO];
    }
}


#pragma mark - Log

- (void)otaLog:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2) {
    va_list args;
    va_start(args, format);
    NSString *body = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    // 兼容旧前缀，统一为 [IDO Actions OTA]
    if ([body hasPrefix:@"[IDO Actions OTA] "]) {
        body = [body substringFromIndex:[@"[IDO Actions OTA] " length]];
    } else if ([body hasPrefix:@""]) {
        body = [body substringFromIndex:[@"" length]];
    }
    NSString *message = [NSString stringWithFormat:@"[IDO Actions OTA] %@", body];
    if ([self.delegate respondsToSelector:@selector(actionsOTADidLog:)]) {
        [self.delegate actionsOTADidLog:message];
    }
}

#pragma mark - Reconnect

- (void)requestReconnect {
    NSString *targetId = self.targetDevIdentifier;
    if (targetId.length == 0) {
        [self notifyFailWithCode:-2007 message:@"targetIdentifier is nil When Reconnect" clearBeforeNotify:YES];
        return;
    }

    // Host app must disconnect first, then SDK connects by UUID / scan
    // Order: system-connected → known identifier → scan
    NSArray<CBPeripheral *> *connectedDevices = [self.leTransceiver retrieveConnectedPeripherals];
    for (CBPeripheral *device in connectedDevices) {
        if ([device.identifier.UUIDString.uppercaseString isEqualToString:targetId.uppercaseString]) {
            [self otaLog:@"✅ 找到外设(connected) %@, %@ state=%ld，准备连接",
                  device.name, device.identifier.UUIDString, (long)device.state];
            [self invalidateSearchTimer];
            self.status = ActionsOTAManagerStatusConnecting;
            [self.leTransceiver scanStop];
            [self.leTransceiver connect:device];
            return;
        }
    }

    CBPeripheral *known = [self.leTransceiver retrievePeripheralWithIdentifier:targetId];
    if (known != nil) {
        [self otaLog:@"✅ 找到已知外设 %@, %@ state=%ld，准备连接", known.name, known.identifier.UUIDString, (long)known.state];
        [self invalidateSearchTimer];
        self.status = ActionsOTAManagerStatusConnecting;
        [self.leTransceiver scanStop];
        [self.leTransceiver connect:known];
        return;
    }

    [self otaLog:@"ℹ️ 已连接/已知外设未命中，开启搜索 target=%@", targetId];
    self.status = ActionsOTAManagerStatusSearching;
    [self.leTransceiver scanStop];
    [self invalidateSearchTimer];
    self.searchTimer = [NSTimer timerWithTimeInterval:self.searchingTimeout
                                               target:self
                                             selector:@selector(searchTimeoutHandler)
                                             userInfo:nil
                                              repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.searchTimer forMode:NSDefaultRunLoopMode];
    [self.leTransceiver scanStart];
}

- (void)searchTimeoutHandler {
    [self otaLog:@"⚠️ 搜索即将超时，再次尝试从已连接设备中获取..."];
    NSString *targetId = self.targetDevIdentifier;
    if (targetId.length > 0) {
        NSArray<CBPeripheral *> *connectedDevices = [self.leTransceiver retrieveConnectedPeripherals];
        for (CBPeripheral *device in connectedDevices) {
            if ([device.identifier.UUIDString.uppercaseString isEqualToString:targetId.uppercaseString]) {
                [self otaLog:@"✅ 找到外设(retry connected) %@，准备连接", device.identifier.UUIDString];
                [self invalidateSearchTimer];
                self.status = ActionsOTAManagerStatusConnecting;
                [self.leTransceiver scanStop];
                [self.leTransceiver connect:device];
                return;
            }
        }
    }

    [self otaLog:@"⚠️ 搜索设备超时 timeout=%ld", (long)self.searchingTimeout];
    [self notifyFailWithCode:-2004 message:@"搜索设备超时" clearBeforeNotify:YES];
}

#pragma mark - Helpers

- (NSString *)resolveFilePath:(NSString *)filePath {
    NSURL *url = [NSURL URLWithString:filePath];
    if (url.isFileURL) {
        return url.path;
    }
    if ([filePath hasPrefix:@"/"]) {
        return filePath;
    }
    if (url.scheme.length > 0) {
        return url.path ?: filePath;
    }
    return filePath;
}

- (void)invalidateSearchTimer {
    [self.searchTimer invalidate];
    self.searchTimer = nil;
}

- (void)clearCaches {
    [self.leTransceiver scanStop];
    [self.otaManager cancel];
    [self invalidateSearchTimer];
    self.targetDevIdentifier = nil;
    self.hasStartedUpgrade = NO;
    self.reconnectAttempt = 0;
    self.status = ActionsOTAManagerStatusLeisure;
}

- (void)handleSystemBluetoothUnavailable:(CBManagerState)state {
    if (self.pendingTargetId.length > 0) {
        [self otaLog:@"⚠️ 等待蓝牙就绪期间系统蓝牙不可用 state=%ld", (long)state];
        [self clearPendingBleWait];
        [self notifyFailWithCode:-2008 message:@"系统蓝牙已关闭，OTA 已终止" clearBeforeNotify:YES];
        return;
    }
    if (self.status == ActionsOTAManagerStatusLeisure) {
        return;
    }
    [self otaLog:@"⚠️ 系统蓝牙不可用 state=%ld，终止 OTA", (long)state];
    [self notifyFailWithCode:-2008 message:@"系统蓝牙已关闭，OTA 已终止" clearBeforeNotify:YES];
}

/// 对齐思澈：断连且处于等待重启 / prepare 阶段时发起重连，而不是直接失败
- (void)handleExpectedRebootDisconnect {
    if (self.status == ActionsOTAManagerStatusWaitingDevReboot) {
        [self otaLog:@"已在等待重启重连，忽略重复断连"];
        return;
    }

    if (self.reconnectAttempt >= kActionsOTAMaxReconnectAttempts) {
        [self otaLog:@"❌ 设备重启后重连次数已用尽 (%ld)", (long)self.reconnectAttempt];
        [self notifyFailWithCode:-2003
                         message:@"Actions OTA 设备进入 OTA 模式后重连失败"
               clearBeforeNotify:YES];
        return;
    }

    self.reconnectAttempt += 1;
    self.hasStartedUpgrade = NO;
    self.status = ActionsOTAManagerStatusWaitingDevReboot;
    [self invalidateSearchTimer];
    // 仅重置协议状态，保留已加载的固件数据
    [self.otaManager cancel];

    NSInteger attempt = self.reconnectAttempt;
    [self otaLog:@"ℹ️ 设备可能进入 OTA 重启，%.1fs 后重连 (%ld/%ld)",
          kActionsOTARebootReconnectDelay,
          (long)attempt,
          (long)kActionsOTAMaxReconnectAttempts];

    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kActionsOTARebootReconnectDelay * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) self = weakSelf;
        if (!self || self.hasFinished) {
            return;
        }
        if (self.status != ActionsOTAManagerStatusWaitingDevReboot) {
            return;
        }
        [self otaLog:@"▶️ 重启等待结束，发起重连"];
        [self requestReconnect];
    });
}

- (void)notifyProgress:(float)progress {
    float value = MAX(0.f, MIN(1.f, progress));
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(actionsOTAProgressDidChange:)]) {
            [self.delegate actionsOTAProgressDidChange:value];
        }
    });
}

- (void)notifyComplete {
    if (self.hasFinished) {
        return;
    }
    self.hasFinished = YES;
    [self clearCaches];
    [self.leTransceiver disconnect];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(actionsOTADidComplete)]) {
            [self.delegate actionsOTADidComplete];
        }
    });
}

- (void)notifyFailWithCode:(NSInteger)code message:(NSString *)message clearBeforeNotify:(BOOL)clearBeforeNotify {
    if (self.hasFinished) {
        return;
    }
    self.hasFinished = YES;
    [self clearPendingBleWait];
    NSError *error = [NSError errorWithDomain:@"IDOActionsOTAManager"
                                         code:code
                                     userInfo:@{NSLocalizedDescriptionKey: message ?: @""}];
    if (clearBeforeNotify) {
        [self clearCaches];
        [self.leTransceiver disconnect];
    } else {
        self.status = ActionsOTAManagerStatusLeisure;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(actionsOTADidFailWithError:)]) {
            [self.delegate actionsOTADidFailWithError:error];
        }
    });
}

#pragma mark - LEConnctionDelegate

- (void)onLog:(NSString *)message {
    [self otaLog:@"%@", message];
}

- (void)onOtaLog:(NSString *)message {
    [self otaLog:@"%@", message];
}

- (void)onFoundPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData {
    if (self.status != ActionsOTAManagerStatusSearching) {
        [self.leTransceiver scanStop];
        return;
    }
    NSString *targetId = self.targetDevIdentifier;
    if (targetId.length == 0) {
        return;
    }
    NSString *found = peripheral.identifier.UUIDString.uppercaseString;
    if (![found isEqualToString:targetId.uppercaseString]) {
        return;
    }

    [self otaLog:@"✅ 找到外设(%@, %@)，准备连接...", peripheral.name, found];
    [self invalidateSearchTimer];
    self.status = ActionsOTAManagerStatusConnecting;
    [self.leTransceiver scanStop];
    [self.leTransceiver connect:peripheral];
}

- (void)onConnectedPeripheral:(CBPeripheral *)peripheral {
    [self otaLog:@"✅ 连接成功: %@, %@", peripheral.name, peripheral.identifier.UUIDString];
    if (self.status != ActionsOTAManagerStatusConnecting &&
        self.status != ActionsOTAManagerStatusSearching &&
        self.status != ActionsOTAManagerStatusWaitingDevReboot) {
        return;
    }
    // 重连成功后重新 prepare（对齐思澈 shakedHands → 继续协议）
    self.hasStartedUpgrade = NO;
    self.status = ActionsOTAManagerStatusWorking;
    [self invalidateSearchTimer];
    [self otaLog:@"prepare (reconnectAttempt=%ld)", (long)self.reconnectAttempt];
    [self.otaManager prepare];
}

- (void)onDisconnectedPeripheral:(CBPeripheral *)peripheral {
    [self otaLog:@"断开连接: %@, status=%ld", peripheral.identifier.UUIDString, (long)self.status];
    if (self.hasFinished || self.status == ActionsOTAManagerStatusLeisure) {
        return;
    }

    // 对齐思澈 waitingDevReboot：
    // 1) Working 且尚未开始 upgrade → prepare 握手后设备进 OTA 重启，预期断连
    // 2) 已在等待重启 / 重启后的搜连过程中再次断连 → 继续重连
    BOOL expectRebootReconnect =
        (self.status == ActionsOTAManagerStatusWaitingDevReboot) ||
        (self.status == ActionsOTAManagerStatusWorking && !self.hasStartedUpgrade) ||
        ((self.status == ActionsOTAManagerStatusConnecting ||
          self.status == ActionsOTAManagerStatusSearching) &&
         self.reconnectAttempt > 0);

    if (expectRebootReconnect) {
        [self handleExpectedRebootDisconnect];
        return;
    }

    if (self.status == ActionsOTAManagerStatusWorking ||
        self.status == ActionsOTAManagerStatusConnecting ||
        self.status == ActionsOTAManagerStatusSearching) {
        [self notifyFailWithCode:-2003 message:@"Actions OTA 过程中蓝牙断开" clearBeforeNotify:YES];
    }
}

- (void)onBleStateUpdate:(CBManagerState)state {
    [self otaLog:@"onBleStateUpdate state=%ld", (long)state];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(actionsOTADidUpdateBleState:)]) {
            [self.delegate actionsOTADidUpdateBleState:state];
        }
    });

    switch (state) {
        case CBManagerStatePoweredOff:
        case CBManagerStateUnauthorized:
        case CBManagerStateUnsupported:
            [self handleSystemBluetoothUnavailable:state];
            break;
        case CBManagerStateResetting:
            // 过渡态：若在排队等 poweredOn，继续等；升级中则终止
            if (self.pendingTargetId.length == 0) {
                [self handleSystemBluetoothUnavailable:state];
            } else {
                [self otaLog:@"ble resetting while pending, keep waiting poweredOn"];
            }
            break;
        case CBManagerStatePoweredOn:
            // 对齐 Nordic / 思澈：Central 就绪后补启排队中的 OTA
            [self resumePendingStartIfNeeded];
            break;
        default:
            break;
    }
}

#pragma mark - LEDataDelegate

- (void)onDataReceive:(NSData *)data {
    if (self.status != ActionsOTAManagerStatusWorking) {
        return;
    }
    [self.otaManager analysisData:data];
}

#pragma mark - OtaDelegate

- (void)sendOtaData:(NSData *)data {
    [self.leTransceiver write:data];
}

- (void)onOtaStatus:(NSInteger)state {
    [self otaLog:@"onOtaStatus state=%ld", (long)state];
    if (state == STATE_PREPARED) {
        if (self.status != ActionsOTAManagerStatusWorking || self.hasStartedUpgrade) {
            return;
        }
        self.hasStartedUpgrade = YES;
        self.reconnectAttempt = 0;
        [self otaLog:@"prepared, start upgrade"];
        [self.otaManager upgrade];
    } else if (state == STATE_TRANSFERRED) {
        [self otaLog:@"transferred success"];
        self.status = ActionsOTAManagerStatusLeisure;
        [self notifyProgress:1.f];
        [self notifyComplete];
    }
}

- (void)onOtaAudioDataReceived:(NSInteger)psn len:(NSInteger)len data:(NSData *)data {
}

- (void)onOtaRemoteStatusReceived:(RemoteStatus *)status {
    [self otaLog:@"remote status version=%@ board=%@", status.versionName, status.boardName];
}

- (void)onOtaProgress:(NSInteger)progress total:(NSInteger)total {
    if (total <= 0) {
        return;
    }
    float value = (float)progress / (float)total;
    [self otaLog:@"progress %ld/%ld (%f)", (long)progress, (long)total, value];
    [self notifyProgress:value];
}

- (void)onOtaError:(NSInteger)errCode errMsg:(NSString *)errMsg {
    NSString *message = errMsg.length > 0 ? errMsg : @"Actions OTA unknown error";
    [self otaLog:@"error code=%ld msg=%@", (long)errCode, message];
    [self notifyFailWithCode:errCode message:message clearBeforeNotify:YES];
}

- (void)onOtaWriteBytes:(NSInteger)count {
}

@end
