//
//  RACSignal+nl_Subscription.h
//  ReactiveYuki
//
//  Created by yuki on 15/11/7.
//  Copyright © 2015年 DianPing. All rights reserved.
//  组合subscription

#import "RACSignal.h"

@interface RACSignal (nl_Subscription)


- (void)nl_subscribeNext:(void (^)(id x))nextBlock;
- (void)nl_subscribeNext:(void (^)(id x))nextBlock completed:(void (^)(void))completedBlock;
- (void)nl_subscribeNext:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock completed:(void (^)(void))completedBlock;
- (void)nl_subscribeError:(void (^)(NSError *error))errorBlock;
- (void)nl_subscribeCompleted:(void (^)(void))completedBlock;
- (void)nl_subscribeNext:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock;
- (void)nl_subscribeError:(void (^)(NSError *error))errorBlock completed:(void (^)(void))completedBlock;

@end
