//
//  AlexaStreamManager.m
//  IDOAlexaClient
//
//  Created by hedongyang on 2023/9/23.
//

#import "AlexaStreamManager.h"
#import "AlexaDownStream.h"
#import "AlexaUpStream.h"
#import "AlexaChannelImpl.h"

#define requestTimeoutInterval 30.0

@implementation AlexaStreamConfig

@end


@interface AlexaStreamManager ()<NSStreamDelegate,NSURLSessionTaskDelegate>

@property (nonatomic, strong) AlexaDownStream * downStream;
@property (nonatomic, strong) AlexaUpStream   * upStream;

@property(nonatomic, copy)  void (^downStreamDidCreateBlock)(BOOL isScu);
@property(nonatomic, copy)  void (^upStreamDidCreateBlock)(BOOL isScu);

@property (nonatomic, copy) NSString * downStreamUrl;
@property (nonatomic , strong) NSTimer* pingTimer;


@end

@implementation AlexaStreamManager

static AlexaStreamManager * instance = nil;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id) allocWithZone:(struct _NSZone *)zone
{
    return [AlexaStreamManager shareInstance];
}

- (id) copyWithZone:(struct _NSZone *)zone
{
    return [AlexaStreamManager shareInstance];
}

- (AlexaDownStream *)downStream {
    if (!_downStream) {
         _downStream = [[AlexaDownStream alloc]init];
    }
    return _downStream;
}

- (AlexaUpStream *)upStream {
    if (!_upStream) {
         _upStream = [[AlexaUpStream alloc]init];
    }
    return _upStream;
}

-(NSURLSession *)streamSession {
    if (!_streamSession) {
        NSURLSessionConfiguration *config = NSURLSessionConfiguration.defaultSessionConfiguration;
        config.HTTPMaximumConnectionsPerHost = 1;
        config.timeoutIntervalForRequest = requestTimeoutInterval;
//        config.HTTPShouldUsePipelining = YES;
//        config.shouldUseExtendedBackgroundIdleMode = YES;
        NSLog(@"streamSession --- ");
        config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        config.URLCache = nil;
        _streamSession = [NSURLSession sessionWithConfiguration:config
                                                       delegate:self
                                                  delegateQueue:[NSOperationQueue new]];
    }
    return _streamSession;
}

- (void)ping
{
//    NSLog(@" ----------ping--------");
    [AlexaChannelImpl.sharedInstance writelog:@" ----------ping start"];
    
    if (AlexaStreamManager.shareInstance.accessToken == nil) {
        [AlexaChannelImpl.sharedInstance writelog:@" ----------ping start accessToken == nil"];
        [self createOrClearTimer:NO timeCount:0];
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://alexa.na.gateway.devices.a2z.com/ping"]];
    request.HTTPMethod = @"GET";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", AlexaStreamManager.shareInstance.accessToken] forHTTPHeaderField:@"Authorization"];
    
    [[weakSelf.streamSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString*loxText = [NSString stringWithFormat:@" ----------ping error: %@",error];
        [AlexaChannelImpl.sharedInstance writelog:loxText];
        
        NSInteger i = 180;
        //取消之前afterDelay60秒后执行ping的
        [weakSelf createOrClearTimer:NO timeCount:0];
        if (((NSHTTPURLResponse *)response).statusCode != 204) {
            i = 60;
            NSString*loxText = @"----------超时重连 ----";
            [AlexaChannelImpl.sharedInstance writelog:loxText];
            [weakSelf interReCreateDownStream];
        }
        [weakSelf createOrClearTimer:YES timeCount:i];        
    }] resume] ;
}

/**< 连接成功后，但是ping失败，会自动创建一个60秒ping一次的定时器 */
-(void)createOrClearTimer:(BOOL)isCreate
                timeCount:(NSInteger)timeCount
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isCreate) {
            if (self.pingTimer) { //如果存储在ping定时器需要销毁重新创建
                [self.pingTimer invalidate];
                 self.pingTimer = nil;
            }
            self.pingTimer = [NSTimer scheduledTimerWithTimeInterval:timeCount
                                                              target:self
                                                            selector:@selector(ping)
                                                            userInfo:nil
                                                             repeats:NO];
        }else{
            if (self.pingTimer) {
                [self.pingTimer invalidate];
                 self.pingTimer = nil;
            }
        }
    });
}

//创建下行流
- (void)createDownStream:(NSString*)url completion:(void (^)(BOOL isSuc))completion{
    self.downStreamUrl = url;
    self.downStreamDidCreateBlock = completion;

    [self.downStream creatDownStream:url];
    
    if(self.downStreamDidCreateBlock) {
        self.downStreamDidCreateBlock(YES);
    }
}
//内部创建下行流
-(void)interReCreateDownStream{
    NSString*loxText = [NSString stringWithFormat:@" ----------interReCreateDownStream url: %@",self.downStreamUrl];
    [AlexaChannelImpl.sharedInstance writelog:loxText];
    
    if(self.downStreamUrl.length > 0){
        [self.downStream creatDownStream:self.downStreamUrl];
        if(self.downStreamDidCreateBlock) {
            self.downStreamDidCreateBlock(YES);
        }
    }
}

//关闭下行流
- (void)closeDownStream{
    [AlexaChannelImpl.sharedInstance writelog:@"closeDownStream and close ping"];
    [self.downStream closeDownStream];
    if (self.pingTimer) {
        [self.pingTimer invalidate];
         self.pingTimer = nil;
    }
}

//创建上行流
- (void)createUpStream:(NSData*)uniqueIDdata url:(NSString*)url  completion:(void (^)(BOOL isSuc))completion{
    self.upStreamDidCreateBlock = completion;
    [self.upStream creatStream:uniqueIDdata url:url];
}

//关闭上行流
-(void)closeUpStream{
    [self.upStream endListenningStream];
}


/**< 结束聆听 或者 停止输出流*/
- (void)endListenningStream{
    [self.upStream endListenningStream];
}

/**< 上传上行流数据 */
-(void)uploadStreamWithData:(NSData *)data{
    [self.upStream uploadStreamWithData:data];
}

#pragma mark ************** NSURLSessionTaskDelegate **************
- (void)URLSession:(NSURLSession *)session didCreateTask:(NSURLSessionTask *)task{
    
    //NSHTTPURLResponse*httpReq = (NSHTTPURLResponse*)task.response;

//    NSLog(@"task.originalRequest.URL == %@, response = %@, error = %ld",task.originalRequest,task.response,httpReq.statusCode);

    if ([task.originalRequest.URL.absoluteString hasSuffix:@"v20160207/directives"]) {
//        NSLog(@"didCreateTask --- downTask: %@",task);
//        if(self.downStreamDidCreateBlock) {
//            self.downStreamDidCreateBlock(YES);
//        }
    }else if ([task.originalRequest.URL.absoluteString hasSuffix:@"v20160207/events"]){
//        NSLog(@"didCreateTask --- upTask: %@",task);
        if(self.upStreamDidCreateBlock) {
            self.upStreamDidCreateBlock(YES);
        }
    }
}
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
 needNewBodyStream:(void (^)(NSInputStream * _Nullable bodyStream))completionHandler{
//    NSLog(@"needNewBodyStream---");
    completionHandler(self.upStream.input);
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
//    NSLog(@"didReceiveData---%@",data);

    if (self.downStream.downTask == dataTask) {
//        NSLog(@"downTask---%@",data);
        //下行流
        if (self.delegate && [self.delegate respondsToSelector:@selector(downStreamReceiveDirectives:)]) {
            [self.delegate downStreamReceiveDirectives:data];
        }
    }else {
        //NSString * str  = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

//        NSLog(@"upTask---length:%ld, data:%@",data.length,str);
        
        [self.upStream.receiveData appendData:data];
        
    }
}

-(void)URLSession:(NSURLSession *)session
             task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
    
//    NSLog(@"didCompleteWithError ---%@",error);

    if (self.downStream.downTask == task) {//下行流
        if (error) {
            if(self.downStreamDidCreateBlock){
                self.downStreamDidCreateBlock(NO);
                self.downStreamDidCreateBlock = nil;
            }
            NSString*logText = @"creat down stream";
            if(error.code != 403){
                NSString*log = [NSString stringWithFormat:@"inner call creatDownStream %@",self.downStreamUrl];
                [AlexaChannelImpl.sharedInstance writelog:log];
                [self.downStream creatDownStream:self.downStreamUrl];
            }else {
                if(self.delegate && [self.delegate respondsToSelector:@selector(downStreamDidCompleteWithError:)]) {
                    logText = @"downStreamDidCompleteWithError";
                    [self.delegate downStreamDidCompleteWithError:error];
                }
            }
            NSString*log = [NSString stringWithFormat:@"didCompleteWithError --> error = %ld, %@",error.code,logText];
            [AlexaChannelImpl.sharedInstance writelog:log];
            
        }else{
            if(self.downStreamDidCreateBlock){
              self.downStreamDidCreateBlock = nil;
            }
        }
    }else {//上行流
        NSString * str  =[[NSString alloc] initWithData:self.upStream.receiveData encoding:NSUTF8StringEncoding];
        
        NSString*log = [NSString stringWithFormat:@"didCompleteWithError --> error = %ld, upStream length = %ld",error.code,str.length];
        [AlexaChannelImpl.sharedInstance writelog:log];

//        NSLog(@"didCompleteWithError upTask ---%@, data: %@",error, str);
        if (self.delegate && [self.delegate respondsToSelector:@selector(upStreamReceiveDirectives:)]) {
            [self.delegate upStreamReceiveDirectives:self.upStream.receiveData];
        }
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(upStreamDidCompleteWithError:)]) {
            [self.delegate upStreamDidCompleteWithError:error];
        }
        
        //主动重置下行流
        [self.upStream closeStream];
        
        if (error) {
            if(self.upStreamDidCreateBlock){
                self.upStreamDidCreateBlock(NO);
                self.upStreamDidCreateBlock = nil;
            }
        }else{
            if(self.upStreamDidCreateBlock){
                self.upStreamDidCreateBlock = nil;
            }
        }
    }
}

@end
