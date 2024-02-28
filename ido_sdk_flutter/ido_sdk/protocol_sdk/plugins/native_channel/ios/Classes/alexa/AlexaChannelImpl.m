//
//  AlexaChannelImpl.m
//  alexa_channel
//
//  Created by hc on 2023/9/23.
//

#import "AlexaChannelImpl.h"
#import "AlexaUpDownStream/AlexaStreamManager.h"
#import <Flutter/Flutter.h>

@interface AlexaChannelImpl()<AlexaStreamManagerDelegate>

@end

@implementation AlexaChannelImpl

-(instancetype)init{
    if(self = [super init]){
        AlexaStreamManager.shareInstance.delegate = self;
    }
    return self;
}

+ (id)sharedInstance {
    static AlexaChannelImpl *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
} 

- (void)askAudioDataData:(nonnull FlutterStandardTypedData *)data isEnd:(nonnull NSNumber *)isEnd error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [AlexaStreamManager.shareInstance uploadStreamWithData:data.data];
}

- (void)closeDownStreamWithCompletion:(nonnull void (^)(NSNumber * _Nullable, FlutterError * _Nullable))completion {
    [AlexaStreamManager.shareInstance closeDownStream];
    
    [self writelog:@"closeDownStreamWithCompletion"];
}

- (void)closeUploadStreamWithCompletion:(nonnull void (^)(NSNumber * _Nullable, FlutterError * _Nullable))completion {
//     NSLog(@"closeUploadStreamWithCompletion");
    [AlexaStreamManager.shareInstance endListenningStream];
    
    [self writelog:@"closeUploadStreamWithCompletion"];
}

- (void)createDownStreamUrl:(nonnull NSString *)url completion:(nonnull void (^)(NSNumber * _Nullable, FlutterError * _Nullable flutterError))completion {
    [AlexaStreamManager.shareInstance createDownStream:url completion:^(BOOL isSuc) {
        if(completion){
            [AlexaStreamManager.shareInstance ping];
            NSString*log = [NSString stringWithFormat:@"createDownStreamUrl--->%@, state: %d",url,isSuc];
            [self writelog:log];
            completion(@(isSuc),nil);
        }
    }];
    
   
}

- (void)createUploadStreamUrl:(nonnull NSString *)url jsonBody:(nonnull FlutterStandardTypedData *)jsonBody completion:(nonnull void (^)(NSNumber * _Nullable num, FlutterError * _Nullable flutterError))completion {
    [AlexaStreamManager.shareInstance createUpStream:jsonBody.data url:url completion:^(BOOL isSuc) {
        if(completion){
            NSString*log = [NSString stringWithFormat:@"createUploadStreamUrl--->%@, state:%d",url,isSuc];
            [self writelog:log];
            completion(@(isSuc),nil);
        }
    }];

   
}

- (void)onTokenChangedToken:(nullable NSString *)token error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    AlexaStreamManager.shareInstance.accessToken = token;
    
    NSString*log = [NSString stringWithFormat:@"onTokenChangedToken--->%@",token];
    [self writelog:log];
}

/**
  下行流接收到的数据
 */
- (void)downStreamReceiveDirectives:(NSData *)data{
    [self.alexaFlutter downStreamDataData:[FlutterStandardTypedData typedDataWithBytes:data] completion:^(FlutterError * _Nullable flutterError) {
            
    }];
}

/**
 下行流中断报错
 */
- (void)downStreamDidCompleteWithError:(NSError *)error{
    if(error != nil){
        ApiAlexaError *arg_error = [ApiAlexaError new];
        [self.alexaFlutter onDownStreamErrorError:arg_error completion:^(FlutterError * _Nullable flutterError) {
            
        }];
    }
}

/**
  上行流接收到的数据
 */
- (void)upStreamReceiveDirectives:(NSData *)data{
  
    [self.alexaFlutter replyAudioDataMessageId:@""
                                          data:[FlutterStandardTypedData typedDataWithBytes:data]
                                         isEnd:[NSNumber numberWithBool:NO]
                                    completion:^(FlutterError * _Nullable flutterError) {
        
    }];
}

/**
 上行流中断报错
 */
- (void)upStreamDidCompleteWithError:(NSError *)error{
    if(error != nil){
        ApiAlexaError *arg_error = [ApiAlexaError new];
        arg_error.errorCode = @(error.code);
        arg_error.errorMessage = error.localizedDescription;
        [self.alexaFlutter onUploadStreamErrorError:arg_error completion:^(FlutterError * _Nullable flutterError) {
            
        }];
    }
    
}

/**
 添加log
 */
-(void)writelog:(NSString*)log{
    [self.alexaFlutter logLogMsg:log completion:^(FlutterError * _Nullable flutterError) {
        
    }];
}

@end
