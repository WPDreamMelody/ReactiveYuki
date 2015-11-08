//
//  NLPassthrounghSubscriber.h
//  ReactiveYuki
//
//  Created by yuki on 15/11/8.
//  Copyright © 2015年 DianPing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RACSubscriber.h>
#import "RACCompoundDisposable.h"
@class RACSignal;

@interface NLPassthrounghSubscriber : NSObject<RACSubscriber>

- (instancetype)initWithSubscriber:(id<RACSubscriber>)subscriber signal:(RACSignal*)signal dispose:(RACCompoundDisposable *)disposable;

@end
