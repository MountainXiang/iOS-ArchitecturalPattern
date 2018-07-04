//
//  LoginRequest.h
//  iOS_Architecture_OC
//
//  Created by MountainX on 2018/7/4.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "CustomedYTKRequest.h"

// 登录token key
FOUNDATION_EXTERN NSString *XLoginAccessTokenKey;

@interface LoginRequest : CustomedYTKRequest

- (id)initWithUserName:(NSString *)userName password:(NSString *)password;

@end
