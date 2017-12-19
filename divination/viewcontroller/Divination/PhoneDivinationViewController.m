//
//  PhoneDivinationViewController.m
//  divination
//
//  Created by 杨世友 on 2017/12/14.
//  Copyright © 2017年 ysy15350. All rights reserved.
//
@import GoogleMobileAds;
#import "PhoneDivinationViewController.h"
#import "UIColor+Hex.h"
#import "Config.h"
#import "InfoApi.h"
#import "Response.h"
#import "Divination.h"
#import <JavaScriptCore/JavaScriptCore.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface PhoneDivinationViewController ()<UIWebViewDelegate>{
    UIActivityIndicatorView *_indicator;
    UILabel *label;//标题
    
    UIView *bottomView;
}

@property(nonatomic,strong) InfoApi *infoApi;

@end

@implementation PhoneDivinationViewController
@synthesize webView   = _webView;

@synthesize webUrl   = _webUrl;

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
  
    [self createTopView];
    
    self.webView =[[UIWebView alloc] initWithFrame:CGRectMake(0, 75, kScreenWidth, kScreenHeight-75)];
    
    self.webView.backgroundColor = [UIColor whiteColor];
    
    [self.webView setDelegate:self];
    
    [self.view addSubview:self.webView];
    
    
    
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    JSContext *context=[self.webView  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    
    context[@"basicInterface"]=self;
    
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
    label.text = @"電話占い";//仕事・人間関係
    label.frame = CGRectMake(kScreenWidth /2-80, 30, 160, 40);
    label.font = [UIFont systemFontOfSize:20.0];
    
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:label];
    
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
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-(kScreenWidth/5), kScreenWidth, (kScreenWidth/5))];
    //bottomView.backgroundColor = [UIColor colorWithHexString:@"#312950"];
    
    //    NSString *imgName=[NSString stringWithFormat:@"tab1_img%d",4];
    //    bottomView.image=[UIImage imageNamed:imgName];
    
    [self.view addSubview:bottomView];
}


-(void)loadWebRequest:(NSString *)url{
    
    NSLog(@"%@",url);
    
    [_indicator startAnimating];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //http://180.169.15.101/MHRoadMobile
    
    //http://115.28.192.194:9091/
    
    if(self.webUrl)
    {
        request=[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]];
    }
    
    
    //NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.106:8080/html/creditor_detail.html"]];
    
    //NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.106:82"]];
    
    [self.webView loadRequest:request];
}

-(void)viewDidUnload
{
    //[self setMainwebView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_indicator stopAnimating];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_indicator stopAnimating];
}

-(void)TestMethod
{
    //Code:1:成功，2：失败。失败时MSG必须传值。
    [self.webView stringByEvaluatingJavaScriptFromString:@"CallbackEvent(1,'')"];
}

-(void)back{
    [self c_back];
}

- (void)c_back
{
    [self.navigationController popViewControllerAnimated:YES];
}



//获取数据
- (void)loadData
{
    [_indicator startAnimating];
    //[SVProgressHUD showWithStatus:@"正在加载..."];
    
    
    [self.infoApi tel_detail:self.detail_id complete:^(id result, NSError *error) {
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
            
            NSLog(@"PhoneDivinationViewController Result: %@", result);
            Response *response=[Response objectWithKeyValues:result];
            if(response){
                NSInteger code=response.code;
                NSString *msg=response.message;
                
                NSLog(@"%@",msg);
                
                if(code==200){
                    
                    Divination *divination=[Divination objectWithKeyValues: response.result];
                    
                    if(divination&&divination.tz_url){
                        NSString *url= [Config getServiceUrl];
                        NSString *tz_url=divination.tz_url;
                        NSString *webUrl=[url stringByAppendingString:tz_url];
                        [self loadWebRequest:webUrl];
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
