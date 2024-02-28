//
//  AlexaChannelImpl.h
//  alexa_channel
//
//  Created by hc on 2023/9/23.
//

#import <Foundation/Foundation.h>

#import "Alexa.g.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlexaChannelImpl: NSObject<ApiAlexaHost>

+ (instancetype)sharedInstance;

@property (nonatomic,strong)ApiAlexaFlutter * alexaFlutter;

-(void)writelog:(NSString*)log;

@end

NS_ASSUME_NONNULL_END
