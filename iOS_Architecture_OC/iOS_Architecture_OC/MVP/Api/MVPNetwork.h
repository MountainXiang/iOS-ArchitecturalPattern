//
//  MVPNetwork.h
//  iOS_Architecture_OC
//
//  Created by MountainX on 2018/7/5.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MVPSuccessBlock)(NSDictionary *dict);
typedef void(^MVPFailureBlock)(NSError *error);

@interface MVPNetwork : NSObject

+ (void)fetchHeroInformationSuccess:(MVPSuccessBlock)success failure:(MVPFailureBlock)failure;

@end
