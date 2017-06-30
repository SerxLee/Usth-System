//
//  USPassingSubjectOperation.m
//  Usth System
//
//  Created by Serx on 2017/5/19.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import "USSubjectResultOperation.h"
#import "USErrorAndData.h"
#import "USSemester.h"
#import "USMyInfo.h"
#import "USSubject.h"

@implementation USSubjectResultOperation

-(void)addResponseDescriptor {
    RKObjectMapping *errAndDataMapping = [RKObjectMapping mappingForClass:[USErrorAndData class]];
    [errAndDataMapping addAttributeMappingsFromDictionary:@{
                                                     @"err": @"errorCode",
                                                     @"reason": @"errorReason"
                                                                }];
    
    RKObjectMapping *semesterMapping = [RKObjectMapping mappingForClass:[USSemester class]];
    [semesterMapping addAttributeMappingsFromDictionary:@{
                                                          @"block_name": @"semesterName"
                                                          }];
    
    RKObjectMapping *subjectMapping = [RKObjectMapping mappingForClass:[USSubject class]];
    [subjectMapping addAttributeMappingsFromDictionary:@{
                                                         @"id": @"subjectId",
                                                         @"no": @"no",
                                                         @"name": @"name",
                                                         @"en_name": @"en_name",
                                                         @"credit": @"credit",
                                                         @"type": @"type",
                                                         @"score": @"score",
                                                         @"test_time": @"testTime",
                                                         @"not_pass_reason": @"no_pass_reason"
                                                         }];
    
    [semesterMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"courses" toKeyPath:@"subjectArr" withMapping:subjectMapping]];
    
    RKObjectMapping *myInfoMapping = [RKObjectMapping mappingForClass:[USMyInfo class]];
    [myInfoMapping addAttributeMappingsFromDictionary:@{
                                                        @"stu_id": @"stu_id",
                                                        @"name": @"stu_name",
                                                        @"class": @"stu_class",
                                                        @"head": @"stu_header"
                                                        }];
    
    [errAndDataMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data.info" toKeyPath:@"semesterArr" withMapping:semesterMapping]];
    [errAndDataMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data.school_roll_info" toKeyPath:@"myInfo" withMapping:myInfoMapping]];

    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errAndDataMapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:@"/Score"
                                                                                           keyPath:@""
                                                                                       statusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 399)]];
    
    [self.objectManager addResponseDescriptorsFromArray:@[responseDescriptor]];
    
}

-(void)getPassingSubjectResule:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    NSDictionary *parameters= @{
                                @"username":@"2013025014",
                                @"password": @"1",
                                @"type": @"passing"
                                };
    [self.objectManager postObject:nil path:@"/Score" parameters:parameters success:success failure:failure];
}

-(void)getSubjectResultWithParameters:(NSDictionary *)parameters success:(ObjectRequestSuccess)success failure:(ObjectRequestFailure)failure {
    [self.objectManager postObject:nil path:@"/Score" parameters:parameters success:success failure:failure];
}

@end
