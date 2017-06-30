//
//  USDiggCommentOperation.m
//  Usth System
//
//  Created by Serx on 2017/5/26.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import "USDiggCommentOperation.h"
#import "USComment.h"

@implementation USDiggCommentOperation

-(void)addResponseDescriptor {
    RKObjectMapping *commentMapping = [[RKObjectMapping alloc] initWithClass:[USComment class]];
    [commentMapping addAttributeMappingsFromDictionary:@{
                                                         @"err": @"errCode",
                                                         @"data": @"digged",
                                                         @"reason": @"errReason"
                                                         }];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:commentMapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:@"/Reply/:commentId/digg/add"
                                                                                           keyPath:@""
                                                                                       statusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 399)]];
    
    [self.objectManager addResponseDescriptorsFromArray:@[responseDescriptor]];
    
}

-(void)diggCommentWithCommentId:(NSString *)commentId success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self.objectManager postObject:nil
                              path:[NSString stringWithFormat:@"/Reply/%@/digg/add", commentId]
                        parameters:nil
                           success:success
                           failure:failure];
}

@end
