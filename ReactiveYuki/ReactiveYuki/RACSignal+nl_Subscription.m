//
//  RACSignal+nl_Subscription.m
//  ReactiveYuki
//
//  Created by yuki on 15/11/7.
//  Copyright © 2015年 DianPing. All rights reserved.
//

#import "RACSignal+nl_Subscription.h"
#import "NLSubscriber.h"

@implementation RACSignal (nl_Subscription)


- (void)nl_subscribeNext:(void (^)(id x))nextBlock{
    [self nl_subscribeNext:nextBlock error:nil completed:nil];
}
- (void)nl_subscribeNext:(void (^)(id x))nextBlock completed:(void (^)(void))completedBlock{
    [self nl_subscribeNext:nextBlock error:nil completed:completedBlock];
}

- (void)nl_subscribeNext:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock completed:(void (^)(void))completedBlock{
    NLSubscriber *subscriber = [NLSubscriber initwithNext:nextBlock withError:errorBlock withCompleted:completedBlock];
    [self subscribe:subscriber];
    
}
- (void)nl_subscribeError:(void (^)(NSError *error))errorBlock{
    [self nl_subscribeNext:nil error:errorBlock completed:nil];
}
- (void)nl_subscribeCompleted:(void (^)(void))completedBlock{
    [self nl_subscribeNext:nil error:nil completed:completedBlock];
}
- (void)nl_subscribeNext:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock{
    [self nl_subscribeNext:nextBlock error:errorBlock completed:nil];
}
- (void)nl_subscribeError:(void (^)(NSError *error))errorBlock completed:(void (^)(void))completedBlock{
    [self nl_subscribeNext:nil error:errorBlock completed:completedBlock];
}

@end
