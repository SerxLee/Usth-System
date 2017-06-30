//
//  USBaseOperation.m
//  Usth System
//
//  Created by Serx on 2017/5/18.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import "USBaseOperation.h"

@implementation USBaseOperation

-(instancetype)initWithObjectManager:(RKObjectManager *)theObjectManager {
    self = [super init];
    if ([self conformsToProtocol:@protocol(USBaseOperationProtocol)]) {
        //注册要缓存的接口
        _requestesNeedCache = [NSMutableArray new];
        _objectManager = theObjectManager;
        self.child = (id<USBaseOperationProtocol>)self;
        [self.child addResponseDescriptor];
        
    }else {
        // 不遵守这个protocol的就让他crash，防止派生类乱来。
        NSAssert(NO, @"子类必须要实现APIManager这个protocol。");
    }
    return self;
}

@end
