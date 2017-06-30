//
//  USReplyCommentOperation.h
//  Usth System
//
//  Created by Serx on 2017/5/26.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import "USBaseOperation.h"

@interface USReplyCommentOperation : USBaseOperation <USBaseOperationProtocol>

-(void)replyCommentWithParameters: (NSDictionary *)parameters andClassId: (NSString *)classId  andCommentId:(NSString *)commentId success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

@end
