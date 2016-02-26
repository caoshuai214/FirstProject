//
//  LineView.m
//  LoginLayout
//
//  Created by 曹帅 on 16/1/7.
//  Copyright © 2016年 北京浩鹏盛世科技有限公司. All rights reserved.
//

#import "LineView.h"

@implementation LineView

- (void)drawRect:(CGRect)rect {
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineCap(context, kCGLineCapRound);
//    CGContextSetLineWidth(context, 3);  //线宽
//    CGContextSetAllowsAntialiasing(context, true);
//    CGContextSetRGBStrokeColor(context, 70.0 / 255.0, 241.0 / 255.0, 241.0 / 255.0, 1.0);  //线的颜色
//    CGContextBeginPath(context);
//    
//    CGContextMoveToPoint(context, 0, 64);  //起点坐标
//    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height - 64);   //终点坐标
//    
//    CGContextStrokePath(context);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // /*NO.1画一条线
    CGContextSetRGBStrokeColor(context, 1,1,1, 1);//线条颜色
    CGContextMoveToPoint(context, 20, 120);
//    [UIView animateWithDuration:5 animations:^{
        CGContextAddLineToPoint(context, 200,20);
        CGContextStrokePath(context);
//    } completion:^(BOOL finished) {
//    }];
}
@end
