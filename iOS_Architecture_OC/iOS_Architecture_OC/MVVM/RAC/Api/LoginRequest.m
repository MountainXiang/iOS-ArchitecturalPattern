//
//  LoginRequest.m
//  iOS_Architecture_OC
//
//  Created by MountainX on 2018/7/4.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "LoginRequest.h"

// 登录token key
NSString *XLoginAccessTokenKey = @"accessToken";

@implementation LoginRequest
{
    NSString *_userName;
    NSString *_password;
}

- (id)initWithUserName:(NSString *)userName password:(NSString *)password {
    self = [super init];
    if (self) {
        _userName = userName;
        _password = password;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeHTTP;
}

- (BOOL)statusCodeValidator {
    return YES;
}

- (NSString *)requestUrl {
    return @"";
}

- (id)requestArgument {
    return @{@"username" : _userName,
             @"password" : _password};
}

@end
