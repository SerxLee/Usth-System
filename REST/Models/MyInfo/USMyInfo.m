//
//  USMyInfo.m
//  Usth System
//
//  Created by Serx on 2017/5/19.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import "USMyInfo.h"
#import "USStoreEntity.h"

#define TYPE_IDENTIFY @"StoreUserInfo"

@implementation USMyInfo

- (void)storeMyInfo{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [USStoreEntity setValue:data withKey:TYPE_IDENTIFY];
}

+(USMyInfo *)getStoredUser {
    NSData *tempData = [USStoreEntity valueWithKey:TYPE_IDENTIFY];
    if (tempData == nil){
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.stu_id forKey:@"stu_id"];
    [aCoder encodeObject:self.stu_name forKey:@"stu_name"];
    [aCoder encodeObject:self.stu_class forKey:@"stu_class"];
    [aCoder encodeObject:self.stu_header forKey:@"stu_header"];
}


- (id)initWithCoder:(NSCoder *)aDecoder {

    if (self = [self init]) {
        self.stu_header = [aDecoder decodeObjectForKey:@"stu_header"];
        self.stu_class = [aDecoder decodeObjectForKey:@"stu_class"];
        self.stu_name = [aDecoder decodeObjectForKey:@"stu_name"];
        self.stu_id = [aDecoder decodeObjectForKey:@"stu_id"];

    }
    return self;
}

@end
