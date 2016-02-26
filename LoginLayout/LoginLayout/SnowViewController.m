//
//  SnowViewController.m
//  LoginLayout
//
//  Created by 曹帅 on 15/12/29.
//  Copyright © 2015年 北京浩鹏盛世科技有限公司. All rights reserved.
//

#import "SnowViewController.h"

#define SNOW_IMAGENAME		 @"Snow"
#define Main_Screen_Width ([UIScreen mainScreen].bounds.size.width)
#define Main_Screen_Height ([UIScreen mainScreen].bounds.size.height)
#define IMAGE_X				arc4random()%(int)Main_Screen_Width
#define IMAGE_ALPHA			((float)(arc4random()%10))/10
#define IMAGE_WIDTH			arc4random()%20 + 10
#define PLUS_HEIGHT			Main_Screen_Height/25
@interface SnowViewController ()
{
    NSTimer *timers;
}
@property(nonatomic,retain)UIAlertAction *secureTextAlertAction;
@end

@implementation SnowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self showSecureTextEntryAlert];
    
//    [UIView beginAnimations:[NSString stringWithFormat:@"%li",(long)aImageView.tag] context:nil];
//    [UIView setAnimationDuration:6];
//    [UIView setAnimationDelegate:self];
//    aImageView.frame = CGRectMake(IMAGE_X * 1.2, Main_Screen_Height, aImageView.frame.size.width, aImageView.frame.size.height);
////    NSLog(@"%@",aImageView);
//    [UIView commitAnimations];
//    aImageView.text = nil;
}

- (void)makeSnow
{
    float x = IMAGE_WIDTH;
    //    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:SNOW_IMAGENAME]];
    //    imageView.frame = CGRectMake(IMAGE_X, -30, x, x);
    //    imageView.alpha = IMAGE_ALPHA;
    UILabel *label = [[UILabel alloc] init];
    label.text = @"❄️";
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.frame = CGRectMake(IMAGE_X, -30, x, x);
    label.alpha = IMAGE_ALPHA;
        [self.view addSubview:label];
        [self snowFall:label];
    //    [self.view addSubview:imageView];
    //    [self snowFall:imageView];
}

- (void)snowFall:(UILabel *)aImageView
{
    [UIView animateWithDuration:5 animations:^{
        aImageView.frame = CGRectMake(IMAGE_X * 1.2, Main_Screen_Height, aImageView.frame.size.width, aImageView.frame.size.height);
    } completion:^(BOOL finished) {
        aImageView.text = nil;
        [aImageView removeFromSuperview];
    }];
    
}
- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)notification {
    UITextField *textField = notification.object;
    NSLog(@"%@",textField.text);
    // Enforce a minimum length of >= 5 characters for secure text alerts.
    self.secureTextAlertAction.enabled = textField.text.length >= 5;
}
- (void)showSecureTextEntryAlert {
    NSString *title = NSLocalizedString(@"要下雪", nil);
    NSString *message = NSLocalizedString(@"请输入五位以上有效字符.", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"OK", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Add the text field for the secure text entry.
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        // Listen for changes to the text field's text so that we can toggle the current
        // action's enabled property based on whether the user has entered a sufficiently
        // secure entry.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];
        
        textField.secureTextEntry = YES;
    }];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Secure Text Entry\" alert's cancel action occured.");
        
        // Stop listening for text changed notifications.
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alertController.textFields.firstObject];
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        timers = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(makeSnow) userInfo:nil repeats:YES];
        [timers fire];
        [self.view setBackgroundColor:[UIColor grayColor]];
        
        // Stop listening for text changed notifications.
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alertController.textFields.firstObject];
    }];
    
    // The text field initially has no text in the text field, so we'll disable it.
    otherAction.enabled = NO;
    
    // Hold onto the secure text alert action to toggle the enabled/disabled state when the text changed.
    self.secureTextAlertAction = otherAction;
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
