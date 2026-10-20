//
//  RemoteStatus.m
//  ActionsUtils
//
//  Created by 林韦辰 on 2025/2/17.
//

#import "RemoteStatus.h"

@implementation RemoteStatus

- (instancetype)initWithName:(NSString *)versionName boardName:(NSString *)boardName hardwareRev:(NSString *)hardwareRev batteryThreshold:(NSNumber *)batteryThreshold versionCode:(NSNumber *)versionCode featureSupport:(NSNumber *)featureSupport {
    self = [super init];
    if (self) {
        _versionName = versionName;
        _boardName = boardName;
        _hardwareRev = hardwareRev;
        _batteryThreshold = batteryThreshold;
        _versionCode = versionCode;
        _featureSupport = featureSupport;
    }
    return self;
}

@end
