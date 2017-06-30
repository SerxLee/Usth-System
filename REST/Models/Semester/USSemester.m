//
//  USSemester.m
//  Usth System
//
//  Created by Serx on 2017/5/19.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import "USSemester.h"
#import "USSubject.h"

@implementation USSemester

- (void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:self.semesterName forKey:@"semesterName"];
    [aCoder encodeObject:self.subjectArr forKey:@"subjectArr"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        self.semesterName = [aDecoder decodeObjectForKey:@"semesterName"];
        self.subjectArr = [aDecoder decodeObjectForKey:@"subjectArr"];
    }
    return self;
}


@end
