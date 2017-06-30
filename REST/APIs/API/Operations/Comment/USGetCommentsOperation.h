//
//  USGetCommentsOperation.h
//  Usth System
//
//  Created by Serx on 2017/5/26.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import "USBaseOperation.h"

@class USComment;

@interface USGetCommentsOperation : USBaseOperation <USBaseOperationProtocol>

-(void)getCommentsWithClassId: (NSString *)classId success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

-(void)getNextPageCommentWithClassId: (NSString *)classId lastId:(NSString *)lastId lastTime:(NSString *)lastTime success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

@end
