//
//  Timing.h
//  FSInteractiveMap
//
//  Created by 曹帅 on 16/1/4.
//  Copyright © 2016年 Arthur GUIBERT. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Timing : NSObject
/**
 *  初始化方法
 *
 *  @param view   显示时间放在那个view
 *
 *  @return self
 */
- (id)initWithView:(UIView *)view withFrame:(CGRect)rect;
/**
 *  起止时间 格式如：20160104183240
 */
@property(nonatomic,copy)NSString *fireTimes;

@end
