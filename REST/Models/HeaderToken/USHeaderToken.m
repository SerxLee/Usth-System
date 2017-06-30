//
//  USHeaderToken.m
//  Usth System
//
//  Created by Serx on 2017/5/19.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import "USHeaderToken.h"
#import "AppDelegate.h"

@implementation USHeaderToken

-(void)getHeaderToken {
    AppDelegate* appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    ObjectRequestSuccess success = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        NSDictionary *temp = [mappingResult dictionary];
        USHeaderToken *tempToken = [temp objectForKey:@""];
        if ([self.delegate respondsToSelector:@selector(getHeaderToken:)] ){
            [self.delegate getHeaderToken:tempToken.token];
        }
    };
    ObjectRequestFailure failure = ^(RKObjectRequestOperation *operation, NSError *error){
        NSError *temp = error;
    };
    [appDelegate.operationFactory.headerTokenOperation getHeaderToken:success failure:failure];
}

@end
