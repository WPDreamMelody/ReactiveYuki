//
//  NLCompoundDisposable.h
//  ReactiveYuki
//
//  Created by yuki on 15/11/8.
//  Copyright © 2015年 DianPing. All rights reserved.
//  组合模式管理NLDisposable

#import "NLDisposable.h"

@interface NLCompoundDisposable : NLDisposable

+ (instancetype)compoundDisposable;

+ (instancetype)compoundDisposableWithDisposable:(NSArray*)disposable;

/**
 *  @brief  将 disposable 加到本 compound disposable 中。如果本 compound disposable
 *       已经 dispose 的话，那么参数 disposable 会被立即 dispose。
 *
 *          本方法是线程安全的。
 *
 *  @param disposable 要被加入的 disposable。如果它为 nil 的话，那么什么也不会发生。
 */
- (void)addDisposable:(NLDisposable*)disposable;

- (void)removeDisposable:(NLDisposable*)disposable;


@end
