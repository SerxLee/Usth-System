//
//  USBaseOperation.h
//  Usth System
//
//  Created by Serx on 2017/5/18.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"

typedef void (^ObjectRequestSuccess)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult);
typedef void (^ObjectRequestFailure)(RKObjectRequestOperation *operation, NSError *error);

@protocol USBaseOperationProtocol <NSObject>

@required
-(void)addResponseDescriptor;

@optional
-(void)addRequestDescriptor;

@end

@interface USBaseOperation : NSObject
@property (nonatomic,copy) ObjectRequestSuccess beforeSuccess;
@property (nonatomic,copy) ObjectRequestSuccess afterSuccess;
@property (nonatomic,copy) ObjectRequestFailure beforeFailure;
@property (nonatomic,copy) ObjectRequestFailure afterFailure;

//需要缓存的接口
@property (nonatomic) NSMutableArray *requestesNeedCache;
//注册不需要证书接口
@property (nonatomic) NSArray *requestesNotNeedToken;
@property (nonatomic, weak) id<USBaseOperationProtocol> child;
@property (nonatomic) RKObjectManager *objectManager;
- (instancetype)initWithObjectManager:(RKObjectManager *)theObjectManager;


@end
