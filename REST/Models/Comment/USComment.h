//
//  USComment.h
//  Usth System
//
//  Created by Serx on 2017/5/26.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USError.h"

@class USComment;

@protocol USCommentDelegate <NSObject>

@optional
-(void)getCommentsSuccess: (USComment *)comment;
-(void)getCommentsWithError: (USError *)error;

-(void)getNextPageCommentsSuccess: (USComment *)comment;
-(void)getNextPageCommentsWithError: (USError *)error;

-(void)publishCommentSuccess: (USComment *)comment;
-(void)publishCommentsWithError: (USError *)error;

-(void)replyCommentSuccess: (USComment *)comment;
-(void)replyCommentWithError: (USError *)error;

-(void)diggCommentSuccess: (USComment *)comment;
-(void)diggCommentWithError: (USError *)error;

-(void)getHistoryCommentsSuccess: (USComment *)comment;
-(void)getHistoryCommentsWithError: (USError *)error;

@end

@interface USComment : NSObject

@property (weak, nonatomic) id<USCommentDelegate> delegate;

@property (nonatomic) USComment *lastComment;

@property (nonatomic) NSInteger errCode;
@property (nonatomic) NSString *errReason;
@property (nonatomic) NSArray *commentsArr;

@property (nonatomic) NSString *time;
@property (nonatomic) NSString *authorName;
@property (nonatomic) NSString *stuId;
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *className;
@property (nonatomic) NSNumber *digg;
@property (nonatomic) NSString *commentId;
@property (nonatomic) NSString *refId;
@property (nonatomic) NSString *RefedAuthorId;
@property (nonatomic) NSString *refedAuthor;
@property (nonatomic) NSString *refedContent;
@property (nonatomic) NSNumber *digged;
@property (nonatomic) NSString *head;

-(void)getHistoryCommentsWithStuId: (NSString *)stuId;

//获取某个课程评论列表
-(void)getCommentsWithClassId: (NSString *)classId;

//-(void)getCommentsWithClassId: (NSString *)classId andCommentsCount:(NSInteger)commentsCount;


//获取下一页评论数据
-(void)getNextPageComments;

//发布新评论
-(void)publishNewCommentWithParameters: (NSDictionary *)parameters andClassId: (NSString *)classId;

-(void)replyCommentWithParameters: (NSDictionary *)parameters andClassId: (NSString *)classId andRefId:(NSString *)refId;

-(void)diggCommentWithCommentId: (NSString *)commentId;

@end
