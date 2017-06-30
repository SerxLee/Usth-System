//
//  USMyInfo.h
//  Usth System
//
//  Created by Serx on 2017/5/19.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USMyInfo : NSObject

@property (nonatomic) NSString *stu_id;
@property (nonatomic) NSString *stu_name;
@property (nonatomic) NSString *stu_class;
@property (nonatomic) NSString *stu_header;

-(void)storeMyInfo;

+(USMyInfo*)getStoredUser;

//序列号与反序列号
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;

@end
