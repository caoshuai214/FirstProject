//
//  Common.h
//  LoginLayout
//
//  Created by 曹帅 on 15/12/15.
//  Copyright © 2015年 北京浩鹏盛世科技有限公司. All rights reserved.
//

#ifndef Common_h
#define Common_h
#import "AppDelegate.h"
#import "UIColor+NewColor.h"
CG_INLINE CGRect

CGRectMake1(CGFloat x, CGFloat y, CGFloat width, CGFloat height){
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    CGRect rect;
    rect.origin.x = x * myDelegate.autoSizeScaleX; rect.origin.y = y * myDelegate.autoSizeScaleY;
    rect.size.width = width * myDelegate.autoSizeScaleX; rect.size.height = height * myDelegate.autoSizeScaleY;
    return rect;
}


#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)

#endif /* Common_h */
