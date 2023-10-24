//
//  AlexaUpStream.h
//  IDOAlexaClient
//
//  Created by huangkunhe on 2023/9/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlexaUpStream : NSObject

@property (nonatomic , strong) NSURLSessionUploadTask *task;


@property (nonatomic , strong , nullable) NSInputStream *input;

@property (nonatomic , strong) NSMutableData *receiveData;


//创建上行流
- (void)creatStream:(NSData*)uniqueIDdata url:(NSString*)url;

//关闭上行流
-(void)closeStream;

/**< 结束聆听 或者 停止输出流*/
- (void)endListenningStream;

/**< 上传数据 */
-(void)uploadStreamWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
