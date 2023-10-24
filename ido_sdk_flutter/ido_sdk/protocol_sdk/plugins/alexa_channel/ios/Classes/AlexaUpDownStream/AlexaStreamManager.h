//
//  AlexaStreamManager.h
//  IDOAlexaClient
//
//  Created by hedongyang on 2023/9/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//参数配置
@interface AlexaStreamConfig : NSObject

//主URL
@property (nonatomic, copy) NSString * mainUrl;

//事件号
@property (nonatomic, copy) NSString * kEvents;

@property (nonatomic, copy) NSString * directives;

@property (nonatomic, copy) NSString * ping;

@end


@protocol AlexaStreamManagerDelegate <NSObject>

/**
  下行流接收到的数据
 */
- (void)downStreamReceiveDirectives:(NSData *)data;

/**
 下行流中断报错
 */
- (void)downStreamDidCompleteWithError:(NSError *)error;

/**
  上行流接收到的数据
 */
- (void)upStreamReceiveDirectives:(NSData *)data;

/**
 上行流中断报错
 */
- (void)upStreamDidCompleteWithError:(NSError *)error;


@optional
/**
 ping 每次完成回调
 */
- (void)pingComplete:(BOOL)success;

@end

@interface AlexaStreamManager : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, assign) id<AlexaStreamManagerDelegate> delegate;

@property (nonatomic , strong) NSURLSession * streamSession;

@property (nonatomic, copy) NSString * accessToken;


- (void)ping;

-(void)interReCreateDownStream;

//创建下行流
- (void)createDownStream:(NSString*)url completion:(void (^)(BOOL isSuc))completion;

//关闭下行流
- (void)closeDownStream;

//创建上行流
- (void)createUpStream:(NSData*)uniqueIDdata url:(NSString*)url completion:(void (^)(BOOL isSuc))completion;

//关闭上行流
-(void)closeUpStream;

/**< 结束聆听 或者 停止输出流*/
- (void)endListenningStream;

/**< 上传上行流数据 */
-(void)uploadStreamWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
