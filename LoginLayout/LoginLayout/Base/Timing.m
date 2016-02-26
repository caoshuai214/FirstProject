//
//  Timing.m
//  FSInteractiveMap
//
//  Created by 曹帅 on 16/1/4.
//  Copyright © 2016年 Arthur GUIBERT. All rights reserved.
//

#import "Timing.h"
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)

@interface Timing()

@property(nonatomic,retain)UILabel *timeLabel;

@end


@implementation Timing
- (id)initWithView:(UIView *)view withFrame:(CGRect)rect{
    self = [super init];
    if(self) {
        [self CreatwithView:view withFrame:rect];
    }
    
    return self;
}

- (void)CreatwithView:(UIView *)view withFrame:(CGRect)rect{
    self.timeLabel = [[UILabel alloc] initWithFrame:rect];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.textColor = [UIColor colorWithRed:0.196 green:0.931 blue:0.300 alpha:1.000];
    [view addSubview:self.timeLabel];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(testTimer) userInfo:nil repeats:YES];
}

- (void)testTimer{
    //计算上报时间差
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];
    //设置一个字符串的时间
    NSMutableString *datestring = [NSMutableString stringWithFormat:@"%@",_fireTimes];
    //注意 如果20141202052740必须是数字，如果是UNIX时间，不需要下面的插入字符串。
    [datestring insertString:@"-" atIndex:4];
    [datestring insertString:@"-" atIndex:7];
    [datestring insertString:@" " atIndex:10];
    [datestring insertString:@":" atIndex:13];
    [datestring insertString:@":" atIndex:16];
    NSDateFormatter * dm = [[NSDateFormatter alloc]init];
    //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
    [dm setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate * newdate = [dm dateFromString:datestring];
    long dd = (long)[datenow timeIntervalSince1970] - [newdate timeIntervalSince1970];
    NSString *timeString=@"";
    NSInteger bb = ABS(dd);
    if (bb/3600 <= 1)
    {
        if (dd>0) {
            if (ABS(dd) % 60 != 0) {
                NSInteger h = ABS(dd) % 60;
                timeString = [NSString stringWithFormat:@"%ld", ABS(dd)/60];
                timeString=[NSString stringWithFormat:@"%@分钟%ld秒前", timeString,h];
            }else{
                timeString = [NSString stringWithFormat:@"%ld", ABS(dd)/60];
                timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
            }
        }else{
            if (ABS(dd) % 60 != 0) {
                NSInteger h = ABS(dd) % 60;
                timeString = [NSString stringWithFormat:@"%ld", ABS(dd)/60];
                timeString=[NSString stringWithFormat:@"%@分钟%ld秒后", timeString,h];
            }else{
                timeString = [NSString stringWithFormat:@"%ld", ABS(dd)/60];
                timeString=[NSString stringWithFormat:@"%@分钟后", timeString];
            }
        }
    }
    if (bb/3600>=1&&bb/86400<=1)
    {
        if (dd>0) {
            if (ABS(dd) % 3600 != 0) {
                NSInteger h = ABS(dd) % 3600;
                timeString = [NSString stringWithFormat:@"%ld", ABS(dd)/3600];
                if (h % 60 != 0) {
                    NSInteger m = ABS(h) % 60;
                    timeString=[NSString stringWithFormat:@"%@小时%ld分钟%ld秒前", timeString,ABS(h) / 60,m];
                }else{
                    NSInteger m = ABS(h) % 60;
                    timeString=[NSString stringWithFormat:@"%@小时%ld分钟%ld秒前", timeString,ABS(h) / 60,m];
                }
            }
        }else{
            if (ABS(dd) % 3600 != 0) {
                NSInteger h = ABS(dd) % 3600;
                timeString = [NSString stringWithFormat:@"%ld", ABS(dd)/3600];
                if (h % 60 != 0) {
                    NSInteger m = ABS(h) % 60;
                    timeString=[NSString stringWithFormat:@"%@小时%ld分钟%ld秒后", timeString,ABS(h) / 60,m];
                }else{
                    NSInteger m = ABS(h) % 60;
                    timeString=[NSString stringWithFormat:@"%@小时%ld分钟%ld秒后", timeString,ABS(h) / 60,m];
                }
            }
        }
    }
    if (bb / 86400 >= 1)
    {
        if (dd > 0) {
            if (ABS(dd) % 86400) {
                NSInteger h = ABS(dd) % 86400;
                timeString = [NSString stringWithFormat:@"%ld", ABS(dd)/86400];
                if (h % 3600 != 0) {
                    NSInteger m = ABS(h) % 3600;
                    if (m % 60 != 0) {
                        NSInteger n = ABS(m) % 60;
                        timeString=[NSString stringWithFormat:@"%@天%ld小时%ld分钟%ld秒前", timeString,ABS(h) / 3600,m/60,n];
                    }else{
                        NSInteger n = ABS(m) % 60;
                        timeString=[NSString stringWithFormat:@"%@天%ld小时%ld分钟%ld秒前", timeString,h / 3600,m / 60,n];
                    }
                }else{
                    NSInteger m = ABS(h) % 3600;
                    if (m % 60 != 0) {
                        NSInteger n = ABS(m) % 60;
                        timeString=[NSString stringWithFormat:@"%@天%ld小时%ld分钟%ld秒前", timeString,ABS(h) / 3600,m/60,n];
                    }else{
                        NSInteger n = ABS(m) % 60;
                        timeString=[NSString stringWithFormat:@"%@天%ld小时%ld分钟%ld秒前", timeString,h / 3600,m / 60,n];
                    }
                }
            }
        }else{
            if (ABS(dd) % 86400) {
                NSInteger h = ABS(dd) % 86400;
                timeString = [NSString stringWithFormat:@"%ld", ABS(dd)/86400];
                if (h % 3600 != 0) {
                    NSInteger m = ABS(h) % 3600;
                    if (m % 60 != 0) {
                        NSInteger n = ABS(m) % 60;
                        timeString=[NSString stringWithFormat:@"%@天%ld小时%ld分钟%ld秒后", timeString,h / 3600,m / 60,n];
                    }else{
                        NSInteger n = ABS(m) % 60;
                        timeString=[NSString stringWithFormat:@"%@天%ld小时%ld分钟%ld秒后", timeString,h / 3600,m / 60,n];
                    }
                }else{
                    NSInteger m = ABS(h) % 3600;
                    if (m % 60 != 0) {
                        NSInteger n = ABS(m) % 60;
                        timeString=[NSString stringWithFormat:@"%@天%ld小时%ld分钟%ld秒后", timeString,h / 3600,m / 60,n];
                    }else{
                        NSInteger n = ABS(m) % 60;
                        timeString=[NSString stringWithFormat:@"%@天%ld小时%ld分钟%ld秒后", timeString,h / 3600,m / 60,n];
                    }
                }
            }
        }
    }
    self.timeLabel.text = timeString;
}





@end
