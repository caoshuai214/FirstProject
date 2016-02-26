//
//  ViewController.m
//  LoginLayout
//
//  Created by 曹帅 on 15/12/15.
//  Copyright © 2015年 北京浩鹏盛世科技有限公司. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "ZhiWenViewController.h"
#import "MBProgressHUD.h"
#import "ZCTradeView.h"
#import "NSString+Extension.h"
#import "ImageViewController.h"
#import "SnowViewController.h"
#import "Timing.h"
#define SNOW_IMAGENAME		 @"Snow"
#define Main_Screen_Width ([UIScreen mainScreen].bounds.size.width)
#define Main_Screen_Height ([UIScreen mainScreen].bounds.size.height)
#define IMAGE_X				arc4random()%(int)Main_Screen_Width
#define IMAGE_ALPHA			((float)(arc4random()%10))/10
#define IMAGE_WIDTH			arc4random()%20 + 10
#define PLUS_HEIGHT			Main_Screen_Height/25

@interface ViewController ()<MBProgressHUDDelegate,ZCTradeViewDelegate>
{
    CGFloat timer;
    NSTimer *timers;
    ZCTradeView *zctV;

}
@property(nonatomic,retain)UIButton *loginButton;
@property (strong,nonatomic)UIButton * tmpBtn;
//@property(nonatomic,retain)UILabel *label;
@property(nonatomic,assign)NSInteger index;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    timer = 1;
    self.title = @"天冷了，注意保暖";
    [self change];
    [self CreatTiming];
    self.view.backgroundColor = [UIColor grayColor];
    
    
    NSLog(@"%d",MIN(10, 2));
}
/**
 *  创建倒计时
 */
- (void)CreatTiming{
    Timing *timing = [[Timing alloc] initWithView:self.view withFrame:CGRectMake1(0, 200, kScreenWidth, 30)];
    timing.fireTimes = @"20160108000000";
}


-(void)change{
    NSArray *array = @[@"下雪了",@"旋转",@"指纹",@"下拉"];
    for (NSInteger i = 0; i < array.count; i++) {
        _loginButton = [[UIButton alloc] initWithFrame:CGRectMake1((Main_Screen_Width/array.count - 60)/2 * (i+1) + 60 * i, 80, 60, 60)];
        [_loginButton setTitle:array[i] forState:UIControlStateNormal];
        _loginButton.tag = 100 + i;
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        _loginButton.backgroundColor = [UIColor orangeColor];
        [_loginButton setTitleColor:[UIColor magentaColor] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(Push:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_loginButton];
//        if (i == 0) {
//            _loginButton.backgroundColor = [UIColor cyanColor];
            self.index = 0;
//        }
    }
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake1(0, _loginButton.frame.origin.y + _loginButton.frame.size.height, Main_Screen_Width, Main_Screen_Height - _loginButton.frame.size.height - _loginButton.frame.origin.y)];
//    [self.view addSubview:web];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Untitled-1" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [web loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
    
    
}

- (void)setIndex:(NSInteger)index{
    if (_index != index) {
        UIButton *lastButton = (UIButton *)[self.view viewWithTag:_index + 100];
        lastButton.selected = NO;
        lastButton.backgroundColor = [UIColor orangeColor];
        UIButton *currentButton = (UIButton *)[self.view viewWithTag:index+ 100];
        currentButton.backgroundColor = [UIColor cyanColor];
        currentButton.selected = YES;
        _index = index;
    }
}

- (void)Push:(UIButton *)button{
    if (button.tag == 100) {
        SnowViewController *login = [[SnowViewController alloc] init];
        button.backgroundColor = [UIColor cyanColor];
        [self.navigationController pushViewController:login animated:YES];
    }
    if (button.tag == 101) {
        ImageViewController *login = [[ImageViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
    if (button.tag == 102) {
        [self validatefin];
    }
    if (button.tag == 103) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
    self.index = button.tag - 100;
    button.selected = YES;
}

- (void)validatefin{
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        NSLog(@"不支持");
        [self myTask];
    }
    
    LAContext *ctx = [[LAContext alloc] init];
    NSError *error;
    ctx.localizedFallbackTitle = @"shurumima";
    // 判断设备是否支持指纹识别
    if ([ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        NSLog(@"支持");
        // 输入指纹，异步
        // 提示：指纹识别只是判断当前用户是否是手机的主人！程序原本的逻辑不会受到任何的干扰！
        
        [ctx evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"指纹登录" reply:^(BOOL success, NSError *error) {
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            HUD.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:HUD];
            HUD.delegate = self;
            NSLog(@"%d %@", success, error);
            
            if (success) {
                // 登录成功
                // TODO
                [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
                //                [self myTask];
                
            } else {
                if (error.code == kLAErrorUserFallback) {
                    NSLog(@"---------User tapped Enter Password");
                    zctV = [[ZCTradeView alloc] init];
                    zctV.delegate = self;
                    [zctV show];
                } else if (error.code == kLAErrorUserCancel) {
                    NSLog(@"--------User tapped Cancel");
                } else {
                    NSLog(@"------Authenticated failed.");
                    if ([self getCache:5 andID:5] == nil) {
                        UIAlertController * alerts = [UIAlertController alertControllerWithTitle:@"还没有设置登陆密码" message:@"请重新设置登录密码" preferredStyle:UIAlertControllerStyleAlert];
                        [alerts addAction: [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                            zctV = [[ZCTradeView alloc] init];
                            zctV.delegate = self;
                            [zctV show];
                        }]];
                        [self presentViewController:alerts animated:YES completion:nil];
                    }else {
                        zctV = [[ZCTradeView alloc] init];
                        zctV.delegate = self;
                        [zctV show];
                    }
                }
            }
        }];
        
        NSLog(@"come here");
    } else {
        NSLog(@"不支持");
        [self myTask];
    }
}
//设置登陆密码
- (void)saveCache:(int)type andID:(int)_id andString:(NSString *)str;
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * key = [NSString stringWithFormat:@"detail-%d-%d",type, _id];
    [setting setObject:str forKey:key];
    [setting synchronize];
}
//获取登陆密码
- (NSString *)getCache:(int)type andID:(int)_id
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"detail-%d-%d",type, _id];
    NSString *value = [settings objectForKey:key];
    return value;
}

-(NSString *)finish:(NSString *)pwd{
    if ([self getCache:5 andID:5] == nil) {
        [self saveCache:5 andID:5 andString:pwd];
        UIAlertController * alerts = [UIAlertController alertControllerWithTitle:@"设置成功" message:@"点击确定登陆" preferredStyle:UIAlertControllerStyleAlert];
        [alerts addAction: [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self myTask];
        }]];
        [self presentViewController:alerts animated:YES completion:nil];
    }else if ([[self getCache:5 andID:5] isEqualToString:pwd]){
        [self myTask];
    }else{
        UIAlertController * alerts = [UIAlertController alertControllerWithTitle:@"密码错误" message:@"请重新输入" preferredStyle:UIAlertControllerStyleAlert];
        [alerts addAction: [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            zctV = [[ZCTradeView alloc] init];
            zctV.delegate = self;
            [zctV show];
        }]];
        [alerts addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        }]];
        [self presentViewController:alerts animated:YES completion:nil];
    }
    return pwd;
}

- (void)myTask{
    ZhiWenViewController *login = [[ZhiWenViewController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
}
@end
