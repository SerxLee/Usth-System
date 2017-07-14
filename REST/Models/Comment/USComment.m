//
//  USComment.m
//  Usth System
//
//  Created by Serx on 2017/5/26.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import "USComment.h"
#import "AppDelegate.h"
#import "USStoreEntity.h"

@implementation USComment

-(void)storeComment {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [USStoreEntity setValue:data withKey:[USComment createStoreKey]];
}

+(USComment *)getStoreComment {
    NSData *tempData = [USStoreEntity valueWithKey:[USComment createStoreKey]];
    if (tempData == nil){
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
}

+ (NSString *)createStoreKey {
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    NSString *key = [NSString stringWithFormat:@"COMMENT-%@", userName];
    return key;
}

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
        if (comment.errCode == -1) {
            if ([self.delegate respondsToSelector:@selector(replyCommentWithError:)]) {
                USError *err = [[USError alloc] initWithErrorReason:comment.errReason];
                [self.delegate replyCommentWithError:err];
            }
        }
        else {
            [self getLaStComment:comment];
            if ([self.delegate respondsToSelector:@selector(replyCommentSuccess:)]) {
                [self.delegate replyCommentSuccess:comment];
            }
        }
    };
    ObjectRequestFailure failure = ^(RKObjectRequestOperation *operation, NSError *error){
        if ([self.delegate respondsToSelector:@selector(replyCommentWithError:)]) {
            USError *err = [[USError alloc] initWithResponseError:error];
            [self.delegate replyCommentWithError:err];
        }
    };
    [appDelegate.operationFactory.replyCommentOperation replyCommentWithParameters:parameters andClassId:classId andCommentId:refId success:success failure:failure];
}

-(void)publishNewCommentWithParameters:(NSDictionary *)parameters andClassId:(NSString *)classId {
    AppDelegate* appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    ObjectRequestSuccess success = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        USComment *comment = [mappingResult.dictionary objectForKey:@""];
        if (comment.errCode == -1) {
            if ([self.delegate respondsToSelector:@selector(publishCommentsWithError:)]) {
                USError *err = [[USError alloc] initWithErrorReason:comment.errReason];
                [self.delegate publishCommentsWithError:err];
            }
        }
        else {
            [self getLaStComment:comment];
            if ([self.delegate respondsToSelector:@selector(publishCommentSuccess:)]) {
                [self.delegate publishCommentSuccess:comment];
            }
        }
    };
    ObjectRequestFailure failure = ^(RKObjectRequestOperation *operation, NSError *error){
        if ([self.delegate respondsToSelector:@selector(publishCommentsWithError:)]) {
            USError *err = [[USError alloc] initWithResponseError:error];
            [self.delegate publishCommentsWithError:err];
        }
    };
    [appDelegate.operationFactory.publishNewCommentOperation publishNewCommentWith:parameters classId:classId success:success failure:failure];
}

-(void)diggCommentWithCommentId:(NSString *)commentId {
    AppDelegate* appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    ObjectRequestSuccess success = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        USComment *comment = [mappingResult.dictionary objectForKey:@""];
        if (comment.errCode == -1) {
            if ([self.delegate respondsToSelector:@selector(diggCommentWithError:)]) {
                USError *err = [[USError alloc] initWithErrorReason:comment.errReason];
                [self.delegate diggCommentWithError:err];
            }
        }
        else {
            [self getLaStComment:comment];
            if ([self.delegate respondsToSelector:@selector(diggCommentSuccess:)]) {
                [self.delegate diggCommentSuccess:comment];
            }
        }
    };
    ObjectRequestFailure failure = ^(RKObjectRequestOperation *operation, NSError *error){
        if ([self.delegate respondsToSelector:@selector(diggCommentWithError:)]) {
            USError *err = [[USError alloc] initWithResponseError:error];
            [self.delegate diggCommentWithError:err];
        }
    };
    [appDelegate.operationFactory.diggCommentOperation diggCommentWithCommentId:commentId success:success failure:failure];
}

-(void)getLaStComment: (USComment *)comments {
    NSArray *commentsArr = comments.commentsArr;
    self.lastComment = commentsArr.lastObject;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSNumber numberWithInteger:self.errCode] forKey:@"errCode"];
    [aCoder encodeObject:self.errReason forKey:@"errReason"];
    [aCoder encodeObject:self.commentsArr forKey:@"commentsArr"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.authorName forKey:@"authorName"];
    [aCoder encodeObject:self.stuId forKey:@"stuId"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.className forKey:@"className"];
    [aCoder encodeObject:self.digg forKey:@"digg"];
    [aCoder encodeObject:self.commentId forKey:@"commentId"];
    [aCoder encodeObject:self.refId forKey:@"refId"];
    [aCoder encodeObject:self.RefedAuthorId forKey:@"RefedAuthorId"];
    [aCoder encodeObject:self.refedAuthor forKey:@"refedAuthor"];
    [aCoder encodeObject:self.refedContent forKey:@"refedContent"];
    [aCoder encodeObject:self.digged forKey:@"digged"];
    [aCoder encodeObject:self.head forKey:@"head"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        self.errCode = [[aDecoder decodeObjectForKey:@"errCode"]integerValue];
        self.errReason = [aDecoder decodeObjectForKey:@"errReason"];
        self.commentsArr = [aDecoder decodeObjectForKey:@"commentsArr"];
        self.time = [aDecoder decodeObjectForKey:@"time"];
        self.authorName = [aDecoder decodeObjectForKey:@"authorName"];
        self.stuId = [aDecoder decodeObjectForKey:@"stuId"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.className = [aDecoder decodeObjectForKey:@"className"];
        self.digg = [aDecoder decodeObjectForKey:@"digg"];
        self.commentId = [aDecoder decodeObjectForKey:@"commentId"];
        self.refId = [aDecoder decodeObjectForKey:@"refId"];
        self.RefedAuthorId = [aDecoder decodeObjectForKey:@"RefedAuthorId"];
        self.refedAuthor = [aDecoder decodeObjectForKey:@"refedAuthor"];
        self.refedContent = [aDecoder decodeObjectForKey:@"refedContent"];
        self.digged = [aDecoder decodeObjectForKey:@"digged"];
        self.head = [aDecoder decodeObjectForKey:@"head"];
    }
    return self;
}

@end
