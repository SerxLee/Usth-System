//
//  USLoginHistory.m
//  Usth System
//
//  Created by Serx on 2017/7/11.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import "USLoginHistory.h"
#import "USStoreEntity.h"

#define USER_LOGIN_IDENTIFIER @"StoreLoginHistory"

@implementation USLoginHistory

-(void)storeLoginHistory {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [USStoreEntity setValue:data withKey:USER_LOGIN_IDENTIFIER];
}

+(USLoginHistory *)getStoreLoginHistory {
    NSData *tempData = [USStoreEntity valueWithKey:USER_LOGIN_IDENTIFIER];
    if (tempData == nil){
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.userNameStr forKey:@"userNameStr"];
    [aCoder encodeObject:self.passwordStr forKey:@"passwordStr"];
    [aCoder encodeObject:self.recordArr forKey:@"recordArr"];

}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        self.userNameStr = [aDecoder decodeObjectForKey:@"userNameStr"];
        self.passwordStr = [aDecoder decodeObjectForKey:@"passwordStr"];
        self.recordArr = [aDecoder decodeObjectForKey:@"recordArr"];
    }
    return self;
}

@end
