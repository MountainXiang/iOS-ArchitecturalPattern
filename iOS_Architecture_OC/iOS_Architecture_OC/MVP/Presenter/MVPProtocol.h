//
//  MVPProtocol.h
//  iOS_Architecture_OC
//
//  Created by MountainX on 2018/7/5.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MVPProtocol <NSObject>

@required
- (void)renderHeroName:(NSString *)heroName;
- (void)renderHeroPicture:(NSString *)heroPicture;
- (void)renderHeroSkill:(NSString *)heroSkill;

- (void)renderNetworkError:(NSError *)error;

@end
