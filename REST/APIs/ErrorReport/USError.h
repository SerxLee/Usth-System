//
//  USError.h
//  Usth System
//
//  Created by Serx on 2017/5/19.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import <Foundation/Foundation.h>

//定义错误类型
typedef NS_ENUM(int, USErrorType)
{
    USErrorSystem, // 系统级别错误，比如系统挂了，服务器繁忙等
    USErrorServer, // 服务级别错误，参数为空，请求字段太长，，接口不存在，非法id（一般为请求不合法，导致动作无法完成）等
    USErrorAuth,   // 认证错误
    USErrorObject, // 服务器返回对象错误，为空，或者无法匹配到对象
    USErrorNetwork,// 网络异常
    USErrorCache,  // 服务器要求使用缓存
    USErrorUnknow, // 无法识别的错误
    USErrorException, //异常返回
    USErrorUserName,
    USErrorPassword,
    USErrorCount
};

@interface USError : NSError

- (instancetype)initWithErrorReason:(NSString*)errorReason;

- (instancetype)initWithResponseError:(NSError*)error;

- (NSString*)errorMessage;

@end
