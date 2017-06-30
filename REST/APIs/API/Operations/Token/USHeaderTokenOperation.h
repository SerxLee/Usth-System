//
//  USHeaderTokenOperation.h
//  Usth System
//
//  Created by Serx on 2017/5/19.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import "USBaseOperation.h"


@interface USHeaderTokenOperation : USBaseOperation <USBaseOperationProtocol>

-(void)getHeaderToken:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure;

@end
