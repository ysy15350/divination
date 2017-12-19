//
//  MainTab3ViewController.m
//  loan_supermarket
//
//  Created by 杨世友 on 2017/12/1.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import "DiagnosisViewController.h"
#import "DiagnosisDetailViewController.h"
#import "Config.h"
#import "UIColor+Hex.h"
#import "UIImageView+WebCache.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface DiagnosisViewController ()
{
    UILabel *label;//标题
    UIImageView *topBannerImg;
    
    UILabel *title;
    UILabel *content;
    
    UIButton *btnBack;
    UIButton *btnOk;
    
}

@end

@implementation DiagnosisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTopView];
    [self createTopBannerImg];
    [self createTextView];
    [self createGridView];
    [self createButton];
    
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
    label.text = @"診断";
    label.frame = CGRectMake(kScreenWidth /2-80, 30, 160, 40);
    label.font = [UIFont systemFontOfSize:20.0];
    
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:label];
    
}

-(void)createTopBannerImg{
    topBannerImg= [[UIImageView alloc] init];
    topBannerImg.frame = CGRectMake(0,70, kScreenWidth, 60);
    topBannerImg.image=[UIImage imageNamed:@"banner2"];
    [self.view addSubview:topBannerImg];
}

-(void)createTextView{
    title = [[UILabel alloc]init];
    title.backgroundColor = [UIColor clearColor];
    title.text = @"こちらでよろしいですか？";//self.selectedClinic.title;
    title.frame = CGRectMake(0, 200, kScreenWidth, 40);
    //title.font = [UIFont systemFontOfSize:24.0];
    title.font=[UIFont fontWithName:@"Helvetica-Bold" size:24.0];
    
    title.textColor = [UIColor colorWithHexString:@"554b80"];
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
    
    
}


-(void)createGridView{
    UIView *cellView = [[UIView alloc ]init ];
    cellView.backgroundColor = [UIColor colorWithHexString:@"42b993"];
    
    

    CGFloat cellW = 67;
    CGFloat cellH = 67;
 
    cellView.frame = CGRectMake(kScreenWidth/2-cellW/2, 300, cellW, cellH);
    
    //设置圆角
    cellView.layer.masksToBounds = YES;
    cellView.layer.cornerRadius = 5.0;
    
 
    
    UIImageView *imgItem= [[UIImageView alloc] init];
    imgItem.frame = CGRectMake(0,0, cellW, cellH);
    //imgItem.image=[UIImage imageNamed:@"tab3_icon1"];
    
    NSString *imgName=[NSString stringWithFormat:@"tab3_icon%d",1];
    
    NSString *url= [Config getServiceUrl];
    if(self.selectedClinic){
        

        NSString *images= self.selectedClinic.images;
        
        NSString *imageUrl=[url stringByAppendingString:images];
        
        //imgItem.image=[UIImage imageNamed:imgName];
        
        [imgItem sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                   placeholderImage:[UIImage imageNamed:imgName]];
    }
    
    [cellView addSubview:imgItem];
    
    UIButton *btnItem=[[UIButton alloc] init];
    btnItem.frame = CGRectMake(0, 0, cellW, cellH);
    
    btnItem.tag = 400 ;
    
    [btnItem addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:cellView];
}


-(void)createButton{
    
    CGFloat btnWidth=(kScreenWidth-(24*3))/2;
    
    btnBack = [[UIButton alloc]init];
    btnBack.frame = CGRectMake(24, kScreenHeight-150,btnWidth , 45);
    btnBack.titleLabel.font = [UIFont systemFontOfSize:20];
    btnBack.backgroundColor=[UIColor colorWithHexString:@"#d9709b"];
    [btnBack setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [btnBack setTitle:@"選び直す" forState:UIControlStateNormal];
    //设置圆角
    btnBack.layer.masksToBounds = YES;
    btnBack.layer.cornerRadius = 5.0;
    
    btnBack.tag = 500;
    
    [btnBack addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnBack];
    
    btnOk = [[UIButton alloc]init];
    btnOk.frame = CGRectMake(btnWidth+48, kScreenHeight-150, (kScreenWidth-(24*3))/2, 45);
    btnOk.titleLabel.font = [UIFont systemFontOfSize:20];
    btnOk.backgroundColor=[UIColor colorWithHexString:@"#d9709b"];
    [btnOk setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [btnOk setTitle:@"決定!" forState:UIControlStateNormal];
    //设置圆角
    btnOk.layer.masksToBounds = YES;
    btnOk.layer.cornerRadius = 5.0;
    
    btnOk.tag = 501;
    
    [btnOk addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnOk];
}

- (void)buttonClicked:(UIButton *)btn
{
    switch (btn.tag) {
        case 400:
        {
            NSLog(@"1");
            break;
        }
        case 401:
        {
            NSLog(@"2");
            break;
        }
        case 402:
        {
            NSLog(@"3");
            break;
        }
        case 403:
        {
            NSLog(@"4");
            break;
        }
        case 404:
        {
            NSLog(@"5");
            break;
        }
        case 405:
        {
            NSLog(@"6");
            break;
        }
        case 406:
        {
            NSLog(@"7");
            break;
        }
        case 407:
        {
            NSLog(@"8");
            break;
        }
        case 500:
        {
            NSLog(@"back");
            
            [self.navigationController popViewControllerAnimated:YES];
            
            break;
        }
        case 501:
        {
            NSLog(@"ok");
            
            [self GotoDiagnosisDetailViewController];
            
            break;
        }
    }
}

-(void)GotoDiagnosisDetailViewController
{
    DiagnosisDetailViewController *diagnosisDetailView= [[DiagnosisDetailViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
    
    diagnosisDetailView.selectedClinic=self.selectedClinic;
    
    [diagnosisDetailView setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];//翻转效果
    
    //[diagnosisView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController pushViewController: diagnosisDetailView animated:true];//这种方式一般是使用者浏览资料，继而可以前进到下一个页面或回到上一个页面。默认动画是从右至左。
    
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

