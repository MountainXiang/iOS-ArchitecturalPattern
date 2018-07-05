//
//  MVPPresenter.h
//  iOS_Architecture_OC
//
//  Created by MountainX on 2018/7/5.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVPProtocol.h"

@interface MVPPresenter : NSObject

@property (nonatomic, weak) id<MVPProtocol> delegate;

- (void)renderUI;

@end
