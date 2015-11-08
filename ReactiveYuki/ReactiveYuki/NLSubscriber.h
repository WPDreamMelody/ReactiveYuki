//
//  NLSubscriber.h
//  ReactiveYuki
//
//  Created by yuki on 15/11/7.
//  Copyright © 2015年 DianPing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RACSubscriber.h>

@interface NLSubscriber : NSObject<RACSubscriber>
+ (id)initwithNext:(void(^)(id value))nextBlock withError:(void(^)(id value))errorBlock withCompleted:(void(^)(void))completedBlock;
@end
