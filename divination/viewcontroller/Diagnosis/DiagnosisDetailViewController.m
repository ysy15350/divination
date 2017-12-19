//
//  MainTab3ViewController.m
//  loan_supermarket
//
//  Created by 杨世友 on 2017/12/1.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import "DiagnosisDetailViewController.h"
#import "UIColor+Hex.h"
#import "Config.h"
#import "InfoApi.h"
#import "Response.h"
#import "Clinic.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface DiagnosisDetailViewController ()
{
    UIActivityIndicatorView *_indicator;
    UILabel *label;//标题
    UIImageView *topBannerImg;
    
    UIScrollView *scrollView;
    
    UILabel *title;
    UIImageView *imgItem;
    UILabel *content;
    
    UIButton *btnBack;
    UIButton *btnOk;
    
}

@property(nonatomic,strong) InfoApi *infoApi;

@end

@implementation DiagnosisDetailViewController

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
    [self createTopBannerImg];
    
    scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 130, kScreenWidth, kScreenHeight-130); // frame中的size指UIScrollView的可视范围
    scrollView.backgroundColor = [UIColor colorWithHexString:@"e1deed"];
    [self.view addSubview:scrollView];
    
    [self createTextView];
    [self createGridView];
    
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
    title.text = @"-";
    title.frame = CGRectMake(15, 20, kScreenWidth-30, 40);
    title.numberOfLines=20;
    title.textColor = [UIColor colorWithHexString:@"554b80"];
    
    
    
    //设置行间距end
    
    title.font = [UIFont systemFontOfSize:20.0];
    title.textAlignment = NSTextAlignmentLeft;
    
    [scrollView addSubview:title];
    
    
    content = [[UILabel alloc]init];
    content.backgroundColor = [UIColor clearColor];
    content.text = @"-";
    content.frame = CGRectMake(15, 210, kScreenWidth-30, 30000);
    content.numberOfLines=1000;
    content.textColor = [UIColor colorWithHexString:@"544a7f"];
    
    
    //设置行间距end
    
    content.font = [UIFont systemFontOfSize:14.0];
    content.textAlignment = NSTextAlignmentLeft;
    
    [scrollView addSubview:content];
    
    
    
}


-(void)createGridView{
    UIView *cellView = [[UIView alloc ]init ];
    cellView.backgroundColor = [UIColor colorWithHexString:@"42b993"];
    
    

    CGFloat cellW = 67;
    CGFloat cellH = 67;
 
    cellView.frame = CGRectMake(kScreenWidth/2-cellW/2, 110, cellW, cellH);
    
    //设置圆角
    cellView.layer.masksToBounds = YES;
    cellView.layer.cornerRadius = 5.0;
    
 
    
    imgItem= [[UIImageView alloc] init];
    imgItem.frame = CGRectMake(0,0, cellW, cellH);
    imgItem.image=[UIImage imageNamed:@"tab3_icon1"];
    [cellView addSubview:imgItem];
    
    UIButton *btnItem=[[UIButton alloc] init];
    btnItem.frame = CGRectMake(0, 0, cellW, cellH);
    
    btnItem.tag = 400 ;
    
    [btnItem addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [scrollView addSubview:cellView];
}


-(void)loadData{
    [_indicator startAnimating];
    //[SVProgressHUD showWithStatus:@"正在加载..."];
    
    [self.infoApi clinic_detail:self.selectedClinic.id complete:^(id result, NSError *error) {
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
            
            NSLog(@"DiagnosisDetailViewController Result: %@", result);
            Response *response=[Response objectWithKeyValues:result];
            if(response){
                NSInteger code=response.code;
                NSString *msg=response.message;
                
                NSLog(@"%@",msg);
                
                if(code==200){
                    Clinic *clinic=[Clinic objectWithKeyValues:response.result];
                    [self bindData:clinic];
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

-(void)bindData:(Clinic *)clinic{
    if(clinic){
        
        title.text=[clinic.title stringByAppendingString:@""];
        title.font = [UIFont systemFontOfSize:20];
        
        title.numberOfLines = 10;
        
        CGSize size1 = CGSizeMake(kScreenWidth-30, 100);
        CGSize labelTitleSize = [title.text sizeWithFont:title.font constrainedToSize:size1 lineBreakMode:NSLineBreakByClipping];
        
        title.frame = CGRectMake(title.frame.origin.x, title.frame.origin.y, labelTitleSize.width, labelTitleSize.height);
        
        content.text=[clinic.content stringByAppendingString:@""];
        
        
        content.frame = CGRectMake(15, 210, kScreenWidth-(30), 30);
        content.font = [UIFont systemFontOfSize:16];
        //[UIFont fontWithName:@"Arial" size:12];
        //_labelTitle.backgroundColor = [UIColor blueColor];
        //content.textColor = [UIColor colorWithHexString:@"#3e3d42"];
        //content.text=@"これは誰ががとても評論しているのですこれは誰ががとても評論しているのですこれは誰ががとても評論しているのです";
        
        //设置label的最大行数
        content.numberOfLines = 1000;
        CGSize size = CGSizeMake(kScreenWidth-30, 100000);
        CGSize labelSize = [content.text sizeWithFont:content.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
        content.frame = CGRectMake(content.frame.origin.x, content.frame.origin.y, labelSize.width, labelSize.height);
        
        NSLog(@"sdfsdfdsf%f",labelSize.height);
        
        
        content.textAlignment = NSTextAlignmentLeft;
        
        //content.backgroundColor = [UIColor yellowColor];
        
        
        CGFloat y1=CGRectGetMaxY(content.frame);
        
        //scrollView.contentInset = UIEdgeInsetsMake(0, 0, 20, 20);
        
        // 用来记录scrollview滚动的位置
        //    scrollView.contentOffset = ;
    
       // 去掉弹簧效果
        //    scrollView.bounces = NO;
    
        // 增加额外的滚动区域（逆时针，上、左、下、右）
        // top  left  bottom  right
        //scrollView.contentInset = UIEdgeInsetsMake(20, 20, 20, 20);
        
        //三个步骤
        CGPoint offset = scrollView.contentOffset;
        offset.y = y1+20;
        //scrollView.contentOffset = offset;
        // 设置UIScrollView的滚动范围（内容大小）
        scrollView.contentSize = CGSizeMake(kScreenWidth, y1+20);
        
        NSString *imgName=[NSString stringWithFormat:@"tab3_icon%d",1];
        
        NSString *url= [Config getServiceUrl];
        
        NSString *images= clinic.images;
        
        NSString *imageUrl=[url stringByAppendingString:images];
        
        //imgItem.image=[UIImage imageNamed:imgName];
        
        [imgItem sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                   placeholderImage:[UIImage imageNamed:imgName]];
        
        
    }
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
            
            
            
            break;
        }
    }
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

