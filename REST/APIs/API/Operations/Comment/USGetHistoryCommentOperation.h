//
//  USGetHistoryCommentOperation.h
//  Usth System
//
//  Created by Serx on 2017/5/30.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import "USBaseOperation.h"

@interface USGetHistoryCommentOperation : USBaseOperation <USBaseOperationProtocol>

-(void)getHistoryCommentsWithStuId: (NSString *)stuId success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;


@end
