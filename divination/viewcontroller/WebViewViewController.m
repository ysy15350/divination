//
//  WebViewViewController.m
//  MHRoadMobile
//
//  Created by 杨世友 on 16/10/31.
//
//

#import "WebViewViewController.h"
#import "AFNetworking.h"
#import "UIColor+Hex.h"
#import <JavaScriptCore/JavaScriptCore.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface WebViewViewController ()<UIWebViewDelegate>{
    UIActivityIndicatorView *_indicator;
    UILabel *label;//标题
}

@end

@implementation WebViewViewController

@synthesize webView   = _webView;

@synthesize webUrl   = _webUrl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.webView =[[UIWebView alloc] initWithFrame:CGRectMake(0, 75, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    self.webView.backgroundColor = [UIColor whiteColor];
    
    [self.webView setDelegate:self];
    
    [self.view addSubview:self.webView];
    
    [self createTopView];
    
    _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //设置显示位置
    _indicator.center = CGPointMake(kScreenWidth/2,kScreenHeight/2);
    //将这个控件加到父容器中。
    [self.view addSubview:_indicator];
    
    [_indicator startAnimating];
    
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
    
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    JSContext *context=[self.webView  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    
    context[@"basicInterface"]=self;
    
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
    label.text = self.title;
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
    
    //隐藏statu bar
    
    //方式一
    
    //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    //方式二
    
    //    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
    //
    //        [self prefersStatusBarHidden];
    //
    //        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    //
    //    }
    
    
    
}
//隐藏status bar
//- (BOOL)prefersStatusBarHidden
//{
//
//    return YES;
//
//}

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


@end
