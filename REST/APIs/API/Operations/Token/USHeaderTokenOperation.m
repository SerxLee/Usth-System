//
//  USHeaderTokenOperation.m
//  Usth System
//
//  Created by Serx on 2017/5/19.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import "USHeaderTokenOperation.h"
#import "USHeaderToken.h"

@implementation USHeaderTokenOperation

-(void)addResponseDescriptor {
    RKObjectMapping *headerTokenMapping = [[RKObjectMapping alloc] initWithClass: [USHeaderToken class]];
    
    [headerTokenMapping addAttributeMappingsFromDictionary:@{
                                                             @"err": @"errorCode",
                                                             @"data": @"token",
                                                             @"reason": @"errorReason"
                                                             }];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:headerTokenMapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:@"/head/getToken"
                                                                                           keyPath:@""
                                                                                       statusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 399)]];
    [self.objectManager addResponseDescriptorsFromArray:@[responseDescriptor]];
}

-(void)getHeaderToken:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self.objectManager getObjectsAtPath:@"/head/getToken" parameters:nil success:success failure:failure];
}


@end
