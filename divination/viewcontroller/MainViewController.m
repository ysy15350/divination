//
//  MainViewController.m
//  loan_supermarket
//
//  Created by 杨世友 on 2017/12/1.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import "MainViewController.h"
#import "UIColor+Hex.h"

#import "MainTab1ViewController.h"
#import "MainTab2ViewController.h"
#import "MainTab3ViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [self initView];
}

-(void)initView{
    //隐藏导航栏
    [super.navigationController setNavigationBarHidden:YES animated:TRUE];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    
 
    //创建子控制器:Tab1
    MainTab1ViewController  *tab1=[[MainTab1ViewController alloc]init];
    //tab1.view.backgroundColor=[UIColor grayColor];
    tab1.view.backgroundColor=[UIColor colorWithHexString:@"#FFFFFF"];
    tab1.tabBarItem.title=@"トップ";
    tab1.tabBarItem.image=[UIImage imageNamed:@"icon_tab1"];
    tab1.tabBarItem.selectedImage=[UIImage imageNamed:@"icon_tab1_1"];
    //tab1.tabBarItem.badgeValue=@"123";
    
    
    //创建子控制器:Tab2
    MainTab2ViewController  *tab2=[[MainTab2ViewController alloc]init];
    //tab2.view.backgroundColor=[UIColor grayColor];
    tab2.view.backgroundColor=[UIColor colorWithHexString:@"#FFFFFF"];
    tab2.tabBarItem.title=@"口コミ";
    tab2.tabBarItem.image=[UIImage imageNamed:@"icon_tab2"];
    tab2.tabBarItem.selectedImage=[UIImage imageNamed:@"icon_tab2_1"];
    //tab2.tabBarItem.badgeValue=@"123";
    
    
    //创建子控制器:Tab3
    MainTab3ViewController  *tab3=[[MainTab3ViewController alloc]init];
    //tab3.view.backgroundColor=[UIColor grayColor];
    tab3.view.backgroundColor=[UIColor colorWithHexString:@"#e1dfed"];
    tab3.tabBarItem.title=@"診断";
    tab3.tabBarItem.image=[UIImage imageNamed:@"icon_tab3"];
    tab3.tabBarItem.selectedImage=[UIImage imageNamed:@"icon_tab3_1"];
    //tab3.tabBarItem.badgeValue=@"123";
    
    
    
    //方式一
    //[self addChildViewController:tab1];
    //[self addChildViewController:tab2];
    //[self addChildViewController:tab3];
    
    //方式二
    self.viewControllers=@[tab1,tab2,tab3];
    
    NSLog(@"MainViewController:%@",@"initView");
}

-(void)viewDidAppear:(BOOL)animated{
    
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

