//
//  USPassingSubjectOperation.h
//  Usth System
//
//  Created by Serx on 2017/5/19.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import "USBaseOperation.h"

@interface USSubjectResultOperation :USBaseOperation <USBaseOperationProtocol>

-(void)getPassingSubjectResule:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

-(void)getSubjectResultWithParameters:(NSDictionary *)parameters success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

@end
