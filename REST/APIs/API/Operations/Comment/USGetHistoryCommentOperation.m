//
//  USGetHistoryCommentOperation.m
//  Usth System
//
//  Created by Serx on 2017/5/30.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import "USGetHistoryCommentOperation.h"
#import "USComment.h"

@implementation USGetHistoryCommentOperation

-(void)addResponseDescriptor {
    RKObjectMapping *commentMapping = [[RKObjectMapping alloc] initWithClass:[USComment class]];
    [commentMapping addAttributeMappingsFromDictionary:@{
                                                         @"err": @"errCode",
                                                         @"reason": @"errReason"
                                                         }];
    
    RKObjectMapping *commentsArrMapping = [[RKObjectMapping alloc] initWithClass:[USComment class]];
    [commentsArrMapping addAttributeMappingsFromDictionary:@{
                                                             @"time": @"time",
                                                             @"authorName": @"authorName",
                                                             @"stuId": @"stuId",
                                                             @"content": @"content",
                                                             @"className": @"className",
                                                             @"digg": @"digg",
                                                             @"id": @"commentId",
                                                             @"refId": @"refId",
                                                             @"RefedAuthorId": @"RefedAuthorId",
                                                             @"refedAuthor": @"refedAuthor",
                                                             @"refedContent": @"refedContent",
                                                             @"digged": @"digged",
                                                             @"head": @"head"
                                                             }];
    [commentMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data" toKeyPath:@"commentsArr" withMapping:commentsArrMapping]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:commentMapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:@"/Reply/UserReply/:stuId"
                                                                                           keyPath:@""
                                                                                       statusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 399)]];
    
    [self.objectManager addResponseDescriptorsFromArray:@[responseDescriptor]];
}

-(void)getHistoryCommentsWithStuId:(NSString *)stuId success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self.objectManager getObject:nil
                             path:[NSString stringWithFormat:@"/Reply/UserReply/%@", stuId]
                       parameters:nil
                          success:success
                          failure:failure];
}


@end
