//
//  MVPPresenter.m
//  iOS_Architecture_OC
//
//  Created by MountainX on 2018/7/5.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "MVPPresenter.h"
#import "MVPNetwork.h"
#import "MVPModel.h"

@implementation MVPPresenter

#pragma mark - Public Method
- (void)renderUI {
    [MVPNetwork fetchHeroInformationSuccess:^(NSDictionary *dict) {
        MVPModel *hero = [[MVPModel alloc] init];
        [hero setValuesForKeysWithDictionary:dict];
        if (self.delegate && [self.delegate respondsToSelector:@selector(renderHeroName:)]) {
            [self.delegate renderHeroName:hero.name];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(renderHeroPicture:)]) {
            [self.delegate renderHeroPicture:hero.picture];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(renderHeroSkill:)]) {
            [self.delegate renderHeroSkill:hero.skill];
        }
    } failure:^(NSError *error) {
        if (self->_delegate && [self->_delegate respondsToSelector:@selector(renderNetworkError:)]) {
            [self->_delegate renderNetworkError:error];
        }
    }];
}

@end
