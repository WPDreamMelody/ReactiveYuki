//
//  NLSubscriber.m
//  ReactiveYuki
//
//  Created by yuki on 15/11/7.
//  Copyright © 2015年 DianPing. All rights reserved.
//

#import "NLSubscriber.h"

@interface NLSubscriber()
@property (nonatomic,copy) void(^next)(id value);
@property (nonatomic,copy) void(^error)(id error);
@property (nonatomic,copy) void(^completed)(void);

@end

@implementation NLSubscriber

+ (id)initwithNext:(void(^)(id value))nextBlock withError:(void(^)(id value))errorBlock withCompleted:(void(^)(void))completedBlock{
    NLSubscriber *sb = [[self alloc]init];
    sb.next = nextBlock;
    sb.error = errorBlock;
    sb.completed = completedBlock;
    
    return sb;
}

- (void)sendNext:(id)value{
//    NSLog(@"=====%s value : %@", sel_getName(_cmd),value);
    self.next(value);
    
}

- (void)sendError:(NSError *)error{
//    NSLog(@"=====%s error : %@",sel_getName(_cmd), error);
    self.error(error);
}

- (void)sendCompleted{
//    NSLog(@"=====%s", sel_getName(_cmd));
    self.completed();
}

- (void)didSubscribeWithDisposable:(RACCompoundDisposable *)disposable{
    
}

@end
