//
//  USOperationFactory.h
//  Usth System
//
//  Created by Serx on 2017/5/18.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "USSubjectResultOperation.h"
#import "USHeaderTokenOperation.h"

#import "USReplyCommentOperation.h"
#import "USDiggCommentOperation.h"
#import "USPublishNewCommentOperation.h"
#import "USGetCommentsOperation.h"
#import "USGetHistoryCommentOperation.h"



@interface USOperationFactory : NSObject

- (instancetype)initWithAccessToken:(NSString *)theAccessToken acceptMIMEType:(NSString *)MIMEType APIServerURI:(NSURL *)URI;

@property (nonatomic) USSubjectResultOperation *subjectResultOperation;
@property (nonatomic) USHeaderTokenOperation *headerTokenOperation;

@property (nonatomic) USReplyCommentOperation *replyCommentOperation;
@property (nonatomic) USDiggCommentOperation *diggCommentOperation;
@property (nonatomic) USPublishNewCommentOperation *publishNewCommentOperation;
@property (nonatomic) USGetCommentsOperation *getCommentsOperation;
@property (nonatomic) USGetHistoryCommentOperation *getHistoryCommentOperation;
@end
