//
//  LoginViewController.m
//  LoginLayout
//
//  Created by 曹帅 on 15/12/15.
//  Copyright © 2015年 北京浩鹏盛世科技有限公司. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "YXYDataService.h"
#import <unistd.h>
#define kCellHeight ceil((kScreenWidth) * 3.0 / 4.0)

@interface YYWebImageExampleCell : UITableViewCell
@property (nonatomic, strong) UIImageView *webImageView;
@property (nonatomic,retain)NSURL *url;
@end

@implementation YYWebImageExampleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor clearColor];
    _webImageView = [UIImageView new];
    _webImageView.frame = CGRectMake(0, 0, kScreenWidth, kCellHeight);
    _webImageView.clipsToBounds = YES;
//    _webImageView.contentMode = UIViewContentModeScaleAspectFill;
    _webImageView.backgroundColor = [UIColor clearColor];
//    [self.contentView addSubview:_webImageView];
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:_url];
    result = [UIImage imageWithData:data];
    [_webImageView setImage:result];
}

//- (void)setImageURL:(NSURL *)url {
//    NSLog(@"%@",url);
//    UIImage * result;
//    NSData * data = [NSData dataWithContentsOfURL:url];
//    result = [UIImage imageWithData:data];
//    [_webImageView setImage:result];
//    
//}

@end



@interface LoginViewController ()<MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,assign)BOOL yes;
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)NSMutableArray *dataArr;
@property(nonatomic,retain)UIRefreshControl *refresh;

@end

@implementation LoginViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.alpha = 1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.backgroundColor = [UIColor grayColor];
    self.navigationController.navigationBar.alpha = 0.5;
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.backgroundColor = [UIColor grayColor];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    NSLog(@"%@",self.dataArr);
    if (self.dataArr.count == 0) {
        [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    }
}

- (void)myTask{
    NSString *method = @"GET";
    //参数（已经拼接在URL里面了，也可以在下面单独拼接）
    //发请求（AF）
        [YXYDataService requestWithURL:@"http://114.251.190.252/gxlsgdev/ecmobile/?url=category_new" params:nil httpMethod:method block:^(NSObject *result) {
            if (result == nil) {
                sleep(2);
            }else{
                sleep(1);

                NSLog(@"%@",result);

                NSDictionary *dic = (NSDictionary *)result;
                if (self.dataArr != nil) {
                    NSArray *array = [dic objectForKey:@"data"];
                    [self.dataArr addObjectsFromArray:array];
                }else{
                    self.dataArr = [dic objectForKey:@"data"];
                }
                [self.tableView reloadData];
                [_refresh endRefreshing];
            }
        } errorBlock:^(NSObject *result) {
            sleep(5);
            //
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络错误" message:@"请检查网络连接" preferredStyle:UIAlertControllerStyleAlert];
                                        
            [self presentViewController:alert animated:YES completion:nil];
            [_refresh endRefreshing];
            sleep(2);
            [alert removeFromParentViewController];
        }];
}
- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
//    [_tableView setEditing:self.yes animated:YES];
}

- (void)SingleTap:(UITapGestureRecognizer *)singleRecognizer{
    NSLog(@"1----%@",(self.yes)?@"YES":@"NO");
    self.yes = !self.yes;
    if (self.yes) {
        NSLog(@"123");
        NSLog(@"2----%@",(self.yes)?@"YES":@"NO");
        [_tableView setEditing:self.yes animated:YES];
    }else{
        NSLog(@"321");
        NSLog(@"3----%@",(self.yes)?@"YES":@"NO");
        [_tableView setEditing:self.yes animated:YES];
    }
    NSLog(@"4----%@",(self.yes)?@"YES":@"NO");
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake1(0,0, kScreenWidth, kScreenHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //添加长按手势
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGR.minimumPressDuration = 1.0;
        [_tableView addGestureRecognizer:longPressGR];
        
        
        // 单击的 Recognizer
        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
        //点击的次数
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        
        //给self.view添加一个手势监测；
        
        [_tableView addGestureRecognizer:singleRecognizer];
        
        [self.view addSubview:_tableView];
        
        
        
        
        _refresh = [[UIRefreshControl alloc] init];
        
        _refresh.tintColor = [UIColor cyanColor];
        
        _refresh.attributedTitle =[[NSAttributedString alloc]initWithString:@"正在加载"];
        
        [_refresh addTarget:self action:@selector(myTask) forControlEvents:UIControlEventValueChanged];
        
        [_tableView addSubview:_refresh];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return kCellHeight;
//}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYWebImageExampleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) cell = [[YYWebImageExampleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    NSDictionary *dic = self.dataArr[indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"name"];
//    NSLog(@"%@",[self.dataArr[indexPath.row] objectForKey:@"content"]);
//    cell.url = [NSURL URLWithString:[[self.dataArr[indexPath.section] objectForKey:@"pict"] objectForKey:@"url"]];
    return cell;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了删除");
        // 1. 更新数据
        [self.dataArr removeObjectAtIndex:indexPath.row];
        // 2. 更新UI
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    // 删除一个置顶按钮
        UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
           NSLog(@"点击了置顶");
    // 1. 更新数据
            [self.dataArr exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
    //        // 2. 更新UI
            NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
            [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
            [tableView reloadRowsAtIndexPaths:@[firstIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
    
        topRowAction.backgroundColor = [UIColor blueColor];
    
    // 添加一个更多按钮
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"更多" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了更多");
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    }];
    moreRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    
    
    // 将设置好的按钮放到数组中返回
    
    return @[deleteRowAction, topRowAction, moreRowAction];
    
//    return @[deleteRowAction,moreRowAction];
    
}
@end
