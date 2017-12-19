//
//  PhoneDivinationViewController.m
//  divination
//
//  Created by 杨世友 on 2017/12/14.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import "PhoneDivinationViewController_web.h"
#import "UIColor+Hex.h"
#import "Config.h"
#import "InfoApi.h"
#import "Response.h"
#import "Divination.h"
#import <JavaScriptCore/JavaScriptCore.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface PhoneDivinationViewController_web ()<UIWebViewDelegate>{
    UIActivityIndicatorView *_indicator;
    UILabel *label;//标题
}

@property(nonatomic,strong) InfoApi *infoApi;

@end

@implementation PhoneDivinationViewController_web

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
    
   
    
    self.webView =[[UIWebView alloc] initWithFrame:CGRectMake(0, 75, kScreenWidth, [UIScreen mainScreen].bounds.size.height)];
    
    self.webView.backgroundColor = [UIColor whiteColor];
    
    [self.webView setDelegate:self];
    
    [self.view addSubview:self.webView];
    
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    JSContext *context=[self.webView  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    
    context[@"basicInterface"]=self;
    

    _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //设置显示位置
    _indicator.center = CGPointMake(kScreenWidth/2,kScreenHeight/2);
    //将这个控件加到父容器中。
    //[self.view addSubview:_indicator];
   
 
    
    
    [self loadData];
    
}

-(void)loadWebRequest:(NSString *)url{
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
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

-(void)viewDidUnload
{
    //[self setMainwebView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

//获得从网站得到的值
#pragma mark --
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //获得请求的URL,第一次是路径，当在web上点击按钮后获得的是web穿过来的路径。
    NSString *requestStr = [[request URL] absoluteString];
    
    requestStr = [requestStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"url:%@",requestStr);
    
    //    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    //    JSContext *context=[self.mainwebView  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //
    //
    //    context[@"basicInterface"]=self;
    
    NSRange range = [requestStr rangeOfString:@"ChoosePhoto"];//判断字符串是否包含
    
    NSRange range1 = [requestStr rangeOfString:@"Back"];
    
    //if (range.location ==NSNotFound)//不包含
    if (range.length >0)//包含
    {
        NSArray *components = [requestStr componentsSeparatedByString:@"="];
        if ([components count] > 1) {
            
            
            NSString *paramStr=(NSString *)[components objectAtIndex:1];
            
            NSLog(@"%@",paramStr);
            
        }
        return NO;
        
    }
    else if(range1.length>0)
    {
        [self c_back];
        return NO;
    }
    
    //浏览附件
    if(navigationType==UIWebViewNavigationTypeLinkClicked){
        NSURL *url=[request URL];
        
        return NO;
    }
    //处理页面Javascript
    NSString *requestString1 = [[request URL] absoluteString];
    NSString *requestString=[requestString1 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSArray *components = [requestString componentsSeparatedByString:@"^"];
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] rangeOfString:@"testapp"].length > 0 /*&& [(NSString *)[components objectAtIndex:0] isEqualToString:@"testapp"]*/) {
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"alert"])
        {
            //Javascript alert 提示
            //            alert = [[UIAlertView alloc]
            //                     initWithTitle:@"提示信息" message:[components objectAtIndex:2]
            //                     delegate:self cancelButtonTitle:nil
            //                     otherButtonTitles:nil, nil];
            //            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
            //            [alert show];
        }
        else if([(NSString *)[components objectAtIndex:1] isEqualToString:@"browseurl"])
        {
            NSString *url=(NSString *)[components objectAtIndex:2];
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
        else if([(NSString *)[components objectAtIndex:1] isEqualToString:@"clickclose"])
        {
            exit(0);
            //NSString *jsStr=@"WeiBoCallBack('ios调用javascript')";
            //[webView stringByEvaluatingJavaScriptFromString:jsStr];
        }
        return NO;
    }
    else if([components count] == 1)
        return YES;
    else
        return NO;
    
    
    return YES;
}


//-(void) performDismiss:(NSTimer *)timer
//{
//    [alert dismissWithClickedButtonIndex:0 animated:NO];
//    //[alert release];
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated

{
    [super viewDidAppear:animated];
    
    //方式一
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    //方式二
    
    //    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
    //
    //        [self prefersStatusBarHidden];
    //
    //        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    //
    //    }
    
    
    
}

- (BOOL)prefersStatusBarHidden
{
    
    return YES;
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
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
