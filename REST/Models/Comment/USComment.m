//
//  USComment.m
//  Usth System
//
//  Created by Serx on 2017/5/26.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import "USComment.h"
#import "AppDelegate.h"

@implementation USComment

-(void)getCommentsWithClassId:(NSString *)classId {
    AppDelegate* appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    ObjectRequestSuccess success = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        USComment *comment = [mappingResult.dictionary objectForKey:@""];
        if (comment.errCode == -1) {
            if ([self.delegate respondsToSelector:@selector(getCommentsWithError:)]) {
                USError *err = [[USError alloc] initWithErrorReason:comment.errReason];
                [self.delegate getCommentsWithError: err];
            }
        } else {
            [self getLaStComment:comment];
            if ([self.delegate respondsToSelector:@selector(getCommentsSuccess:)]) {
                [self.delegate getCommentsSuccess:comment];
            }
        }
    };
    ObjectRequestFailure failure = ^(RKObjectRequestOperation *operation, NSError *error){
        if ([self.delegate respondsToSelector:@selector(getCommentsWithError:)]) {
            USError *err = [[USError alloc] initWithResponseError:error];
            [self.delegate getCommentsWithError: err];
        }
    };
    [appDelegate.operationFactory.getCommentsOperation getCommentsWithClassId:classId success:success failure:failure];
}

-(void)getNextPageComments {
    AppDelegate* appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    ObjectRequestSuccess success = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        USComment *comment = [mappingResult.dictionary objectForKey:@""];
        
        if (comment.errCode == -1) {
            if ([self.delegate respondsToSelector:@selector(getNextPageCommentsWithError:)]) {
                USError *err = [[USError alloc] initWithErrorReason:comment.errReason];
                [self.delegate getNextPageCommentsWithError:err];
            }
        } else {
            [self getLaStComment:comment];
            if ([self.delegate respondsToSelector:@selector(getNextPageCommentsSuccess:)]) {
                [self.delegate getNextPageCommentsSuccess:comment];
            }
        }
    };
    ObjectRequestFailure failure = ^(RKObjectRequestOperation *operation, NSError *error){
        if ([self.delegate respondsToSelector:@selector(getNextPageCommentsWithError:)]) {
            USError *err = [[USError alloc] initWithResponseError:error];
            [self.delegate getNextPageCommentsWithError:err];
        }
    };
    [appDelegate.operationFactory.getCommentsOperation getNextPageCommentWithClassId:self.lastComment.className lastId:self.lastComment.commentId lastTime:self.lastComment.time success:success failure:failure];
}

-(void)getHistoryCommentsWithStuId:(NSString *)stuId {
    AppDelegate* appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    ObjectRequestSuccess success = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        USComment *comment = [mappingResult.dictionary objectForKey:@""];
        if (comment.errCode == -1) {
            if ([self.delegate respondsToSelector:@selector(getHistoryCommentsWithError:)]) {
                USError *err = [[USError alloc] initWithErrorReason:comment.errReason];
                [self.delegate getHistoryCommentsWithError: err];
            }
        } else {
            [self getLaStComment:comment];
            if ([self.delegate respondsToSelector:@selector(getHistoryCommentsSuccess:)]) {
                [self.delegate getHistoryCommentsSuccess:comment];
            }
        }
    };
    ObjectRequestFailure failure = ^(RKObjectRequestOperation *operation, NSError *error){
        if ([self.delegate respondsToSelector:@selector(getHistoryCommentsWithError:)]) {
            USError *err = [[USError alloc] initWithResponseError:error];
            [self.delegate getHistoryCommentsWithError: err];
        }
    };
    [appDelegate.operationFactory.getHistoryCommentOperation getHistoryCommentsWithStuId:stuId success:success failure:failure];
}

-(void)replyCommentWithParameters:(NSDictionary *)parameters andClassId:(NSString *)classId andRefId:(NSString *)refId {
    AppDelegate* appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    ObjectRequestSuccess success = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        USComment *comment = [mappingResult.dictionary objectForKey:@""];
        [self getLaStComment:comment];
        if ([self.delegate respondsToSelector:@selector(replyCommentSuccess:)]) {
            [self.delegate replyCommentSuccess:comment];
        }
    };
    ObjectRequestFailure failure = ^(RKObjectRequestOperation *operation, NSError *error){
        NSError *temp = error;
    };
    [appDelegate.operationFactory.replyCommentOperation replyCommentWithParameters:parameters andClassId:classId andCommentId:refId success:success failure:failure];
}

-(void)publishNewCommentWithParameters:(NSDictionary *)parameters andClassId:(NSString *)classId {
    AppDelegate* appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    ObjectRequestSuccess success = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        USComment *comment = [mappingResult.dictionary objectForKey:@""];
        [self getLaStComment:comment];
        if ([self.delegate respondsToSelector:@selector(publishCommentSuccess:)]) {
            [self.delegate publishCommentSuccess:comment];
        }
    };
    ObjectRequestFailure failure = ^(RKObjectRequestOperation *operation, NSError *error){
        NSError *temp = error;
    };
    [appDelegate.operationFactory.publishNewCommentOperation publishNewCommentWith:parameters classId:classId success:success failure:failure];
}

-(void)diggCommentWithCommentId:(NSString *)commentId {
    AppDelegate* appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    ObjectRequestSuccess success = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        USComment *comment = [mappingResult.dictionary objectForKey:@""];
        [self getLaStComment:comment];
        if ([self.delegate respondsToSelector:@selector(diggCommentSuccess:)]) {
            [self.delegate diggCommentSuccess:comment];
        }
    };
    ObjectRequestFailure failure = ^(RKObjectRequestOperation *operation, NSError *error){
        NSError *temp = error;
    };
    [appDelegate.operationFactory.diggCommentOperation diggCommentWithCommentId:commentId success:success failure:failure];
}

-(void)getLaStComment: (USComment *)comments {
    NSArray *commentsArr = comments.commentsArr;
    self.lastComment = commentsArr.lastObject;
}


@end
