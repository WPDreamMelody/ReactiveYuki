//
//  NVCricleView.m
//  ReactiveYuki
//
//  Created by Yuki on 15/10/23.
//  Copyright © 2015年 DianPing. All rights reserved.
//

#import "NVCricleView.h"
#import <CoreText/CTFont.h>


@implementation NVCricleView

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGRect frame = CGRectMake(10, 100, 200, 100);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor blackColor]set];
    CGContextFillRect(context, rect);
    
    CGContextAddEllipseInRect(context, frame);
    [[UIColor whiteColor] set];
    CGContextFillPath(context);

}

@end
