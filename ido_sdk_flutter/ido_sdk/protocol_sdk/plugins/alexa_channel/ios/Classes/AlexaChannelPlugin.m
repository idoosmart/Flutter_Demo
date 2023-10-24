//
//  AlexaChannelPlugin.m
//  alexa_channel
//
//  Created by huangkunhe on 2023/9/23.
//

#import "AlexaChannelPlugin.h"
#import "AlexaChannelImpl.h"

@implementation AlexaChannelPlugin


+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    AlexaChannelImpl.sharedInstance.alexaFlutter = [[ApiAlexaFlutter alloc]initWithBinaryMessenger:registrar.messenger];
    ApiAlexaHostSetup(registrar.messenger, AlexaChannelImpl.sharedInstance);
}

@end
