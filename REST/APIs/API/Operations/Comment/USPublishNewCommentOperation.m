//
//  USPublishNewCommentOperation.m
//  Usth System
//
//  Created by Serx on 2017/5/26.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import "USPublishNewCommentOperation.h"
#import "USComment.h"


@implementation USPublishNewCommentOperation

-(void)addResponseDescriptor {
    RKObjectMapping *commentMapping = [[RKObjectMapping alloc] initWithClass:[USComment class]];
    [commentMapping addAttributeMappingsFromDictionary:@{
                                                             @"err": @"errCode",
                                                             @"data": @"commentId",
                                                             @"reason": @"errReason"
                                                             }];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:commentMapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:@"/Reply/course/:classId"
                                                                                           keyPath:@""
                                                                                       statusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 399)]];
    
    [self.objectManager addResponseDescriptorsFromArray:@[responseDescriptor]];

}

-(void)publishNewCommentWith:(NSDictionary *)parameters classId:(NSString *)classId success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    NSString *encoderStr = [classId stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    [self.objectManager postObject:nil
                              path:[NSString stringWithFormat:@"/Reply/course/%@", encoderStr]
                        parameters:parameters
                           success:success
                           failure:failure];

}

@end
