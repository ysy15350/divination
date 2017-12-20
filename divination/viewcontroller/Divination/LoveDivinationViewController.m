//
//  PhoneDivinationViewController.m
//  divination
//
//  Created by 杨世友 on 2017/12/14.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

@import GoogleMobileAds;

#import "LoveDivinationViewController.h"
#import "WebViewViewController.h"
#import "Config.h"
#import "UserBaseApi.h"
#import "InfoApi.h"
#import "Response.h"
#import "Divination.h"
#import "UserInfo.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "LoveDivinationCell.h"
#import "UIColor+Hex.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface LoveDivinationViewController ()<UITableViewDelegate,UITableViewDataSource,LoveDivinationSelectDelegate>{
    UIActivityIndicatorView *_indicator;
    UILabel *label;//标题
    UITableView *listTable;
    UIView *bottomView;
    
    NSInteger pageIndex;
    NSInteger pageSize;
    NSInteger type;//1:恋爱相谈,2事业占卜，3评论列表
}

@property(nonatomic,strong) UserBaseApi *userBaseApi;
@property(nonatomic,strong) InfoApi *infoApi;

@end

@implementation LoveDivinationViewController

-(UserBaseApi *)userBaseApi
{
    if(!_userBaseApi)
        _userBaseApi=[[UserBaseApi alloc] init];
    //NSLog(@"_userBaseApi:%@",_userBaseApi);
    
    return _userBaseApi;
}

-(InfoApi *)infoApi
{
    if(!_infoApi)
        _infoApi=[[InfoApi alloc] init];
    //NSLog(@"_userBaseApi:%@",_userBaseApi);
    
    return _infoApi;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    type=1;//1:恋爱相谈,2事业占卜，3评论列表
    pageIndex=1;
    pageSize=10;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.dataSource = [[NSMutableArray alloc] init];
    //self.dataSource = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8", nil];
    self.tempArray = [NSMutableArray array];
    
    [self createListTable];
    [self createTopView];
    [self createBottomView];
    [self loadAdsView];
    
    _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //设置显示位置
    _indicator.center = CGPointMake(kScreenWidth/2,kScreenHeight/2);
    //将这个控件加到父容器中。
    [self.view addSubview:_indicator];
    
    [self loadData];
    
}

- (void)createTopView
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#e1dfed"];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 75)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#312950"];
    [self.view addSubview:topView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 25, 40, 40);
    [btn addTarget:self action:@selector(c_back) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btn];
    
    label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"恋愛相談";//仕事・人間関係
    label.frame = CGRectMake(kScreenWidth /2-80, 30, 160, 40);
    label.font = [UIFont systemFontOfSize:20.0];
    
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:label];
    
}

-(void)loadAdsView{
    //kScreenWidth / 2 - 160, 100
    DFPBannerView *bannerView = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:CGPointMake(kScreenWidth / 2 - 160, kScreenHeight-(kScreenWidth/5))];
    
    bannerView.validAdSizes = @[NSValueFromGADAdSize(kGADAdSizeBanner)];
    bannerView.center=CGPointMake(kScreenWidth / 2, (kScreenWidth/10));
    
    // 実際に配信に使用するAd Unit IDは、営業担当者から別途お知らせ致します。  实际上使用的ad unit id将由营业负责人另行通知
    // こちらはテスト用のIDになります。     这是一个测试用的id
    bannerView.adUnitID = @"/9116787/1261569";//@"/6499/example/banner";//@"/9116787/1241401";
    bannerView.rootViewController = self;
    bannerView.backgroundColor=[UIColor colorWithHexString:@"#fff2df"];
    // デリゲートは必要に応じて実装してください  请根据需要来实现委派
    // See also: https://developers.google.com/mobile-ads-sdk/docs/dfp/ios/ad-events
    //bannerView.delegate = self;
    
    DFPRequest *request = DFPRequest.new;
    
    [bannerView loadRequest:request];
    [bottomView addSubview:bannerView];
    //self.backgroundColor = newColor(228, 225, 215, 1);
    self.bannerView=bannerView;
    //self.bannerView = bannerView;
}

- (void)createBottomView
{
    //底部tabBar height 49  间距 :15 bottom height:75
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-(kScreenWidth/5), kScreenWidth, (kScreenWidth/5))];
    //bottomView.backgroundColor = [UIColor colorWithHexString:@"#312950"];
    
//    NSString *imgName=[NSString stringWithFormat:@"tab1_img%d",4];
//    bottomView.image=[UIImage imageNamed:imgName];
    
    [self.view addSubview:bottomView];
}

- (void)createListTable
{
    if (!listTable) {
        listTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        listTable.showsVerticalScrollIndicator = NO;
        listTable.delegate = self;
        listTable.dataSource = self;
        [self setExtraCellLineHidden:listTable];
        
        
        __weak typeof(self) weakSelf = self;
        
        listTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            pageIndex = 1;
            
            [weakSelf loadData];
        }];
        listTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            pageIndex ++;
            [weakSelf loadMore];
        }];
        
        listTable.frame = CGRectMake(0, 90, kScreenWidth, kScreenHeight-90-(15+(kScreenWidth/5)));
        
        [self.view addSubview:listTable];
    }
}

- (void)setExtraCellLineHidden: (UITableView *)tableView


{
    
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoveDivinationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list"];
    
    if (!cell) {
        cell = [[LoveDivinationCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"list"];
    }
    cell.itemData=[self dataSource][indexPath.row];
    cell.index = indexPath.row;
    cell.delegate = self;
    return cell;
}


////获取数据
//- (void)loadData
//{
//    [listTable.mj_header endRefreshing];
//    [listTable.mj_footer endRefreshing];
//
//
//    [SVProgressHUD showWithStatus:@"正在加载..."];
//
//    [self.userBaseApi m_login_in:@"15215095191" withPassword:@"kite082819" complete:^(id result, NSError *error) {
//        if (error)
//        {
//            NSLog(@"Error: %@", error);
//        }
//        else
//        {
//
//            //UserInfo *userinfo=[UserInfo objectWithKeyValues:result];
//
//            //是否属于类（子类）
//            //[userinfo isKindOfClass:[UserInfo class]];
//            //实际是否是这个类
//            //[userinfo isMemberOfClass:[UserInfo class]];
//            //对象中是否对指定方法做出反应：(是否包含这个方法)
//            //[userinfo respondsToSelector:@selector(tests)];
//
//            NSLog(@"Result: %@", result);
//
//
//            self.dataSource = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8", nil];
//
//
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"list" object:nil userInfo:@{@"list":self.dataSource}];
//
//            if (listTable) {
//                [listTable reloadData];
//            }
//
//            [SVProgressHUD dismiss];
//
//        }
//    }];
//
//
//
//
//
//}

//获取数据
- (void)loadData
{
    [listTable.mj_header endRefreshing];
    [listTable.mj_footer endRefreshing];
    
    
    [_indicator startAnimating];
    //[SVProgressHUD showWithStatus:@"正在加载..."];
    
    [self.infoApi lists:type page:pageIndex num:pageSize complete:^(id result, NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", error);
        }
        else
        {
            
            //UserInfo *userinfo=[UserInfo objectWithKeyValues:result];
            
            //是否属于类（子类）
            //[userinfo isKindOfClass:[UserInfo class]];
            //实际是否是这个类
            //[userinfo isMemberOfClass:[UserInfo class]];
            //对象中是否对指定方法做出反应：(是否包含这个方法)
            //[userinfo respondsToSelector:@selector(tests)];
            
            NSLog(@"LoveDivinationViewController Result: %@", result);
            Response *response=[Response objectWithKeyValues:result];
            if(response){
                NSInteger code=response.code;
                NSString *msg=response.message;
                
                NSLog(@"%@",msg);
                
                if(code==200){
                    NSArray *array= [Divination objectArrayWithKeyValuesArray:response.result];
                    self.dataSource=[array copy];
                   
                    self.tempArray=[array copy];
                    
                    [self bindData:self.tempArray];
                    
                }
                else{
                    //NSLog(@"%@",msg);
                }
            }
            
            
            
            //self.dataSource = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8", nil];
            
            [_indicator stopAnimating];
            //[SVProgressHUD dismiss];
            
        }
    }];
    
    
    
    
    
}

-(void)loadMore
{
    [listTable.mj_header endRefreshing];
    [listTable.mj_footer endRefreshing];
    
    
    [_indicator startAnimating];
    //[SVProgressHUD showWithStatus:@"正在加载..."];
    
    [self.infoApi lists:type page:pageIndex num:pageSize complete:^(id result, NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", error);
        }
        else
        {
            
            //UserInfo *userinfo=[UserInfo objectWithKeyValues:result];
            
            //是否属于类（子类）
            //[userinfo isKindOfClass:[UserInfo class]];
            //实际是否是这个类
            //[userinfo isMemberOfClass:[UserInfo class]];
            //对象中是否对指定方法做出反应：(是否包含这个方法)
            //[userinfo respondsToSelector:@selector(tests)];
            
            NSLog(@"LoveDivinationViewController Result: %@", result);
            Response *response=[Response objectWithKeyValues:result];
            if(response){
                NSInteger code=response.code;
                NSString *msg=response.message;
                
                NSLog(@"%@",msg);
                
                if(code==200){
                    NSArray *array= [Divination objectArrayWithKeyValuesArray:response.result];
                    
                    if(array){
                    
                    
                        
                         [self.tempArray addObjectsFromArray: [array copy]];
                        
                        [self bindData:self.tempArray];
                    }
                    
                }
                else{
                    //NSLog(@"%@",msg);
                }
            }
            
            
            
            //self.dataSource = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8", nil];
            
            [_indicator stopAnimating];
            //[SVProgressHUD dismiss];
            
        }
    }];
}

-(void)bindData:(NSMutableArray *)data
{
    self.dataSource =data;
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"list" object:nil userInfo:@{@"list":self.dataSource}];
    
    if (listTable) {
        [listTable.mj_header endRefreshing];
        [listTable.mj_footer endRefreshing];
        [listTable reloadData];
    }
    
    [_indicator stopAnimating];
    //[SVProgressHUD dismiss];

}

-(void)detail:(NSInteger)index{
    Divination *divination= [self.dataSource objectAtIndex:index];
    if(divination){
        NSString *title=divination.title;
        NSString *tz_url=divination.tz_url;
        NSString *detail_url=divination.detail_url;
        
        NSString *webUrl=nil;
        
        if(tz_url&&![@"" isEqualToString:tz_url]){
            webUrl=tz_url;
        }
        else if(detail_url){
            NSString *url= [Config getServiceUrl];
            webUrl=[url stringByAppendingString:detail_url];
        }
        
        if(webUrl&&![webUrl isEqualToString:@""]){
            
            NSLog(@"openweb,title:%@,url:%@",title,webUrl);
            
            [self GotoWebViewController:webUrl withTitle:title];
        }
    }
}

-(void)GotoWebViewController:(NSString *)url withTitle:(NSString *)title
{
    WebViewViewController *webView= [[WebViewViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
    
    webView.webUrl=url;//@"http://www.ysy15350.com";
    webView.title=title;
    
    [webView setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];//翻转效果
    
    //[diagnosisView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController pushViewController: webView animated:true];//这种方式一般是使用者浏览资料，继而可以前进到下一个页面或回到上一个页面。默认动画是从右至左。
    
    //[self presentViewController:diagnosisView animated:YES completion:nil];//这种方式一般出现在需要使用者完成某件事情，如输入密码、增加资料等操作后，才能(回到跳转前的控制器)继续。例如系统的WIFI连接输入密码提示。默认动画是从下至上。
    
}


- (void)c_back
{
    [self.navigationController popViewControllerAnimated:YES];
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
