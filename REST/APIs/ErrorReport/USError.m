//
//  USError.m
//  Usth System
//
//  Created by Serx on 2017/5/19.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import "USError.h"

NSString* const USErrorDomain = @"APIError";

@implementation USError

-(instancetype)initWithErrorReason:(NSString *)errorReason {
    if ([errorReason rangeOfString:@"没有登陆或者登录过期"].location != NSNotFound) {
        return [USError errorAuthWithMessage:@"没有登陆或者登录过期"];
    }
    if ([errorReason rangeOfString:@"你输入的证件号不存在"].location != NSNotFound) {
        return [USError errorUserNameWithMessage:@"你输入的证件号不存在，请您重新输入！"];
    }
    if ([errorReason rangeOfString:@"您的密码不正确"].location != NSNotFound) {
        return [USError errorUserNameWithMessage:@"您的密码不正确，请您重新输入！"];
    }
    
    return [USError errorUnknow];
}

-(instancetype)initWithResponseError:(NSError *)error {
    // 网络错误
    if ([[error.userInfo objectForKey:NSLocalizedDescriptionKey] rangeOfString:@"The Internet connection appears to be offline."].location != NSNotFound ) {
        return [USError errorNetwork];
    }
    return [USError errorUnknow];
}

+(instancetype)errorAuthWithMessage:(NSString*)message {
    return [USError errorWithDomain:USErrorDomain
                               code:USErrorAuth
                           userInfo:@{NSLocalizedDescriptionKey:message}];

}

+(instancetype)errorUserNameWithMessage:(NSString*)message {
    return [USError errorWithDomain:USErrorDomain
                               code:USErrorUserName
                           userInfo:@{NSLocalizedDescriptionKey:message}];
    
}

+(instancetype)errorPasswordWithMessage:(NSString*)message {
    return [USError errorWithDomain:USErrorDomain
                               code:USErrorPassword
                           userInfo:@{NSLocalizedDescriptionKey:message}];
    
}

+(instancetype)errorUnknow {
    return [USError errorWithDomain:USErrorDomain
                               code:USErrorUnknow
                           userInfo:@{NSLocalizedDescriptionKey:@"未知错误"}];
}

+(instancetype)errorNetwork{
    return [USError errorWithDomain:USErrorDomain
                               code:USErrorNetwork
                           userInfo:@{NSLocalizedDescriptionKey:@"网络未连接"}];
}

@end
