//
//  Element.m
//  DHSFit
//
//  Created by liwei qiao on 2023/8/11.
//

#import "Element.h"

@implementation Element

- (instancetype)init{
    if (self = [super init]){
        _anchor = 9;
        _hasAlpha = 1;
        _blackTransparent = 1;
        _leftOffset = 0;
        _x = 0;
        _y = 0;
        _imageCount = 1;
    }
    return self;
}

@end
