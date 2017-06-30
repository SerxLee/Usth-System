//
//  USSubject.m
//  Usth System
//
//  Created by Serx on 2017/5/15.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import "USSubject.h"

@implementation USSubject

-(BOOL)isCompulsory {
    if ([self.type isEqualToString:@"必修"]) {
        return true;
    }
    return false;
}

-(BOOL)isOptional {
    if ([self.type isEqualToString:@"选修"]) {
        return true;
    }
    return false;
}

-(BOOL)isNetwork {
    if ([self.type isEqualToString:@"任选"]) {
        return true;
    }
    return false;
}



- (void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:self.subjectId forKey:@"subjectId"];
    [aCoder encodeObject:self.no forKey:@"no"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.en_name forKey:@"en_name"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.no_pass_reason forKey:@"no_pass_reason"];
    [aCoder encodeObject:self.testTime forKey:@"testTime"];
    [aCoder encodeObject:self.score forKey:@"score"];
    [aCoder encodeObject:self.credit forKey:@"credit"];
    //[aCoder encodeObject:[NSNumber numberWithInteger:self.score] forKey:@"score"];
    //[aCoder encodeObject:[NSNumber numberWithBool:self.credit] forKey:@"credit"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        self.subjectId = [aDecoder decodeObjectForKey:@"subjectId"];
        self.no = [aDecoder decodeObjectForKey:@"no"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.en_name = [aDecoder decodeObjectForKey:@"en_name"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.no_pass_reason = [aDecoder decodeObjectForKey:@"no_pass_reason"];
        self.testTime = [aDecoder decodeObjectForKey:@"testTime"];

        //self.score = [[aDecoder decodeObjectForKey:@"score"]integerValue];
        //self.credit = [[aDecoder decodeObjectForKey:@"credit"]integerValue];
        self.score = [aDecoder decodeObjectForKey:@"score"];
        self.credit = [aDecoder decodeObjectForKey:@"credit"];
    }
    return self;
}

@end
