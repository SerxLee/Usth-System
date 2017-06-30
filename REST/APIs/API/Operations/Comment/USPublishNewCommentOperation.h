//
//  USPublishNewCommentOperation.h
//  Usth System
//
//  Created by Serx on 2017/5/26.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import "USBaseOperation.h"

@interface USPublishNewCommentOperation : USBaseOperation <USBaseOperationProtocol>

-(void)publishNewCommentWith:(NSDictionary *)parameters classId:(NSString *)classId success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;


@end
