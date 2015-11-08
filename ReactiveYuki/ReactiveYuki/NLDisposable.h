//
//  NLDisposable.h
//  ReactiveYuki
//
//  Created by yuki on 15/11/8.
//  Copyright © 2015年 DianPing. All rights reserved.
//  每个Disposable对象操作

#import <Foundation/Foundation.h>

@interface NLDisposable : NSObject

//是否已经拆除过
@property (atomic,assign,getter=isDisposed,readonly) BOOL disposed;

+ (instancetype)disposableWithBlock:(void (^)(void))block;

//执行拆除工作
- (void)dispose;

@end
