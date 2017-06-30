//
//  USOperationFactory.m
//  Usth System
//
//  Created by Serx on 2017/5/18.
//  Copyright © 2017年 Serx. All rights reserved.
//

#import "USOperationFactory.h"

@interface USOperationFactory() {
    NSURL *_APIServerURI;
    NSString *_acceptMIMEType;
    NSString *_accessToke;
}

@property (nonatomic) RKObjectManager *objectManager;


@end

@implementation USOperationFactory

- (instancetype)initWithAccessToken:(NSString *)theAccessToken acceptMIMEType:(NSString *)MIMEType APIServerURI:(NSURL *)URI{
    self = [super init];
    if (self) {
        _APIServerURI = URI;
        _acceptMIMEType = MIMEType;
        _accessToke = theAccessToken;
        
    }
    return self;
}

-(RKObjectManager *)objectManager {
    if (_objectManager != nil) {
        return _objectManager;
    }
    
    //let AFNetworking manage the activity indicator
    [AFRKNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // Initialize HTTPClient
    AFRKHTTPClient* client = [[AFRKHTTPClient alloc] initWithBaseURL:_APIServerURI];
    //SSL 加密
    client.allowsInvalidSSLCertificate = NO;
//    client.defaultSSLPinningMode=AFRKSSLPinningModePublicKey;
    
    // HACK: Set User-Agent to Mac OS X so that Twitter will let us access the Timeline
    [client setDefaultHeader:@"User-Agent" value:[NSString stringWithFormat:@"%@/%@ (Mac OS X %@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey], [[NSProcessInfo processInfo] operatingSystemVersionString]]];
    
    //we want to work with JSON-Data
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:_acceptMIMEType];
//    [client setDefaultHeader:@"Authorization" value:_accessToke];
    //指定post的数据格式，默认是表单提交
//    client.parameterEncoding = AFRKJSONParameterEncoding;
    
    // Initialize RestKit
    return [[RKObjectManager alloc] initWithHTTPClient:client];
}


-(USSubjectResultOperation *)subjectResultOperation {
    if (_subjectResultOperation != nil) {
        return _subjectResultOperation;
    }
    _subjectResultOperation = [[USSubjectResultOperation alloc] initWithObjectManager:self.objectManager];
    return _subjectResultOperation;
}

-(USHeaderTokenOperation *)headerTokenOperation {
    if (_headerTokenOperation != nil) {
        return _headerTokenOperation;
    }
    _headerTokenOperation = [[USHeaderTokenOperation alloc] initWithObjectManager:self.objectManager];
    return _headerTokenOperation;
}

-(USReplyCommentOperation *)replyCommentOperation {
    if (_replyCommentOperation != nil ) {
        return _replyCommentOperation;
    }
    _replyCommentOperation = [[USReplyCommentOperation alloc] initWithObjectManager:self.objectManager];
    return _replyCommentOperation;
}

-(USDiggCommentOperation *)diggCommentOperation {
    if (_diggCommentOperation != nil) {
        return _diggCommentOperation;
    }
    _diggCommentOperation = [[USDiggCommentOperation alloc] initWithObjectManager:self.objectManager];
    return _diggCommentOperation;
}

-(USPublishNewCommentOperation *)publishNewCommentOperation {
    if (_publishNewCommentOperation != nil) {
        return _publishNewCommentOperation;
    }
    _publishNewCommentOperation = [[USPublishNewCommentOperation alloc] initWithObjectManager:self.objectManager];
    return _publishNewCommentOperation;
}

-(USGetCommentsOperation *)getCommentsOperation {
    if (_getCommentsOperation != nil) {
        return _getCommentsOperation;
    }
    _getCommentsOperation = [[USGetCommentsOperation alloc] initWithObjectManager:self.objectManager];
    return _getCommentsOperation;
}

-(USGetHistoryCommentOperation *)getHistoryCommentOperation {
    if (_getHistoryCommentOperation != nil) {
        return _getHistoryCommentOperation;
    }
    _getHistoryCommentOperation = [[USGetHistoryCommentOperation alloc] initWithObjectManager:self.objectManager];
    return _getHistoryCommentOperation;
}

@end
