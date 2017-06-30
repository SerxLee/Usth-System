//
//  USSemester.h
//  Usth System
//
//  Created by Serx on 2017/5/19.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USSubject.h"

@interface USSemester : NSObject

@property (nonatomic) NSString *semesterName;
@property (nonatomic) NSArray *subjectArr;


#pragma mark - Serialize and Deserialize
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;

@end
