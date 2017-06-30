//
//  USDiggCommentOperation.h
//  Usth System
//
//  Created by Serx on 2017/5/26.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import "USBaseOperation.h"

@interface USDiggCommentOperation :  USBaseOperation <USBaseOperationProtocol>

-(void)diggCommentWithCommentId: (NSString *)commentId success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

@end
