//
//  CustomedYTKRequest.m
//  iOS_Architecture_OC
//
//  Created by MountainX on 2018/7/4.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "CustomedYTKRequest.h"

// 获取服务器响应状态码 key
NSString *const X_BaseRequest_StatusCodeKey = @"statusCode";
// 服务器响应数据成功状态码 value
NSString *const X_BaseRequest_DataValueKey = @"0000";
// 获取服务器响应状态信息 key
NSString *const X_BaseRequest_StatusMsgKey = @"statusMsg";
// 获取服务器响应数据 key
NSString *const X_BaseRequest_DataKey = @"data";;

@implementation CustomedYTKRequest

#pragma mark - Override
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType)requestSerializerType
{
    return YTKRequestSerializerTypeHTTP;
}

- (YTKResponseSerializerType)responseSerializerType
{
    return YTKResponseSerializerTypeJSON;
}

- (id)requestArgument
{
    return @{};
}

- (NSTimeInterval)requestTimeoutInterval
{
    return 10.f;
}

- (NSDictionary *)reformParams:(NSDictionary *)params
{
    return params;
}

- (NSError *)error {
    NSError *error = [super error];
    NSDictionary *responseDict = [super responseJSONObject];
    
    // 获取服务器反馈 状态码 和 状态信息
    NSString *stCode = DecodeStringFromDic(responseDict, X_BaseRequest_StatusCodeKey);
    NSString *stMsssage = DecodeStringFromDic(responseDict, X_BaseRequest_StatusMsgKey);
    
    // 获取原有 domain errorCode userInfo
    NSErrorDomain domain = error.domain;
    NSInteger errorCode = error.code;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:error.userInfo];
    
    // 响应服务器状态码
    if (stCode == -999) {
        // 状态码不正确
        [userInfo setValue:stMsssage forKey:NSLocalizedDescriptionKey];
        error = [NSError errorWithDomain:domain code:stCode userInfo:[userInfo copy]];
    }
    
    return error;
}

// JSON解析
- (id)responseJSONObject
{
    NSDictionary *dict = [super responseJSONObject];
    
    id data = [dict objectForKey:@"data"];
    
    // 有代理则走代理方法
    if (self.reformDelegate && [self.reformDelegate respondsToSelector:@selector(request:reformJSONResponse:)]) {
        
        return [_reformDelegate request:self reformJSONResponse:data];
    }
    // 没有代理走 子类方法
    return [self reformJSONResponse:data];
}

// 验证状态码
- (BOOL)statusCodeValidator
{
    NSDictionary *responseDict = [super responseJSONObject];
    // 验证服务端返回验证码
    NSString *stCode = DecodeStringFromDic(responseDict, X_BaseRequest_StatusCodeKey);
    if ([stCode isEqualToString:X_BaseRequest_DataValueKey]) {
        // 请求成功
        return YES;
    }else{
        // 请求失败
        return NO;
    }
}

#pragma mark - Subclass Ovrride
- (id)reformJSONResponse:(id)jsonResponse;
{
    return jsonResponse;
}

/**
 添加额外的参数
 
 @return 额外参数
 */
- (id)extraRequestArgument
{
    return nil;
}

@end
