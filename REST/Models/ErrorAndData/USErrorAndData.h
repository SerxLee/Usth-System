//
//  USErrorAndData.h
//  Usth System
//
//  Created by Serx on 2017/5/19.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USMyInfo.h"
#import "USSemester.h"
#import "USError.h"

@class USErrorAndData;

@protocol USErrorAndDataDelegate <NSObject>

@optional
-(void)loginSuccess: (USErrorAndData *)data;
-(void)loginWithError: (USError *)error;

-(void)getDataSuccess: (USErrorAndData *)data;
-(void)getDataWithError: (USError *)error;

@end

@interface USErrorAndData : NSObject

@property (nonatomic, weak) id<USErrorAndDataDelegate> delegate;

@property (nonatomic) NSInteger errorCode;
@property (nonatomic) NSString *errorReason;

@property (nonatomic) USMyInfo *myInfo;
@property (nonatomic) NSArray *semesterArr;

-(void)loginWithDictionary: (NSDictionary *) dictionary;

-(void)getDataWithDictionary: (NSDictionary *) dictionary;

-(void)storeSubjectResultWithType: (NSString *)type;

+(USErrorAndData *)getStoreSubjectResultWithType: (NSString *)type;

#pragma mark - Serialize and Deserialize
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;

@end
