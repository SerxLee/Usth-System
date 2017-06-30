//
//  USHeaderToken.h
//  Usth System
//
//  Created by Serx on 2017/5/19.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol USHeaderTokenDelegate <NSObject>

-(void)getHeaderToken: (NSString *)token;
-(void)getHeaderTokenWithError: (NSError *)error;

@end

@interface USHeaderToken : NSObject

@property (weak, nonatomic) id<USHeaderTokenDelegate> delegate;

@property (nonatomic) NSInteger errorCode;
@property (nonatomic) NSString *errorReason;
@property (nonatomic) NSString *token;

-(void)getHeaderToken;

@end
