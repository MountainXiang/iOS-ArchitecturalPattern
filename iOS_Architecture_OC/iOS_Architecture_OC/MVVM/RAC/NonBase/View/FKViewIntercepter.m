//
//  FKViewIntercepter.m
//  FXXKBaseMVVM
//
//  Created by MountainX on 2018/7/4.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "FKViewIntercepter.h"
#import "FKViewProtocol.h"
#import "Aspects.h"

@implementation FKViewIntercepter

+ (void)load
{
    [FKViewIntercepter sharedInstance];
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static FKViewIntercepter *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FKViewIntercepter alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        /* 方法拦截 */
        
        // 代码方式唤起view
        [UIView aspect_hookSelector:@selector(initWithFrame:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo, CGRect frame){
            
            [self _init:aspectInfo.instance withFrame:frame];
        }  error:nil];
        
        // xib方式唤起view
        [UIView aspect_hookSelector:@selector(initWithCoder:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo, NSCoder *aDecoder){
            
            // 在此时 IBOut 中 view 都为空， 需要Hook awakeFromNib 方法
            [self _init:aspectInfo.instance withCoder:aDecoder];
        } error:nil];
        
        // xib方式唤起view
        [UIView aspect_hookSelector:@selector(awakeFromNib) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo){
            
            // 这时候可以初始化视图
            [self _awakFromNib:aspectInfo.instance];
        } error:nil];
    }
    return self;
}

#pragma mark - Hook Methods
- (void)_init:(UIView <FKViewProtocol>*)view withFrame:(CGRect)frame
{
    
    if ([view respondsToSelector:@selector(fk_initializeForView)]) {
        [view fk_initializeForView];
    }
    
    if ([view respondsToSelector:@selector(fk_createViewForView)]) {
        [view fk_createViewForView];
    }
}

- (void)_init:(UIView <FKViewProtocol>*)view withCoder:(NSCoder *)aDecoder
{
    if ([view respondsToSelector:@selector(fk_initializeForView)]) {
        [view fk_initializeForView];
    }
}

- (void)_awakFromNib:(UIView <FKViewProtocol>*)view
{
    if ([view respondsToSelector:@selector(fk_createViewForView)]) {
        [view fk_createViewForView];
    }
}


@end
