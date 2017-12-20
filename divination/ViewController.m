//
//  ViewController.m
//  divination
//
//  Created by 杨世友 on 2017/12/13.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

@import GoogleMobileAds;

#import "ViewController.h"
#import "UIColor+Hex.h"
#import "MainViewController.h"
#import "PublicApi.h"
#import "Response.h"
#import "SVProgressHUD.h"
#import "MyAlert.h"

#import "IQKeyboardManager.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


#import "PhoneDivinationViewController.h"

@interface ViewController (){
    UIActivityIndicatorView *_indicator;
    MyAlert *myAlertView;//alertView
}
@property(nonatomic,strong) PublicApi *publicApi;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //包名
    //com.ysy15350.divination
    //开发账号：    981622394@qq.com      Cnwtoo159357
    //-------------------------------------
    //发布账号：1929581812@qq.com  Asd159357
    //com.zubari.uranai
    //发布新增权限：通讯录、日历，info
    
    //    Privacy - Contacts Usage Description
    //
    //    訪問者訪問の許可を受けたかどうか
    //
    //    Privacy - Calendars Usage Description
    //
    //    カレンダーを訪問する
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initView];
    
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    
    _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //设置显示位置
    _indicator.center = CGPointMake(kScreenWidth/2,kScreenHeight/2);
    //将这个控件加到父容器中。
    [self.view addSubview:_indicator];
    
    //    [self loadAdsView];
    
    UIImageView *topBannerImg= [[UIImageView alloc] init];
    topBannerImg.frame = CGRectMake(0,0, kScreenWidth, kScreenHeight);
    topBannerImg.image=[UIImage imageNamed:@"icon_start"];
    [self.view addSubview:topBannerImg];
    
//   UIButton *_btnDelete=[[UIButton alloc] init];
//    _btnDelete.frame = CGRectMake(0, 10, 100, 25);
//    UIImage *image = [UIImage imageNamed:@"tab1_img1"];
//    [_btnDelete setBackgroundImage:image forState:UIControlStateNormal];
//
//    [self.view addSubview:_btnDelete];
    
    
    [self send_token];
    
    //MyAlert
    //    + (MyAlertCenter *) defaultCenter;//单例 生成alert控制器
    //    - (void) postAlertWithMessage:(NSString*)message;//弹出文字
    
    
    //                alert = [[UIAlertView alloc]
    //                         initWithTitle:@"提示信息" message:[components objectAtIndex:2]
    //                         delegate:self cancelButtonTitle:nil
    //                         otherButtonTitles:nil, nil];
    //                [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
    //                [alert show];
    
}

-(void)loadAdsView{
    DFPBannerView *bannerView = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:CGPointMake(kScreenWidth / 2 - 160, 0)];
    bannerView.validAdSizes = @[NSValueFromGADAdSize(kGADAdSizeBanner)];
    
    // 実際に配信に使用するAd Unit IDは、営業担当者から別途お知らせ致します。  实际上使用的ad unit id将由营业负责人另行通知
    // こちらはテスト用のIDになります。     这是一个测试用的id
    bannerView.backgroundColor=[UIColor colorWithHexString:@"#fff2df"];
    bannerView.adUnitID = @"/6499/example/banner";//@"/9116787/1241401";
    bannerView.rootViewController = self;
    // デリゲートは必要に応じて実装してください  请根据需要来实现委派
    // See also: https://developers.google.com/mobile-ads-sdk/docs/dfp/ios/ad-events
    //bannerView.delegate = self;
    
    DFPRequest *request = DFPRequest.new;
    
    [bannerView loadRequest:request];
    [self.view addSubview:bannerView];
    //self.backgroundColor = newColor(228, 225, 215, 1);
    //self.bannerView_1=bannerView;
    //self.bannerView = bannerView;
}

-(void)initView{
    //隐藏导航栏
    [super.navigationController setNavigationBarHidden:YES animated:TRUE];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    myAlertView=[[MyAlert alloc] init];
    
    
    
    NSLog(@"ViewController:%@",@"initView");
}

-(void)viewDidAppear:(BOOL)animated{
    //[self GotoMainViewController];
    //[self GotoPhoneViewController];
}

-(void)GotoMainViewController
{
    MainViewController *mainView= [[MainViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
    
    //[mainView setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];//翻转效果
    
    [mainView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController pushViewController: mainView animated:true];//这种方式一般是使用者浏览资料，继而可以前进到下一个页面或回到上一个页面。默认动画是从右至左。
    
    //[self presentViewController:mainView animated:YES completion:nil];//这种方式一般出现在需要使用者完成某件事情，如输入密码、增加资料等操作后，才能(回到跳转前的控制器)继续。例如系统的WIFI连接输入密码提示。默认动画是从下至上。
    
}

-(void)GotoPhoneViewController
{
    PhoneDivinationViewController *mainView= [[PhoneDivinationViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
    
    //[mainView setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];//翻转效果
    
    [mainView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController pushViewController: mainView animated:true];//这种方式一般是使用者浏览资料，继而可以前进到下一个页面或回到上一个页面。默认动画是从右至左。
    
    //[self presentViewController:mainView animated:YES completion:nil];//这种方式一般出现在需要使用者完成某件事情，如输入密码、增加资料等操作后，才能(回到跳转前的控制器)继续。例如系统的WIFI连接输入密码提示。默认动画是从下至上。
    
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
            [self GotoMainViewController];
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
                    //[self GotoMainViewController];
                }
                else{
                    //NSLog(@"%@",msg);
                }
                
                [self GotoMainViewController];
            }
            
            [_indicator stopAnimating];
            //[SVProgressHUD dismiss];
            
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

