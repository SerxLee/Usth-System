//
//  USLoginHistory.h
//  Usth System
//
//  Created by Serx on 2017/7/11.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USLoginHistory : NSObject

@property (nonatomic) NSString *userNameStr;
@property (nonatomic) NSString *passwordStr;
@property (nonatomic) NSArray *recordArr;

+(USLoginHistory *)getStoreLoginHistory;

-(void)storeLoginHistory;

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;

@end
