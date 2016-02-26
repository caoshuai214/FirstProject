//
//  ZhiWenViewController.m
//  LoginLayout
//
//  Created by 曹帅 on 15/12/21.
//  Copyright © 2015年 北京浩鹏盛世科技有限公司. All rights reserved.
//

#import "ZhiWenViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "UIScrollView+MJExtension.h"
#import "MJRefreshGifHeader.h"
#import "MJRefreshAutoGifFooter.h"
@interface YYWebCell : UITableViewCell
@property (nonatomic, strong) UIImageView *webImageView;
@property (nonatomic,retain)NSURL *url;
@end

@implementation YYWebCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    return self;
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //上分割线，
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"ffffff" withAlpha:0.5f].CGColor); CGContextStrokeRect(context, CGRectMake1(15 * 5, -1, rect.size.width, 1));
    //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"e2e2e2" withAlpha:1.0f].CGColor); CGContextStrokeRect(context, CGRectMake1(15 * 5, rect.size.height, rect.size.width, 1));
}
@end
@interface ZhiWenViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UITableView *tableView;

@property(nonatomic,retain)NSMutableArray *dataArr;
@property(nonatomic,retain)UIView *buttonView;
@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,retain)UIImageView *imgView;
@end

@implementation ZhiWenViewController
//- (void) viewDidLayoutSubviews {
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
//        CGRect viewBounds = self.view.bounds;
//        CGFloat topBarOffset = self.topLayoutGuide.length;
//        viewBounds.origin.y = topBarOffset * -1;
//        self.view.bounds = viewBounds;
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    }
//}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    // Do any additional setup after loading the view from its nib.
//    self.tableView.backgroundColor = [UIColor cyanColor];
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    [view addSubview:self.tableView];
    [self.view addSubview:view];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor grayColor];
    [self setExtraCellLineHidden:self.tableView];
//    [self initButton];
}


- (void)initButton{
    self.buttonView = [[UIView alloc] initWithFrame:CGRectMake1(0, 0, kScreenWidth, 64)];
    self.buttonView.backgroundColor = [UIColor orangeColor];
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake1(0, 0, self.buttonView.frame.size.height, self.buttonView.frame.size.height)];
    self.imgView.backgroundColor = [UIColor blueColor];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake1(self.imgView.frame.size.width + 20, 64/2 - 15,self.buttonView.frame.size.width - self.imgView.frame.size.width - 20, 30)];
    self.titleLabel.backgroundColor = [UIColor redColor];
    self.titleLabel.text = @"asnkjdasndajsdakjsdasdasda";
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.buttonView addSubview:self.titleLabel];
    [self.buttonView addSubview:self.imgView];
    [self.view addSubview:self.buttonView];
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
        // 设置普通状态的动画图片
        for (NSUInteger i = 1; i<=2; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%zd", i]];
            [self.dataArr addObject:image];
        }
    }
    return _dataArr;
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    NSLog(@"123");
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake1(0 ,0, kScreenWidth, kScreenHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        _tableView.scrollsToTop = YES;
      
        //添加长按手势
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGR.minimumPressDuration = 1.0;
        [_tableView addGestureRecognizer:longPressGR];
        
        
//        [self.view addSubview:_tableView];

        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        header.tag = 10000;
        // 设置普通状态的动画图片
        [header setImages:self.dataArr forState:MJRefreshStateIdle];
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        [header setImages:self.dataArr forState:MJRefreshStatePulling];
        // 设置正在刷新状态的动画图片
        [header setImages:self.dataArr forState:MJRefreshStateRefreshing];
//        // 隐藏时间
//        header.lastUpdatedTimeLabel.hidden = YES;
//        
//        // 隐藏状态
//        header.stateLabel.hidden = YES;
        // 设置文字
        [header setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
        [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
        [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
        
        // 设置字体
        header.stateLabel.font = [UIFont systemFontOfSize:15];
        header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
        
        // 设置颜色
        header.stateLabel.textColor = [UIColor redColor];
        // 设置header
        self.tableView.mj_header = header;
        
        MJRefreshAutoGifFooter *foot = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [foot setImages:self.dataArr forState:MJRefreshStateIdle];
        [foot setImages:self.dataArr forState:MJRefreshStatePulling];
        [foot setImages:self.dataArr forState:MJRefreshStateRefreshing];
        
        self.tableView.mj_footer = foot;
        [self initView];
    }
    return _tableView;
}

- (void)loadMoreData{
    sleep(3);
    [self.tableView.mj_footer endRefreshing];
}

- (void)loadNewData{
    sleep(4);
    [self.tableView.mj_header endRefreshing];
}

- (void)initView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake1(0, 0, 15 * 5, 44 * 5)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake1(0, (view.frame.size.height - 20)/2,view.frame.size.width , 20)];
    label.text = @"我的优惠";
    label.textColor = [UIColor cyanColor];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    [self.tableView addSubview:view];
    
    UIView *twoView = [[UIView alloc] initWithFrame:CGRectMake1(0,44 * 5 + 10, 15 * 5, 44 * 3)];
//    twoView.backgroundColor = [UIColor greenColor];
    UILabel *twolabel = [[UILabel alloc] initWithFrame:CGRectMake1(0, (twoView.frame.size.height - 20)/2,twoView.frame.size.width , 20)];
    twolabel.text = @"我的优惠";
    twolabel.textColor = [UIColor cyanColor];
    twolabel.textAlignment = NSTextAlignmentCenter;
    [twoView addSubview:twolabel];
    [self.tableView addSubview:twoView];
    
    UIView *threeView = [[UIView alloc] initWithFrame:CGRectMake1(0,44 * 8 + 10 * 2, 15 * 5, 44 * 3)];
    //    twoView.backgroundColor = [UIColor greenColor];
    UILabel *threelabel = [[UILabel alloc] initWithFrame:CGRectMake1(0, (threeView.frame.size.height - 20)/2,twoView.frame.size.width , 20)];
    threelabel.text = @"我的优惠";
    threelabel.textColor = [UIColor cyanColor];
    threelabel.textAlignment = NSTextAlignmentCenter;
    [threeView addSubview:threelabel];
    [self.tableView addSubview:threeView];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat h = self.tableView.contentOffset.y;
    NSLog(@"%lf",h);
    if (ABS(h) > 130) {
//        MJRefreshGifHeader *header = (MJRefreshGifHeader *)[self.view viewWithTag:10000];
//        // 隐藏时间
//        header.lastUpdatedTimeLabel.hidden = YES;
//        // 隐藏状态
//        header.stateLabel.hidden = YES;
//        self.buttonView.frame = CGRectMake1(0, 0, kScreenWidth, ABS(h));
//        self.imgView.frame = CGRectMake1(0, 0, self.buttonView.frame.size.height, ABS(h));
//        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake1(ABS(h) + 20, ABS(h)/2 - 15,self.buttonView.frame.size.width - ABS(h) - 20, 30)];
        
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    if (section == 1) {
        return 3;
    }
    if (section == 2) {
        return 3;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 6;
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]  init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYWebCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) cell = [[YYWebCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"官方客服";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"官方网站123";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = @"官方客服321";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row == 3) {
            cell.textLabel.text = @"官方网站132";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row == 4) {
            cell.textLabel.text = @"官方客服321";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"版权声明1";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"版权声明2";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = @"版权声明3";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"清除缓存";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"版权声明2";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = @"版权声明3";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return 0;
    }
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"123123123");
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 5;
//}

@end
