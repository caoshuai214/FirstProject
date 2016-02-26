//
//  AppDelegate.m
//  LoginLayout
//
//  Created by 曹帅 on 15/12/15.
//  Copyright © 2015年 北京浩鹏盛世科技有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "BBLaunchAdMonitor.h"
#import <LocalAuthentication/LocalAuthentication.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    if([UIScreen mainScreen].bounds.size.height > 480){
        myDelegate.autoSizeScaleX = [UIScreen mainScreen].bounds.size.width /320;
        myDelegate.autoSizeScaleY = [UIScreen mainScreen].bounds.size.height/568;
    }else{
        myDelegate.autoSizeScaleX = 1.0;
        myDelegate.autoSizeScaleY = 1.0;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAdDetail:) name:BBLaunchAdDetailDisplayNotification object:nil];
    NSString *path = @"http://mg.soupingguo.com/bizhi/big/10/258/043/10258043.jpg";
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    ViewController *view = [[ViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:view];
    [BBLaunchAdMonitor showAdAtPath:path
                             onView:self.window.rootViewController.view
                       timeInterval:1.0f
                   detailParameters:@{@"carId":@(12345), @"name":@"奥迪-品质生活"}];

    return YES;
}
- (void)showAdDetail:(NSNotification *)noti{
    ViewController *view = [[ViewController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:view];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
