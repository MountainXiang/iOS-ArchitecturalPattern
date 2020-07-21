//
//  FKViewModelProtocol.h
//  FXXKBaseMVVM
//
//  Created by MountainX on 2018/7/4.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FKViewModelProtocol <NSObject>

@required

/**
 viewModel 初始化属性
 */
- (void)fk_initializeForViewModel;

@end
