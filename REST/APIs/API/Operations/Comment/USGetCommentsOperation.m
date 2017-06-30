//
//  USGetCommentsOperation.m
//  Usth System
//
//  Created by Serx on 2017/5/26.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import "USGetCommentsOperation.h"
#import "USComment.h"


@implementation USGetCommentsOperation

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
                                                                                       pathPattern:@"/Reply/course/:classId/20/:lastId/:lastTime"
                                                                                           keyPath:@""
                                                                                       statusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 399)]];
    
    [self.objectManager addResponseDescriptorsFromArray:@[responseDescriptor]];
}

-(void)getCommentsWithClassId:(NSString *)classId success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    NSString *encoderStr = [classId stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //let str = subject.name
    //let encoderStr = str?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    [self.objectManager getObject:nil
                             path:[NSString stringWithFormat:@"/Reply/course/%@/20/0/-1", encoderStr]
                       parameters:nil
                          success:success
                          failure:failure];
}

-(void)getNextPageCommentWithClassId:(NSString *)classId lastId:(NSString *)lastId lastTime:(NSString *)lastTime success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    NSString *encoderStr = [classId stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.objectManager getObject:nil
                             path:[NSString stringWithFormat:@"/Reply/course/%@/20/%@/%@", encoderStr, lastId, lastTime]
                       parameters:nil
                          success:success
                          failure:failure];
}

@end
