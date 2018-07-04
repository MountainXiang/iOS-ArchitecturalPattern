//
//  CustomedYTKRequest+Rac.m
//  iOS_Architecture_OC
//
//  Created by MountainX on 2018/7/4.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "CustomedYTKRequest+Rac.h"
#import "NSObject+RACDescription.h"

@implementation CustomedYTKRequest (Rac)

- (RACSignal *)rac_signal {
    [self stop];
    @weakify(self);
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [subscriber sendNext:[request responseJSONObject]];
            [subscriber sendCompleted];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [subscriber sendError:[request error]];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            @strongify(self);
            if (!self.isCancelled) {
                [self stop];
            }
        }];
    }] takeUntil:[self rac_willDeallocSignal]];
    
    //设置名称 便于调试
    if (DEBUG) {
        [signal setNameWithFormat:@"%@ -rac_fkRequest",  RACDescription(self)];
    }
    
    return signal;
}

@end
