//
//  USErrorAndData.m
//  Usth System
//
//  Created by Serx on 2017/5/19.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import "USErrorAndData.h"
#import "AppDelegate.h"
#import "USStoreEntity.h"

@implementation USErrorAndData

-(void)getDataWithDictionary:(NSDictionary *)dictionary {
    AppDelegate* appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    ObjectRequestSuccess success = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        USErrorAndData *temp = [[mappingResult dictionary] objectForKey:@""];
        
        if (temp.errorCode == -1) {
            if ([self.delegate respondsToSelector:@selector(getDataWithError:)]) {
                USError *err = [[USError alloc] initWithErrorReason:temp.errorReason];
                [self.delegate getDataWithError: err];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(getDataSuccess:)]) {
                [self.delegate getDataSuccess:temp];
            }
        }
    };
    ObjectRequestFailure failure = ^(RKObjectRequestOperation *operation, NSError *error){
        if ([self.delegate respondsToSelector:@selector(getDataWithError:)]) {
            USError *err = [[USError alloc] initWithResponseError:error];
            [self.delegate getDataWithError: err];
        }
    };
    [appDelegate.operationFactory.subjectResultOperation getSubjectResultWithParameters:dictionary success:success failure:failure];
}

-(void)storeSubjectResultWithType:(NSString *)type {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [USStoreEntity setValue:data withKey:[USErrorAndData createStoreKey:type]];
}

+(USErrorAndData *)getStoreSubjectResultWithType:(NSString *)type {
    NSData *tempData = [USStoreEntity valueWithKey:[self createStoreKey:type]];
    if (tempData == nil){
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
}

+ (NSString *)createStoreKey: (NSString *)type {
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    NSString *key = [NSString stringWithFormat:@"%@ %@", type, userName];
    return key;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSNumber numberWithInteger:self.errorCode] forKey:@"errorCode"];
    [aCoder encodeObject:self.errorReason forKey:@"errorReason"];
    [aCoder encodeObject:self.myInfo forKey:@"myInfo"];
    [aCoder encodeObject:self.semesterArr forKey:@"semesterArr"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        self.errorCode = [[aDecoder decodeObjectForKey:@"errorCode"]integerValue];
        self.errorReason = [aDecoder decodeObjectForKey:@"errorReason"];
        self.myInfo = [aDecoder decodeObjectForKey:@"myInfo"];
        self.semesterArr = [aDecoder decodeObjectForKey:@"semesterArr"];
    }
    return self;
}

@end
