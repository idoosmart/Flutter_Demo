//
//  AlexaDownStream.h
//  alexa_channel
//
//  Created by huangkunhe on 2023/9/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlexaDownStream : NSObject
/**< 下行通道task 超时大于60分钟 */
@property (nonatomic, strong, nullable) NSURLSessionDataTask * downTask;

- (void)ping:(void(^)(BOOL success))callback;

- (void)creatDownStream:(NSString*)url;
- (void)closeDownStream;
@end

NS_ASSUME_NONNULL_END
