//
//  OtherViewController.m
//  divination
//
//  Created by 杨世友 on 2017/12/20.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import "OtherViewController.h"
#import "OtherTableViewCell.h"
#import "WebViewViewController.h"
#import "UIColor+Hex.h"
#import "Divination.h"
#import "Config.h"
#import "ProtocolAlertView.h"

@interface OtherViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *label;//标题
    
    UITableView *listTable;
}

@end

@implementation OtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用名称
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"当前应用名称：%@",appCurName);
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    // 当前应用版本号码   int类型
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
    
    Divination *data1=[[Divination alloc] init];
    data1.title=@"利用規約";
    data1.descriptions=@"";
    
    Divination *data2=[[Divination alloc] init];
    data2.title=@"バージョン";
    data2.descriptions=[NSString stringWithFormat:@"%@(%@)",appCurVersion,appCurVersionNum];
    
    self.dataSource = [NSMutableArray arrayWithObjects:data1,data2, nil];

    
    [self createTopView];
    [self createListTable];
    
}

- (void)createTopView
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#e0e0d8"];
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
    label.text = @"メニュー";
    label.frame = CGRectMake(kScreenWidth /2-80, 30, 160, 40);
    label.font = [UIFont systemFontOfSize:20.0];
    
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:label];
    
}

- (void)createListTable
{
    if (!listTable) {
        listTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        listTable.showsVerticalScrollIndicator = NO;
        listTable.delegate = self;
        listTable.dataSource = self;
        //[self setExtraCellLineHidden:listTable];
        
        listTable.separatorStyle = NO;//隐藏
        
        //listTable.separatorStyle = YES；显示
        
        
        listTable.frame = CGRectMake(0, 70, kScreenWidth, kScreenHeight-70);
        
        [self.view addSubview:listTable];
    
        
    }
}


#pragma tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSource.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list"];
    
    if (!cell) {
        cell = [[OtherTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"list"];
    }

    cell.itemData=[self dataSource][indexPath.row];
    cell.index = indexPath.row;
    //cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row==0){
        
        NSString *serviceUrl=[Config getServiceUrl];
        serviceUrl=[serviceUrl stringByAppendingString:@"/App/Article/userauth"];
        
        [self GotoWebViewController:serviceUrl withTitle:@"利用規約"];
        
        //[self showProtocolAlertView];
        
        //[self showAlert];
    }
    
    NSLog(@"sdfsdf%ld",indexPath.row);
}


- (void)c_back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)GotoWebViewController:(NSString *)url withTitle:(NSString *)title
{
    WebViewViewController *webView= [[WebViewViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
    
    webView.title=title;
    webView.webUrl=url;//@"http://www.ysy15350.com";
    
    [webView setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];//翻转效果
    
    //[diagnosisView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self.navigationController pushViewController: webView animated:true];//这种方式一般是使用者浏览资料，继而可以前进到下一个页面或回到上一个页面。默认动画是从右至左。
    
    //[self presentViewController:diagnosisView animated:YES completion:nil];//这种方式一般出现在需要使用者完成某件事情，如输入密码、增加资料等操作后，才能(回到跳转前的控制器)继续。例如系统的WIFI连接输入密码提示。默认动画是从下至上。
    
}

- (void)showAlert{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"标题" message:@"内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)showProtocolAlertView{
    ProtocolAlertView *xlAlertView = [[ProtocolAlertView alloc] initWithTitle:@"自定义UIAlertView" message:@"不喜勿喷，大神多多指导。不胜感激" sureBtn:@"确认" cancleBtn:@"取消"];
    xlAlertView.resultIndex = ^(NSInteger index){
        //回调---处理一系列动作
    };
    [xlAlertView showXLAlertView];
    
   
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
