//
//  AlexaDownStream.m
//  IDOAlexaClient
//
//  Created by hedongyang on 2023/9/23.
//

#import "AlexaDownStream.h"
#import "AlexaStreamManager.h"

#define downStreamTimeoutInterval 3600

@interface AlexaDownStream()

@property (nonatomic , strong) NSURLSession * pingSession;

@end

@implementation AlexaDownStream

- (NSURLSession *)pingSession
{
    if (!_pingSession) {
        NSURLSessionConfiguration * config = NSURLSessionConfiguration.defaultSessionConfiguration;
        config.timeoutIntervalForRequest = 30.0f;
        config.shouldUseExtendedBackgroundIdleMode = YES;
        config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        config.URLCache = nil;
        _pingSession = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    }
    return _pingSession;
}

- (void)creatDownStream:(NSString*)url {
    if (self.downTask) {
        [self.downTask cancel];
        self.downTask = nil;
    }
    NSString * accessToken = AlexaStreamManager.shareInstance.accessToken;
    if(accessToken == nil){
        return;
    }
//    NSString * mainUrl = AlexaStreamManager.shareInstance.streamConfig.mainUrl;
//    NSString * directives = AlexaStreamManager.shareInstance.streamConfig.kEvents;
    NSURLSession * streamSession = AlexaStreamManager.shareInstance.streamSession;
    NSURL * urlReq = [NSURL URLWithString:url];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:urlReq];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = downStreamTimeoutInterval;
    [request setValue:[NSString stringWithFormat:@"Bearer %@", accessToken] forHTTPHeaderField:@"Authorization"];
    
    _downTask = [streamSession dataTaskWithRequest:request];
    [_downTask resume];
    
//    NSLog(@" ---------- start creatDownStream stream ");
}

- (void)closeDownStream {
    if (self.downTask) {
        [self.downTask cancel];
        self.downTask = nil;
    }
}

- (void)ping:(void(^)(BOOL success))callback {
    
    NSString * mainUrl = @"";//AlexaStreamManager.shareInstance.streamConfig.mainUrl;
    NSString * ping = @"";//AlexaStreamManager.shareInstance.streamConfig.ping;
    NSString * accessToken = AlexaStreamManager.shareInstance.accessToken;
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mainUrl,ping]];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", accessToken] forHTTPHeaderField:@"Authorization"];
    
    [[self.pingSession dataTaskWithRequest:request
                         completionHandler:^(NSData * _Nullable data,
                                             NSURLResponse * _Nullable response,
                                             NSError * _Nullable error) {
        if (((NSHTTPURLResponse *)response).statusCode != 204) {
            callback(false);
        }else {
            callback(true);
        }
    }] resume] ;
}

@end
