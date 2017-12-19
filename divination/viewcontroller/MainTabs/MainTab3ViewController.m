//
//  MainTab3ViewController.m
//  loan_supermarket
//
//  Created by 杨世友 on 2017/12/1.
//  Copyright © 2017年 ysy15350. All rights reserved.
//
@import GoogleMobileAds;
#import "MainTab3ViewController.h"
#import "Config.h"
#import "InfoApi.h"
#import "Response.h"
#import "Clinic.h"
#import "DiagnosisViewController.h"
#import "UIColor+Hex.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

/// The game length.
static const NSInteger kGameLength = 5;

static NSInteger ClickIndex = 0;

@interface MainTab3ViewController ()<UIAlertViewDelegate>
{
    UIActivityIndicatorView *_indicator;
    UILabel *label;//标题
    UIImageView *topBannerImg;

    
    UILabel *title;
    UILabel *content;
    
    UIButton *btnOk;
    
    UIView *bottomView;
    
    NSMutableArray *checkedImgs;
    
}

@property(nonatomic,strong) InfoApi *infoApi;

@property(nonatomic,strong) NSArray *dataSource;

@property(nonatomic,strong) Clinic *selectedClinic;

@property(nonatomic,strong) UIImageView *selectedImg;

@property(nonatomic, strong) GADInterstitial *interstitial;


@end

@implementation MainTab3ViewController

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
    
    checkedImgs=[[NSMutableArray alloc] init];
    
    [self createTopView];
    [self createTopBannerImg];
    [self createTextView];
    //[self createGridView];
    [self createButton];
    [self createBottomView];
    [self loadAdsView];
    [self createAndLoadInterstitial];
    
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
    
    //    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    //    btn.frame = CGRectMake(10, 0, 40, 40);
    //    [btn addTarget:self action:@selector(c_back) forControlEvents:UIControlEventTouchUpInside];
    //    [topView addSubview:btn];
    
    label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"最新診断";
    label.frame = CGRectMake(kScreenWidth /2-80, 30, 160, 40);
    label.font = [UIFont systemFontOfSize:20.0];
    
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:label];
    
}

-(void)createTopBannerImg{
    topBannerImg= [[UIImageView alloc] init];
    topBannerImg.frame = CGRectMake(0,70, kScreenWidth, 60);
    topBannerImg.image=[UIImage imageNamed:@"banner1"];
    [self.view addSubview:topBannerImg];
}

-(void)createTextView{
    title = [[UILabel alloc]init];
    title.backgroundColor = [UIColor clearColor];
    title.text = @"-";
    title.frame = CGRectMake(0, 150, kScreenWidth, 40);
    //title.font = [UIFont systemFontOfSize:24.0];
    title.font=[UIFont fontWithName:@"Helvetica-Bold" size:24.0];
    
    title.textColor = [UIColor colorWithHexString:@"554b80"];
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
    
    
    content = [[UILabel alloc]init];
    content.backgroundColor = [UIColor clearColor];
    content.text = @"-";
    content.frame = CGRectMake(0, 170, kScreenWidth, 150);
    content.numberOfLines=4;
    content.textColor = [UIColor colorWithHexString:@"554b80"];
    
    
    
    //设置行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content.text];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:10];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content.text length])];
    
    content.attributedText = attributedString;
    
    
    //设置行间距end
    
    content.font = [UIFont systemFontOfSize:20.0];
    content.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:content];
}

-(void)createGridView{
    
    if(!self.dataSource){
        return;
    }
    
    UIView *gridView = [[UIView alloc] initWithFrame:CGRectMake(0, 320, kScreenWidth, 200)];
    //gridView.backgroundColor = [UIColor colorWithHexString:@"#312950"];
    [self.view addSubview:gridView];
    
    //      总列数
    int totalColumns = 4;
    
    //       每一格的尺寸
    CGFloat cellW = 67;
    CGFloat cellH = 67;
    
    //    间隙
    CGFloat margin =(self.view.frame.size.width - totalColumns * cellW) / (totalColumns + 1);
    
    long count=self.dataSource.count;
    
    //    根据格子个数创建对应的框框
    for(int index = 0; index< count; index++) {
        UIView *cellView = [[UIView alloc ]init ];
        cellView.backgroundColor = [UIColor colorWithHexString:@"42b993"];
        
        // 计算行号  和   列号
        int row = index / totalColumns;
        int col = index % totalColumns;
        //根据行号和列号来确定 子控件的坐标
        CGFloat cellX = margin + col * (cellW + margin);
        CGFloat cellY = row * (cellH + margin);
        cellView.frame = CGRectMake(cellX, cellY, cellW, cellH);
        
        //设置圆角
        cellView.layer.masksToBounds = YES;
        cellView.layer.cornerRadius = 5.0;
        
        UIImageView *imgItem= [[UIImageView alloc] init];
        imgItem.frame = CGRectMake(0,0, cellW, cellH);
        NSString *imgName=[NSString stringWithFormat:@"tab3_icon%d",index+1];
        
        //
//
        
       
        
        Clinic *clinic=[self.dataSource objectAtIndex:index];
        NSString *url= [Config getServiceUrl];
        if(clinic){
            
            NSString *images= clinic.images;
            
            NSString *imageUrl=[url stringByAppendingString:images];
            
            //imgItem.image=[UIImage imageNamed:imgName];
            
            [imgItem sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                     placeholderImage:[UIImage imageNamed:imgName]];
        }
        
       
        [cellView addSubview:imgItem];
        
        UIButton *btnItem=[[UIButton alloc] init];
        btnItem.frame = CGRectMake(0, 0, cellW, cellH);
        
        btnItem.tag = 400 + index;
        
        [btnItem addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [cellView addSubview:btnItem];
        
        UIImageView *imgCheckedItem= [[UIImageView alloc] init];
        imgCheckedItem.frame = CGRectMake(0,0, cellW/4, cellH/4);
        imgCheckedItem.center=CGPointMake(cellW-(cellW/8)-5, (cellW/8)+5);
        NSString *imgName1=@"icon_checked";
        imgCheckedItem.image=[UIImage imageNamed:imgName1];
        imgCheckedItem.hidden=YES;
        [cellView addSubview:imgCheckedItem];
        [checkedImgs addObject:imgCheckedItem];
        
        // 添加到view 中
        [gridView addSubview:cellView];
    }
    
}


-(void)createButton{
    
    btnOk = [[UIButton alloc]init];
    btnOk.frame = CGRectMake(24, kScreenHeight-150, kScreenWidth-48, 45);
    btnOk.titleLabel.font = [UIFont systemFontOfSize:20];
    btnOk.backgroundColor=[UIColor colorWithHexString:@"#d9709b"];
    [btnOk setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [btnOk setTitle:@"決定" forState:UIControlStateNormal];
    //设置圆角
    btnOk.layer.masksToBounds = YES;
    btnOk.layer.cornerRadius = 5.0;
    
    btnOk.tag = 500;
    
    [btnOk addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnOk];
}

//底部广告
-(void)loadAdsView{
    //kScreenWidth / 2 - 160, 100
    DFPBannerView *bannerView = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:CGPointMake(kScreenWidth / 2 - 160, 0)];
    
    bannerView.center=CGPointMake(kScreenWidth / 2, 25);
    
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

//全屏广告
- (void)createAndLoadInterstitial {
    self.interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:@"/9116787/1245771"];//
    //@"/9116787/1245771"
    //   /9116787/1245771
    //@"ca-app-pub-3940256099942544/4411468910"

    
    GADRequest *request = [GADRequest request];
    // Request test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made.
    request.testDevices = @[ kGADSimulatorID, @"2077ef9a63d2b398840261c8221a0c9a" ];
    [self.interstitial loadRequest:request];
}

- (void)createBottomView
{
    //底部tabBar height 49  间距 :15 bottom height:75
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-49-50, kScreenWidth, 50)];//(kScreenWidth/5)
    //bottomView.backgroundColor = [UIColor colorWithHexString:@"#312950"];
    
    //    NSString *imgName=[NSString stringWithFormat:@"tab1_img%d",4];
    //    bottomView.image=[UIImage imageNamed:imgName];
    
    [self.view addSubview:bottomView];
}


- (void)buttonClicked:(UIButton *)btn
{
    switch (btn.tag) {
        case 400:
        {
            NSLog(@"1");
            if(self.selectedImg){
                self.selectedImg.hidden=YES;
            }
            UIImageView *img1=[checkedImgs objectAtIndex:0];
            img1.hidden=NO;
            self.selectedImg=img1;
            
            self.selectedClinic=[self.dataSource objectAtIndex:0];
            break;
        }
        case 401:
        {
            NSLog(@"2");
            if(self.selectedImg){
                self.selectedImg.hidden=YES;
            }
            UIImageView *img2=[checkedImgs objectAtIndex:1];
            img2.hidden=NO;
            self.selectedImg=img2;
            self.selectedClinic=[self.dataSource objectAtIndex:1];
            break;
        }
        case 402:
        {
            NSLog(@"3");
            
            if(self.selectedImg){
                self.selectedImg.hidden=YES;
            }
            UIImageView *img3=[checkedImgs objectAtIndex:2];
            img3.hidden=NO;
            self.selectedImg=img3;
            
            self.selectedClinic=[self.dataSource objectAtIndex:2];
            break;
        }
        case 403:
        {
            NSLog(@"4");
            
            if(self.selectedImg){
                self.selectedImg.hidden=YES;
            }
            UIImageView *img4=[checkedImgs objectAtIndex:3];
            img4.hidden=NO;
            self.selectedImg=img4;
            
            self.selectedClinic=[self.dataSource objectAtIndex:3];
            break;
        }
        case 404:
        {
            NSLog(@"5");
            
            if(self.selectedImg){
                self.selectedImg.hidden=YES;
            }
            UIImageView *img5=[checkedImgs objectAtIndex:4];
            img5.hidden=NO;
            self.selectedImg=img5;
            
            self.selectedClinic=[self.dataSource objectAtIndex:4];
            break;
        }
        case 405:
        {
            NSLog(@"6");
        
            if(self.selectedImg){
                self.selectedImg.hidden=YES;
            }
            UIImageView *img6=[checkedImgs objectAtIndex:5];
            img6.hidden=NO;
            self.selectedImg=img6;
        
            self.selectedClinic=[self.dataSource objectAtIndex:5];
            break;
        }
        case 406:
        {
            NSLog(@"7");
            
            if(self.selectedImg){
                self.selectedImg.hidden=YES;
            }
            UIImageView *img7=[checkedImgs objectAtIndex:6];
            img7.hidden=NO;
            self.selectedImg=img7;
            
            self.selectedClinic=[self.dataSource objectAtIndex:6];
            break;
        }
        case 407:
        {
            NSLog(@"8");
            
            if(self.selectedImg){
                self.selectedImg.hidden=YES;
            }
            UIImageView *img8=[checkedImgs objectAtIndex:7];
            img8.hidden=NO;
            self.selectedImg=img8;
            
            self.selectedClinic=[self.dataSource objectAtIndex:7];
            break;
        }
        case 500:
        {
            NSLog(@"ok");
            if(self.selectedClinic){
                NSLog(@"选中：%@",self.selectedClinic.images);
            }
            
            NSLog(@"%ld",ClickIndex);
           
            if(ClickIndex>=3){
                [self openAdsScreen];
                ClickIndex=0;
            }
            else{
                [self GotoDiagnosisViewController];
                ClickIndex++;
            }
            
            
            break;
        }
    }
}

-(void)openAdsScreen{

    [self.interstitial presentFromRootViewController:self];
    [self createAndLoadInterstitial];
    
//    [[[UIAlertView alloc]
//      initWithTitle:@"Game Over"
//      message:[NSString stringWithFormat:@"You lasted %ld seconds", (long)kGameLength]
//      delegate:self
//      cancelButtonTitle:@"Ok"
//      otherButtonTitles:nil] show];
}

-(void)loadData{
    [_indicator startAnimating];
    //[SVProgressHUD showWithStatus:@"正在加载..."];

    [self.infoApi clinicComplete:^(id result, NSError *error) {
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
            
            NSLog(@"MainTab3ViewController Result: %@", result);
            Response *response=[Response objectWithKeyValues:result];
            if(response){
                NSInteger code=response.code;
                NSString *msg=response.message;
                
                NSLog(@"%@",msg);
                
                if(code==200){
                    [self bindInfo:response.info];
                    NSArray *array=[Clinic objectArrayWithKeyValuesArray:response.result];
                    self.dataSource=[array copy];
                    [self createGridView];
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

-(void)bindInfo:(NSDictionary *)info{
    if(info){
        //label.text=[info objectForKey:@"title"];
        
        title.text=[info objectForKey:@"description"];
        content.text=[info objectForKey:@"description2"];
        
    }
}

-(void)GotoDiagnosisViewController
{
    DiagnosisViewController *diagnosisView= [[DiagnosisViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
    
    if(self.dataSource&&!self.selectedClinic){//默认选中第一个
        self.selectedClinic=[self.dataSource objectAtIndex:0];
    }
    
    diagnosisView.selectedClinic=self.selectedClinic;
    
    [diagnosisView setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];//翻转效果
    
    //[diagnosisView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController pushViewController: diagnosisView animated:true];//这种方式一般是使用者浏览资料，继而可以前进到下一个页面或回到上一个页面。默认动画是从右至左。
    
    //[self presentViewController:diagnosisView animated:YES completion:nil];//这种方式一般出现在需要使用者完成某件事情，如输入密码、增加资料等操作后，才能(回到跳转前的控制器)继续。例如系统的WIFI连接输入密码提示。默认动画是从下至上。
    
}

#pragma mark UIAlertViewDelegate implementation

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
    } else {
        NSLog(@"Ad wasn't ready");
    }
    //self.playAgainButton.hidden = NO;
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

