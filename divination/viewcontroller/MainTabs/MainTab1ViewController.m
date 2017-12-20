//
//  MainTab2ViewController.m
//  loan_supermarket
//
//  Created by 杨世友 on 2017/12/1.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

@import GoogleMobileAds;

#import "MainTab1ViewController.h"
#import "LoveDivinationViewController.h"
#import "CareerDivinationViewController.h"
#import "PhoneDivinationViewController.h"
#import "OtherViewController.h"
#import "InfoApi.h"
#import "PublicApi.h"
#import "Response.h"
#import "IndexInfo.h"
#import "UserInfo.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "Tab1Cell.h"
#import "UIColor+Hex.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface MainTab1ViewController ()<UITableViewDelegate,UITableViewDataSource,OnItemClickListener>
{
    //DFPBannerView *bannerView;
    UIActivityIndicatorView *_indicator;
    UILabel *label;
    UITableView *listTable;
    UIView *bottomView;
}

@property(nonatomic,strong) InfoApi *infoApi;
@property(nonatomic,strong) PublicApi *publicApi;

@end

@implementation MainTab1ViewController

@synthesize bannerView=_bannerView;

-(InfoApi *)infoApi
{
    if(!_infoApi)
        _infoApi=[[InfoApi alloc] init];
    //NSLog(@"_userBaseApi:%@",_userBaseApi);
    
    return _infoApi;
}





#pragma mark -
#pragma mark GADBannerViewDelegate

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    // 広告取得完了時の動作を実装
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    // 広告取得失敗時の動作を実装
}


-(void)index_info{
    [listTable.mj_header endRefreshing];
    [listTable.mj_footer endRefreshing];
    
    [_indicator startAnimating];
    //[SVProgressHUD showWithStatus:@"正在加载..."];
    [self.infoApi index_infoWithComplete:^(id result, NSError *error) {
        if (error)
        {
            [_indicator stopAnimating];
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
            
            NSLog(@"MainTab1ViewController Result: %@", result);
            
            Response *response=[Response objectWithKeyValues:result];
            if(response){
                NSInteger code=response.code;
                NSString *msg=response.message;
                
                NSLog(@"%@",msg);
                
                if(code==200){
                    if(response.result){
                        NSArray *array= [IndexInfo objectArrayWithKeyValuesArray:response.result];
                        self.dataSource=[array copy];
                        if (listTable) {
                            [listTable.mj_header endRefreshing];
                            [listTable.mj_footer endRefreshing];
                            [listTable reloadData];
                        }
                        [self bindData: array];
                    }
                }
                else{
                    //NSLog(@"%@",msg);
                }
            }
            
            
            [_indicator stopAnimating];
            //[SVProgressHUD dismiss];
            
        }
    }];
}

-(void)bindData:(NSArray *) array{
    if(array){
        //int count=[array count];
//        for(int i=0;i<count;i++){
//            [array objectAtIndex:i];
//        }
        for(id obj in array){
            if([obj isKindOfClass:[IndexInfo class]]){
                IndexInfo *indexInfo=(IndexInfo *)obj;
                NSLog(@"indexInfo.images:%@",indexInfo.images);
            }
        }
    }
}

-(PublicApi *)publicApi
{
    if(!_publicApi)
        _publicApi=[[PublicApi alloc] init];
    return _publicApi;
}
-(void)send_token{
    
    [_indicator startAnimating];
    //[SVProgressHUD showWithStatus:@"正在加载..."];
    
    [self.publicApi send_token:@"" andPassword:@"" complete:^(id result, NSError *error) {
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
            
            NSLog(@"Result: %@", result);
            
            Response *response=[Response objectWithKeyValues:result];
            if(response){
                NSInteger code=response.code;
                NSString *msg=response.message;
                
                NSLog(@"%@",msg);
                
                if(code==200){
                   [self index_info];
                }
                else{
                    //NSLog(@"%@",msg);
                }
            }
            
            [_indicator stopAnimating];
            //[SVProgressHUD dismiss];
            
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = [[NSMutableArray alloc] init];
    //self.dataSource = [NSMutableArray arrayWithObjects:@"1",@"2",@"3", nil];
    self.tempArray = [NSMutableArray array];
    
   [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createListTable];
    [self createTopView];
    [self createBottomView];
    [self loadAdsView];
    
    _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //设置显示位置
     _indicator.center = CGPointMake(kScreenWidth/2,kScreenHeight/2);
    //将这个控件加到父容器中。
    [self.view addSubview:_indicator];
    
    
    [self send_token];
    
    
}

- (void)createTopView
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 75)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#312950"];
    [self.view addSubview:topView];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    btn.frame = CGRectMake(10, 0, 40, 40);
//    [btn addTarget:self action:@selector(c_back) forControlEvents:UIControlEventTouchUpInside];
//    [topView addSubview:btn];
    
    label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"最新占い";
    label.frame = CGRectMake(kScreenWidth /2-80, 30, 160, 40);
    label.font = [UIFont systemFontOfSize:20.0];
    
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    [topView addSubview:label];
    
    UIButton *btnSetting=[[UIButton alloc] init];
    btnSetting.frame = CGRectMake(kScreenWidth-55,30, 30, 30);
    UIImage *image = [UIImage imageNamed:@"icon_setting"];
    [btnSetting setBackgroundImage:image forState:UIControlStateNormal];
    
    btnSetting.tag = 400 ;
    
    [btnSetting addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [topView addSubview:btnSetting];
    
   
    
}

- (void)buttonClicked:(UIButton *)btn
{
    switch (btn.tag) {
        case 400:
        {
            [self GotoOtherViewController];
            break;
        }
    }
}

-(void)loadAdsView{
    //kScreenWidth / 2 - 160, 100
    DFPBannerView *bannerView = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:CGPointMake(kScreenWidth / 2 - 160, kScreenHeight-49-15-(kScreenWidth/5))];
    
    bannerView.center=CGPointMake(kScreenWidth / 2, (kScreenWidth/10));
    
    bannerView.validAdSizes = @[NSValueFromGADAdSize(kGADAdSizeBanner)];
    
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
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-49-15-(kScreenWidth/5), kScreenWidth, (kScreenWidth/5))];
    //bottomView.backgroundColor = [UIColor colorWithHexString:@"#312950"];
    
//    NSString *imgName=[NSString stringWithFormat:@"tab1_img%d",4];
//    bottomView.image=[UIImage imageNamed:imgName];
    
    [self.view addSubview:bottomView];
}


- (void)createListTable
{
    //1.topview height:75
    //2.tableview item height;150
    //3.bottomview height:75
    
    
    
    if (!listTable) {
        listTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        listTable.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        listTable.showsVerticalScrollIndicator = NO;
        listTable.delegate = self;
        listTable.dataSource = self;
        [self setExtraCellLineHidden:listTable];
        

        listTable.frame = CGRectMake(0, 75, kScreenWidth, kScreenHeight-75-(49+15+(kScreenWidth/5)));
        
        __weak typeof(self) weakSelf = self;
        
        listTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            
            [weakSelf send_token];
        }];
        
        [self.view addSubview:listTable];
    }
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    //[tableView setTableFooterView:view];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //topView:75;tabBar:49;bottom:(kScreenWidth/5)=75(6s屏幕)
    CGFloat height=(kScreenHeight-75-49-(kScreenWidth/5)-15)/3-2;
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tab1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"list"];
    
    if (!cell) {
        cell = [[Tab1Cell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"list"];
    }
    cell.itemData=[self dataSource][indexPath.row];
    cell.index = indexPath.row;
    cell.listener = self;
    return cell;
}


-(void)onItemClick:(NSInteger)index{
    switch(index){
        case 0:
            [self GotoLoveDivinationViewController];
            break;
        case 1:
            [self GotoCareerDivinationViewController];
            break;
        case 2:
        {
            IndexInfo *indexInfo=[self.dataSource objectAtIndex:index];
            if(indexInfo){
                [self GotoPhoneDivinationViewController:indexInfo.id];
            }
            break;
        }
    }
}

-(void)GotoLoveDivinationViewController
{
    LoveDivinationViewController *divinationView= [[LoveDivinationViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
    
    [divinationView setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];//翻转效果
    
    //[diagnosisView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController pushViewController: divinationView animated:true];//这种方式一般是使用者浏览资料，继而可以前进到下一个页面或回到上一个页面。默认动画是从右至左。
    
    //[self presentViewController:diagnosisView animated:YES completion:nil];//这种方式一般出现在需要使用者完成某件事情，如输入密码、增加资料等操作后，才能(回到跳转前的控制器)继续。例如系统的WIFI连接输入密码提示。默认动画是从下至上。
}

-(void)GotoCareerDivinationViewController
{
    CareerDivinationViewController *divinationView= [[CareerDivinationViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
    
    [divinationView setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];//翻转效果
    
    //[diagnosisView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController pushViewController: divinationView animated:true];//这种方式一般是使用者浏览资料，继而可以前进到下一个页面或回到上一个页面。默认动画是从右至左。
    
    //[self presentViewController:diagnosisView animated:YES completion:nil];//这种方式一般出现在需要使用者完成某件事情，如输入密码、增加资料等操作后，才能(回到跳转前的控制器)继续。例如系统的WIFI连接输入密码提示。默认动画是从下至上。
}

-(void)GotoPhoneDivinationViewController:(NSInteger) detail_id
{
    PhoneDivinationViewController *divinationView= [[PhoneDivinationViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
    
    divinationView.detail_id=detail_id;
    
    [divinationView setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];//翻转效果
    
    //[diagnosisView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController pushViewController: divinationView animated:true];//这种方式一般是使用者浏览资料，继而可以前进到下一个页面或回到上一个页面。默认动画是从右至左。
    
    //[self presentViewController:diagnosisView animated:YES completion:nil];//这种方式一般出现在需要使用者完成某件事情，如输入密码、增加资料等操作后，才能(回到跳转前的控制器)继续。例如系统的WIFI连接输入密码提示。默认动画是从下至上。
    
}

-(void)GotoOtherViewController
{
    OtherViewController *otherView= [[OtherViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
    

    [self.navigationController pushViewController: otherView animated:true];
    
}


//- (void)removedRoad:(NSInteger)index
//{
//    if(self.dataSource&&[self.dataSource count]>index)
//    {
//        NSDictionary *dic= [self.dataSource objectAtIndex:index];
//
//        if(dic)
//        {
//        }
//    }
//}



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

