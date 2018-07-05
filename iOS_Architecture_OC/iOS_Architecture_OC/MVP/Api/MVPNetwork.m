//
//  MVPNetwork.m
//  iOS_Architecture_OC
//
//  Created by MountainX on 2018/7/5.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "MVPNetwork.h"

@implementation MVPNetwork

+ (void)fetchHeroInformationSuccess:(MVPSuccessBlock)success failure:(MVPFailureBlock)failure {
    [SVProgressHUD fk_displayOverFlowActivityView:1.0];
    //模拟网络请求
    if (random() % 4) {
        //请求成功
        NSDictionary *hero = @{@"name":@"盲僧·李青",
                               @"picture":@"LeeSin",
                               @"skill":@"李青是艾欧尼亚古老武术的大师，讲原则、重信义的他能将神龙之灵的精粹运用自如，助他面对任何挑战。虽然他多年前便已双目失明，但这位武僧依然献出自己的全部力量，用生命捍卫家园，抵御任何胆敢打破这里神圣均衡的人。所有因他安静冥想的举动而掉以轻心的敌人都将品尝他燃烧的拳头和炽烈的回旋踢。"
                               };
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (success) {
                success(hero);
            }
        });
    } else {
        //请求失败
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (failure) {
                NSError *error = [NSError errorWithDomain:@"com.mountain.xiang" code:404 userInfo:nil];
                failure(error);
            }
        });
    }
}

@end
