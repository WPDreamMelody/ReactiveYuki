//
//  NLDisposable.m
//  ReactiveYuki
//
//  Created by yuki on 15/11/8.
//  Copyright © 2015年 DianPing. All rights reserved.
//

#import "NLDisposable.h"
#import <libkern/OSAtomic.h>

@interface NLDisposable(){
    /*
     关键字volatile有什么含意?并给出三个不同的例子。一个定义为volatile的变量是说这变量可能会被意想不到地改变，这样，编译器就不会去假设这个变量的值了。精确地说就是，优化器在用到这个变量时必须每次都小心地重新读取这个变量的值，而不是使用保存在寄存器里的备份。下面是volatile变量的几个例子：
     
     · ;并行设备的硬件寄存器（如：状态寄存器）
     
     · ; 一个中断服务子程序中会访问到的非自动变量(Non-automatic variables)
     
     · ; 多线程应用中被几个任务共享的变量
     
     · ;一个参数既可以是const还可以是volatile吗？解释为什么。
     
     · ; 一个指针可以是volatile 吗？解释为什么。
     
     下面是答案：
     
     · ; 是的。一个例子是只读的状态寄存器。它是volatile因为它可能被意想不到地改变。它是const因为程序不应该试图去修改它。
     
     ·; 是的。尽管这并不很常见。一个例子是当一个中服务子程序修该一个指向一个buffer的指针时。
     */
    void *volatile _disposeBlock;
}

@end

@implementation NLDisposable

- (BOOL)isDisposed{
    return _disposeBlock == NULL;
}

- (instancetype)initWithBlock:(void (^)(void))block{
    NSCParameterAssert(block != nil);
    self = [super init];
    if(self == nil) return nil;
    
    _disposeBlock = (__bridge void *)(self);
    OSMemoryBarrier();
    
    return self;
}

+ (instancetype)disposableWithBlock:(void (^)(void))block{
    return [[self alloc] initWithBlock:block];
}

- (void)dealloc{
    if(_disposeBlock == NULL || _disposeBlock == (__bridge void*)self)
        return;
    
    CFRelease(_disposeBlock);
    _disposeBlock = NULL;
}


- (void)dispose{
    if(_disposeBlock == NULL || _disposeBlock == (__bridge void*)self)
        return;
    
    void (^disposeBlock)(void) = CFBridgingRelease((void *)_disposeBlock);
    _disposeBlock = NULL;
    disposeBlock();
}






















@end
