//
//  NLCompoundDisposable.m
//  ReactiveYuki
//
//  Created by yuki on 15/11/8.
//  Copyright © 2015年 DianPing. All rights reserved.
//

#import "NLCompoundDisposable.h"
#import <libkern/OSAtomic.h>

@interface NLCompoundDisposable(){
    /**
     *  @brief  同步锁
     */
    OSSpinLock _spinLock;
    
    /**
     *  @brief  本 compound disposable 所包含的 disposables。
     *
     *          在操作这个数组时，应该使用 _spinLock 进行同步。如果
     *       `_disposed` 为 YES，则这个数组可能为 nil。
     */
    NSMutableArray *_disposables;
    
    /**
     *  @brief  本 compound disposable 是否已经 dispose 。
     *
     *          在操作这个变量时，应该使用 _spinLock 进行同步。
     */
    BOOL _disposed;
}

@end

@implementation NLCompoundDisposable

- (BOOL)isDisposed{
    OSSpinLockLock(&_spinLock);
    BOOL disposed = _disposed;
    OSSpinLockUnlock(&_spinLock);
    
    return disposed;
}

+ (instancetype)compoundDisposable{
    return [[self alloc]initWithDisposables:nil];
}

+ (instancetype)compoundDisposableWithDisposable:(NSArray *)disposable{
     return [[self alloc]initWithDisposables:disposable];
}

- (id)initWithDisposables:(NSArray*)otherDisposables{
    self = [self init];
    if(self == nil) return nil;
    
    if([otherDisposables count]){
        _disposables = [NSMutableArray arrayWithArray:otherDisposables];
    }
    
    return self;
}

- (void)dealloc{
    _disposables = nil;
}

- (id)initWithBlock:(void (^)(void))block {
    NLDisposable *disposable = [NLDisposable disposableWithBlock:block];
    return [self initWithDisposables:@[ disposable ]];
}


#pragma import method
- (void)addDisposable:(NLDisposable *)disposable{
    NSCParameterAssert(disposable !=self);
    if(disposable == nil || disposable.disposed)
        return;
    
    BOOL shouldDispose = NO;
    
    OSSpinLockLock(&_spinLock);
    {
        if(_disposed){
            shouldDispose = YES;
        }else{
            if(_disposables == nil){
                _disposables = [NSMutableArray array];
            }
            [_disposables addObject:disposable];
        }
    }
    OSSpinLockUnlock(&_spinLock);
    
    if(shouldDispose){
        [disposable dispose];
    }
}

- (void)removeDisposable:(NLDisposable *)disposable{
    if(disposable == nil || disposable.disposed)
        return;
    
    OSSpinLockLock(&_spinLock);
    {
        if(!_disposed&&_disposables != nil){
            [_disposables removeObject:disposable];
        }
    }
    OSSpinLockUnlock(&_spinLock);
}

- (void)dispose{
    NSArray *remaintingDisposeables = nil;
    OSSpinLockLock(&_spinLock);
    {
        _disposed = YES;
        remaintingDisposeables = _disposables;
        _disposables = nil;
    }
    OSSpinLockUnlock(&_spinLock);
    
    if(remaintingDisposeables == nil)return;
    
    [remaintingDisposeables makeObjectsPerformSelector:@selector(dispose)];
    
}



@end
