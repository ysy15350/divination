//
//  MainTab2ViewController.m
//  loan_supermarket
//
//  Created by 杨世友 on 2017/12/1.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import "MainTab2ViewController.h"
#import "WebViewViewController.h"
#import "CommentViewController.h"
#import "WebViewViewController.h"
#import "Config.h"
#import "UserBaseApi.h"
#import "InfoApi.h"
#import "Response.h"
#import "Divination.h"
#import "UserInfo.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "Tab2Cell.h"
#import "UIColor+Hex.h"
#import <GNAdSDK/GNNativeAdRequest.h>
#import <GNAdSDK/GNNativeAd.h>
#import "GNQueue.h"
#import "UIImageView+WebCache.h"

@import GoogleMobileAds;

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface MainTab2ViewController ()<UITableViewDelegate,UITableViewDataSource,CommentSelectDelegate,GNNativeAdRequestDelegate>
{
    UIActivityIndicatorView *_indicator;
    UILabel *label;
    UITableView *listTable;
    
    UIView *bottomView;
    
    NSInteger pageIndex;
    NSInteger pageSize;
    NSInteger type;//1:恋爱相谈,2事业占卜，3评论列表
    
    GNNativeAdRequest *_nativeAdRequest;
    BOOL _loading;
    NSTimeInterval secondsStart, secondsEnd;
    GNQueue *queueAds;
}

@property(nonatomic,strong) UserBaseApi *userBaseApi;
@property(nonatomic,strong) InfoApi *infoApi;

@property (nonatomic, strong)GNNativeAd *adItemView;//列表广告

@end

@implementation MainTab2ViewController

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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    type=3;//1:恋爱相谈,2事业占卜，3评论列表
    pageIndex=1;
    pageSize=10;
    
    self.dataSource = [[NSMutableArray alloc] init];
    //self.dataSource = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8", nil];
    self.tempArray = [NSMutableArray array];
   
    
    [self createListTable];
    [self createTopView];
    [self createBottomView];
    [self loadAdsView];//底部广告
    [self createGNNativeAdRequest];//列表内广告
    
    _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //设置显示位置
    _indicator.center = CGPointMake(kScreenWidth/2,kScreenHeight/2);
    //将这个控件加到父容器中。
    [self.view addSubview:_indicator];
    
    [self loadData];
    
}

-(void)createGNNativeAdRequest{
    // Create GNNativeAdRequest
    _nativeAdRequest = [[GNNativeAdRequest alloc] initWithID:@"1261573"];//1261573

    _nativeAdRequest.delegate = self;
    _nativeAdRequest.GNAdlogPriority = GNLogPriorityInfo;
    _nativeAdRequest.geoLocationEnable = YES;
    [_nativeAdRequest loadAds];
    
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
    label.text = @"口コミ";
    label.frame = CGRectMake(kScreenWidth /2-80, 30, 160, 40);
    label.font = [UIFont systemFontOfSize:20.0];
    
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:label];
    
}

-(void)loadAdsView{
    //kScreenWidth / 2 - 160, 100
    DFPBannerView *bannerView = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:CGPointMake(kScreenWidth / 2 - 160, kScreenHeight-49-15-(kScreenWidth/5))];
    
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
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-49-15-(kScreenWidth/5), kScreenWidth, (kScreenWidth/5))];
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
        
        listTable.frame = CGRectMake(0, 85, kScreenWidth, kScreenHeight-85-(49+15+(kScreenWidth/5)));
        
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
    long count=self.dataSource.count;
//    if(count>=4){
//        count++;
//    }
    
    return count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;//180
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tab2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"list"];
    
    if (!cell) {
        cell = [[Tab2Cell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"list"];
    }
    if(indexPath.row==-1){
        
//        cell.title.text = nativeAd.title;
//        cell.description.text = nativeAd.description;
//        cell.icon.image = nil;
       // NSURL *url = [NSURL URLWithString:self.adItemView.icon_url];
        
//        Divination *mode=
//        cell.itemData=;
        
        cell.labelTitle.text=@"広告";//self.adItemView.title;
        cell.labelContent.text=@"広告の内容";
        
        //
//        [cell.imgHead sd_setImageWithURL:[NSURL URLWithString:@"http://www.360vrdh.com:8080/api/file/imgGet?fid=2"]
//                        placeholderImage:[UIImage imageNamed:@"tab1_item_test"]];
        
        if(self.adItemView){
            NSString *imageUrl=self.adItemView.icon_url;
            cell.labelTitle.text=self.adItemView.title;
            cell.labelContent.text=self.adItemView.description;
            //http://www.360vrdh.com:8080/api/file/imgGet?fid=2
            [cell.imgHead sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                        placeholderImage:[UIImage imageNamed:@"tab1_item_test"]];
        }
    }
    else{
        long index=indexPath.row;
        cell.itemData=[self dataSource][index];
    }
    cell.index = indexPath.row;
    cell.delegate = self;
    return cell;
}


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
            
            NSLog(@"Result: %@", result);
            Response *response=[Response objectWithKeyValues:result];
            if(response){
                NSInteger code=response.code;
                NSString *msg=response.message;
                
                NSLog(@"%@",msg);
                
                if(code==200){
                    NSMutableArray *array= [Divination objectArrayWithKeyValuesArray:response.result];
                    
                    
//                    if(array){
//                        if(array.count>=3){
//
//                            Divination *item=[[Divination alloc] init];
//
//                            item.type=1;
//
//                            [array addObject:item];
//
//                            //[self.dataSource insertObject:item atIndex:3];
//                        }
//                    }
                    
                    self.tempArray=[array copy];
                    
                    
                    [self bindData:[array copy]];
                    
                
                }
                else{
                    //NSLog(@"%@",msg);
                }
            }
            
            
            
            //self.dataSource = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8", nil];
            
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"list" object:nil userInfo:@{@"list":self.dataSource}];
//
            
            
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
            
            NSLog(@"Result: %@", result);
            Response *response=[Response objectWithKeyValues:result];
            if(response){
                NSInteger code=response.code;
                NSString *msg=response.message;
                
                NSLog(@"%@",msg);
                
                if(code==200){
                    NSMutableArray *array= [Divination objectArrayWithKeyValuesArray:response.result];
                    
                    
                    if(array){
                        if(array.count>=3){
                            
                            Divination *item=[[Divination alloc] init];
                            
                            item.type=1;
                            
                            [array addObject:item];
                            
                            //[self.dataSource insertObject:item atIndex:3];
                        }
                        
                        [self.tempArray addObjectsFromArray: [array copy]];
                        [self bindData:self.tempArray];
                    }
                   
                }
                else{
                    //NSLog(@"%@",msg);
                }
            }
            
            
            
            //self.dataSource = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8", nil];
            
            
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"list" object:nil userInfo:@{@"list":self.dataSource}];
            //
            
            
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



-(void)detailComment:(NSInteger)index{
    NSLog(@"detail%ld",index);
    Divination *divination= [self.dataSource objectAtIndex:index];
    if(divination){
        [self GotoCommentViewController:divination.id];
    }
   
}


- (void)openWebView:(NSInteger)index{
    Divination *divination= [self.dataSource objectAtIndex:index];
    if(divination){
        if(divination.tz_url){
            //NSString *url= [Config getServiceUrl];
            NSString *webUrl=divination.tz_url;//[url stringByAppendingString:divination.detail_url];
            NSString *title=divination.title;
            NSLog(@"detail:%@",webUrl);
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




-(void)GotoCommentViewController:(NSInteger) detail_id
{
    CommentViewController *commentView= [[CommentViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
    
    commentView.detail_id=detail_id;
    
    [commentView setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];//翻转效果
    
    //[diagnosisView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController pushViewController: commentView animated:true];//这种方式一般是使用者浏览资料，继而可以前进到下一个页面或回到上一个页面。默认动画是从右至左。
    
    //[self presentViewController:diagnosisView animated:YES completion:nil];//这种方式一般出现在需要使用者完成某件事情，如输入密码、增加资料等操作后，才能(回到跳转前的控制器)继续。例如系统的WIFI连接输入密码提示。默认动画是从下至上。
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _nativeAdRequest.delegate = nil;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - GNNativeAdRequestDelegate

- (void)nativeAdRequestDidReceiveAds:(NSArray*)nativeAds
{
    secondsEnd = [NSDate timeIntervalSinceReferenceDate];
    NSLog(@"TableViewController: nativeAdRequestDidReceiveAds in %f seconds.", (double)(secondsEnd - secondsStart));
    for (GNNativeAd *nativeAd in nativeAds) {
        // You can identify the GNNativeAd by using the zoneID field of GNNativeAd.
        //if ([nativeAd.zoneID isEqualToString:@"YOUR_SSP_APP_ID"]) {
        //    [_cellDataList addObject:nativeAd];
        //}
        
//        GNNativeAd *ad=
        self.adItemView=[queueAds dequeue];
        
        
        [queueAds enqueue:nativeAd];
    
    }
}

- (void)nativeAdRequest:(GNNativeAdRequest *)request didFailToReceiveAdsWithError:(NSError *)error
{
    NSLog(@"TableViewController: didFailToReceiveAdsWithError : %@.", [error localizedDescription]);
}

- (BOOL)shouldStartExternalBrowserWithClick:(GNNativeAd *)nativeAd landingURL:(NSString *)landingURL
{
    NSLog(@"TableViewController: shouldStartExternalBrowserWithClick : %@.", landingURL);
    return YES;
}



@end

