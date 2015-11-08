//
//  NLPassthrounghSubscriber.m
//  ReactiveYuki
//
//  Created by yuki on 15/11/8.
//  Copyright © 2015年 DianPing. All rights reserved.
//

#import "NLPassthrounghSubscriber.h"

@interface NLPassthrounghSubscriber()

@property (nonatomic,strong,readonly) id<RACSubscriber> innerSubscriber;
@property (nonatomic,unsafe_unretained,readonly) RACSignal *signal;
@property (nonatomic, strong, readonly) RACCompoundDisposable *disposable;


@end

@implementation NLPassthrounghSubscriber

- (instancetype)initWithSubscriber:(id<RACSubscriber>)subscriber signal:(RACSignal*)signal dispose:(RACCompoundDisposable *)disposable{
    self = [super init];
    if(self == nil)return nil;
    
    _innerSubscriber = subscriber;
    _signal = signal;
    _disposable = disposable;
    
    [self.innerSubscriber didSubscribeWithDisposable:self.disposable];
    return self;
}

- (void)sendNext:(id)value{
    if(self.disposable.disposed)return;
    
    [self.innerSubscriber sendNext:value];
}

- (void)sendError:(NSError *)error{
    if(self.disposable.disposed)return;
    
    [self.innerSubscriber sendError:error];
}

- (void)sendCompleted{
    if(self.disposable.disposed)return;
    
    [self.innerSubscriber sendCompleted];
}

- (void)didSubscribeWithDisposable:(RACCompoundDisposable *)disposable{
    if(disposable != self.disposable){
        [self.disposable addDisposable:disposable];
    }
}





































@end
