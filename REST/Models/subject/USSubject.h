//
//  USSubject.h
//  Usth System
//
//  Created by Serx on 2017/5/15.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USSubject : NSObject

@property (nonatomic) NSString *subjectId;
@property (nonatomic) NSString *no;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *en_name;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *no_pass_reason;
@property (nonatomic) NSString *testTime;
@property (nonatomic) NSNumber* score;
@property (nonatomic) NSNumber* credit;

-(BOOL)isCompulsory;
-(BOOL)isOptional;
-(BOOL)isNetwork;

#pragma mark - Serialize and Deserialize
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;

@end
