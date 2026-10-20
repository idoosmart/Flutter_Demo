//
//  RemoteStatus.h
//  ActionsUtils
//
//  Created by 林韦辰 on 2025/2/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RemoteStatus : NSObject

@property (copy, nonatomic) NSString *versionName;
@property (copy, nonatomic) NSString *boardName;
@property (copy, nonatomic) NSString *hardwareRev;
@property (weak, nonatomic) NSNumber *batteryThreshold;
@property (weak, nonatomic) NSNumber *versionCode;
@property (weak, nonatomic) NSNumber *featureSupport;

- (instancetype)initWithName:(NSString *)versionName boardName:(NSString *)boardName hardwareRev:(NSString *)hardwareRev batteryThreshold:(NSNumber *)batteryThreshold versionCode:(NSNumber *)versionCode featureSupport:(NSNumber *)featureSupport;

@end

NS_ASSUME_NONNULL_END
