//
//  CustomedYTKRequest.h
//  iOS_Architecture_OC
//
//  Created by MountainX on 2018/7/4.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "YTKRequest.h"

// 获取服务器响应状态码 key
FOUNDATION_EXTERN NSString *const X_BaseRequest_StatusCodeKey;
// 服务器响应数据成功状态码 value
FOUNDATION_EXTERN NSString *const X_BaseRequest_DataValueKey;
// 获取服务器响应状态信息 key
FOUNDATION_EXTERN NSString *const X_BaseRequest_StatusMsgKey;
// 获取服务器响应数据 key
FOUNDATION_EXTERN NSString *const X_BaseRequest_DataKey;

@class CustomedYTKRequest;
@protocol CustomedYTKRequestReformDelegate <NSObject>

- (id)request:(CustomedYTKRequest *)request reformJSONResponse:(id)jsonResponse;

@end

@interface CustomedYTKRequest : YTKRequest

@property (nonatomic, weak) id<CustomedYTKRequestReformDelegate> reformDelegate;

/**
 自定义解析器解析响应参数
 
 @param jsonResponse json响应
 @return 解析后的json
 */
- (id)reformJSONResponse:(id)jsonResponse;

/**
 添加额外的参数
 
 @return 额外参数
 */
- (id)extraRequestArgument;

@end
