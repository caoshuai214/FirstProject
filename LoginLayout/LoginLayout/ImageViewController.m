//
//  ImageViewController.m
//  LoginLayout
//
//  Created by 曹帅 on 15/12/28.
//  Copyright © 2015年 北京浩鹏盛世科技有限公司. All rights reserved.
//

#import "ImageViewController.h"
#import "LineView.h"
#import "OBShapedButton.h"
@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    LineView *line = [[LineView alloc] init];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake1(40, 70, 0, 1)];
    label.backgroundColor = [UIColor orangeColor];
    [UIView animateWithDuration:5 animations:^{
        label.frame = CGRectMake1(40, 70, 100, 1);
        line.backgroundColor = [UIColor clearColor];
        line.frame = self.view.frame;
    } completion:^(BOOL finished) {
    }];
    [self.view addSubview:line];

    [self.view addSubview:label];

   
    OBShapedButton *button = [[OBShapedButton alloc] initWithFrame:CGRectMake(100, 300, 30, 43)];
    [button setImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    
    OBShapedButton *sbutton = [[OBShapedButton alloc] initWithFrame:CGRectMake(0, 100, 130, 131)];
    [sbutton setImage:[UIImage imageNamed:@"topleft-highlighted"] forState:UIControlStateNormal];
//    sbutton.backgroundColor = [UIColor redColor];
    [self.view addSubview:sbutton];
    OBShapedButton *bbutton = [[OBShapedButton alloc] initWithFrame:CGRectMake(160, 100, 160, 161)];
    [bbutton setImage:[UIImage imageNamed:@"topleft-h"] forState:UIControlStateNormal];
    //    sbutton.backgroundColor = [UIColor redColor];
    [self.view addSubview:bbutton];
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Snow.png"]];
    imageView.frame = CGRectMake(120.f, 120.f, 100.f, 75.f);
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 75/2;
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 10000;
    [imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    
//    UIImageView *imgView = [self rotate360DegreeWithImageView:imageView];
    self.view.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:imageView];
    
}

- (UIImageView *)rotate360DegreeWithImageView:(UIImageView *)imageView{
    CABasicAnimation *animation = [ CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:
                         CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    animation.duration = 5;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = 100000;
    
    //在图片边缘添加一个像素的透明区域，去图片锯齿
    CGRect imageRrect = CGRectMake(0, 0,imageView.frame.size.width, imageView.frame.size.height);
    UIGraphicsBeginImageContext(imageRrect.size);
    [imageView.image drawInRect:CGRectMake(1,1,imageView.frame.size.width-2,imageView.frame.size.height-2)];
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [imageView.layer addAnimation:animation forKey:nil];
    return imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
