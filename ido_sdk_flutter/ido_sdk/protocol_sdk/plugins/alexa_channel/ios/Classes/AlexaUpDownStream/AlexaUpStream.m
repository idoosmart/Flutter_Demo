//
//  AlexaUpStream.m
//  IDOAlexaClient
//
//  Created by huangkunhe on 2023/9/23.
//

#import "AlexaUpStream.h"
#import "AlexaStreamManager.h"

#define kUpStreamBufferSize 320

@interface AlexaUpStream()<NSStreamDelegate>

@property (nonatomic , strong , nullable) NSOutputStream *output;
@property (nonatomic , assign) BOOL canWrite;
@property (nonatomic , strong) NSMutableData *cacheData;
@property (nonatomic , assign) NSInteger byteIndex;
@property (nonatomic , strong) dispatch_queue_t streamQueue;
@property (nonatomic , strong)NSString *uniqueID;

@end

@implementation AlexaUpStream


#pragma mark ************** streamQueue **************

/**< 配对输入输出流 */
-(void)createOutInput{
    self.canWrite = NO;
    NSInputStream *inputStream = nil;
    NSOutputStream *outputStream = nil;
    [NSStream getBoundStreamsWithBufferSize:kUpStreamBufferSize inputStream:&inputStream outputStream:&outputStream];
    _input = inputStream;
    _output = outputStream;
    if (!_input || !_output) {
        return;
    }
    _output.delegate = self;
    [_output scheduleInRunLoop:NSRunLoop.currentRunLoop forMode:NSDefaultRunLoopMode];
    [_output open];
}

- (void)creatStream:(NSData*)uniqueIDdata url:(NSString*)url{
    NSString * accessToken = AlexaStreamManager.shareInstance.accessToken;

    if(accessToken == nil){
//        NSLog(@"creatupStream重新创建流--> accessToken == nil");
        return;
    }
    
    /**< 重新创建流 */
    [self closeStream];
    [self createOutInput];
    
//    NSLog(@"creatupStream重新创建流--> url == %@",url);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST";
    [request setValue:@"multipart/form-data; boundary=BOUNDARY_TERM_HERE" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", accessToken] forHTTPHeaderField:@"Authorization"];
    
    _task = [AlexaStreamManager.shareInstance.streamSession uploadTaskWithStreamedRequest:request];//dataTaskWithRequest
    [_task resume];
        
    self.byteIndex = 0;
        
    [self uploadStreamWithData:[AlexaUpStream streameventBody:uniqueIDdata]];
    
}

/**< 关闭流 */
-(void)closeStream{
        
    self.cacheData = NSMutableData.new;
    self.receiveData = NSMutableData.new;
    
    [self closeOutputStream];
    [self closeInputStream];
    
    if (_task) {
        /**< 取消上个流 */
        [_task cancel];
        _task = nil;
    }
}

-(void)closeInputStream{
    if (!self.input) {
        return;
    }
    [self.input close];
    self.input = nil;
}

-(void)closeOutputStream{
    if (!self.output) {
        return;
    }
    [self.output removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    self.output.delegate = nil;
    [self.output close];
    self.output = nil;
    self.cacheData = NSMutableData.new;
}

-(void)uploadStreamWithData:(NSData *)data{
    dispatch_async(self.streamQueue, ^{
        if (data) {
            [self.cacheData appendData:data];
        }
        if (!self.canWrite) {
            return;
        }
        if (!self.output.hasSpaceAvailable) {
            return;
        }
        [self writeToStream];
    });
}

-(void)writeToStream{
    NSInteger len = 0;
    NSUInteger data_len = [self.cacheData length];
    NSUInteger remain_len = data_len - self.byteIndex;
    len = MIN(remain_len, kUpStreamBufferSize);
    if (len == 0) {
        self.canWrite = YES;
        return;
    }

    uint8_t buf[len];
    if (self.byteIndex + len > self.cacheData.length) {
        return;
    }
    [self.cacheData getBytes:buf range:NSMakeRange(self.byteIndex, len)];

    len = [self.output write:(const uint8_t *)buf maxLength:len];
    self.byteIndex += len;
//    NSLog(@"____数据写入流 = %ld 已上传 = %ld , 总数据 = %ld",len,self.byteIndex,self.cacheData.length);
}

- (void)endListenningStream {
    [self uploadStreamWithData:[AlexaUpStream endData]];
    [self closeOutputStream];
}


#pragma mark ************** NSStreamDelegate **************
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    if (aStream != _output) {
        return;
    }
    switch (eventCode) {
        case NSStreamEventNone:
            break;
            
        case NSStreamEventOpenCompleted:
//            NSLog(@"NSStreamEventOpenCompleted");
            break;
        case NSStreamEventHasBytesAvailable: {
        } break;
            
        case NSStreamEventHasSpaceAvailable: {
//            NSLog(@"NSStreamEventHasSpaceAvailable");
            if (aStream == self.output) {
                _canWrite = YES;
                [self uploadStreamWithData:nil];
            }
        } break;
            
        case NSStreamEventErrorOccurred:
        case NSStreamEventEndEncountered:
            [aStream close];
            [aStream removeFromRunLoop:NSRunLoop.currentRunLoop forMode:NSDefaultRunLoopMode];
            aStream = nil;
            break;
            
        default:
            break;
    }
    
}

#pragma mark ************** lazy **************
-(NSMutableData *)receiveData{
    if (!_receiveData) {
        _receiveData = [NSMutableData data];
    }
    return _receiveData;
}

-(dispatch_queue_t)streamQueue{
    if (!_streamQueue) {
        _streamQueue = dispatch_queue_create("Alexa.stream.upload", DISPATCH_QUEUE_SERIAL);
    }
    return _streamQueue;
}

-(NSMutableData *)cacheData{
    if (!_cacheData) {
        _cacheData = [NSMutableData new];
    }
    return _cacheData;
}

+ (NSMutableData *)streameventBody:(NSData *)data{
    NSMutableData *body = [NSMutableData data];
    [body appendData:AlexaUpStream.segmentationData];
    [body appendData:[AlexaUpStream JSONHeaders]];
    [body appendData:[AlexaUpStream steamContent:data]];
    [body appendData:AlexaUpStream.segmentationData];
    [body appendData:[AlexaUpStream binaryAudioHeaders]];
    return body;
}

+(NSData *)segmentationData{
    return [@"--BOUNDARY_TERM_HERE\r\n" dataUsingEncoding:NSUTF8StringEncoding];
}

+(NSData *)endData{
    return [@"\r\n\r\n--BOUNDARY_TERM_HERE--\r\n" dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSData *)JSONHeaders {
    NSMutableData *mutdata = [NSMutableData data];
    [mutdata appendData: [@"Content-Disposition: form-data; name=\"metadata\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [mutdata appendData: [@"Content-Type: application/json; charset=UTF-8\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    return mutdata;
}

+ (NSData *)binaryAudioHeaders {
    NSMutableData *mutdata = [NSMutableData data];
    [mutdata appendData: [@"Content-Disposition: form-data; name=\"audio\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [mutdata appendData: [@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    return mutdata;
}

+ (NSMutableData *)steamContent:(NSData *)data{
    NSMutableData *mutData = [NSMutableData dataWithData:data];
    [mutData appendData:[@"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    return mutData;
}

@end

