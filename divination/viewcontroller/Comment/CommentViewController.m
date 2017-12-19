//
//  MainTab3ViewController.m
//  loan_supermarket
//
//  Created by 杨世友 on 2017/12/1.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import "CommentViewController.h"
#import "WebViewViewController.h"
#import "CommentCell.h"
#import "Config.h"
#import "UserBaseApi.h"
#import "InfoApi.h"
#import "Response.h"
#import "Divination.h"
#import "Comment.h"
#import "UserInfo.h"

#import "TggStarEvaluationView.h"
#import "UIColor+Hex.h"
#import "UIImageView+WebCache.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface CommentViewController ()<UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>
{
    UILabel *label;//标题
    
    UITableView *listTable;
    UIView *view1;//第一部分父视图
    UIView *view2;//第二部分父视图
    
    //------------第1部分----------------
    UIImageView *img1;//头像
    UILabel *title;//标题
    UILabel *title1;//满足度标题
    UILabel *title2;//准确度标题
    UILabel *title3;//人气度标题
    
    UILabel *content1;//头部内容
    
    UIButton *btn1;//第一部分里面的按钮，不认识
    
    //-------------第2部分---------------
    
    UILabel *titleFooter1;//
    UILabel *titleFooter2;//
    UILabel *titleFooter3;//(200字)
    //UITextView *textView1;//输入框
    UIButton *btnFooter1;//投稿按钮
    
    UIActivityIndicatorView *_indicator;

    
}

@property(nonatomic,strong) InfoApi *infoApi;
@property(nonatomic,strong) Comment *comment;
@property(nonatomic,strong) TggStarEvaluationView *starView1;
@property(nonatomic,strong) TggStarEvaluationView *starView2;
@property(nonatomic,strong) TggStarEvaluationView *starView3;
@property(nonatomic,strong) UITextView *textView0;//输入框
@property(nonatomic,strong) UITextView *textView1;//输入框

@end

@implementation CommentViewController

-(InfoApi *)infoApi
{
    if(!_infoApi)
        _infoApi=[[InfoApi alloc] init];
    
    return _infoApi;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     //self.dataSource = [NSMutableArray arrayWithObjects:@"1",@"2", nil];
    
    [self createListTable];
    [self createTopView];
    
    _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //设置显示位置
    _indicator.center = CGPointMake(kScreenWidth/2,kScreenHeight/2);
    //将这个控件加到父容器中。
    [self.view addSubview:_indicator];
    
    [self loadData];
   
    
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
    label.text = @"口コミ詳細";
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
        
        
        listTable.frame = CGRectMake(0, 70, kScreenWidth, kScreenHeight-70);
        
        [self.view addSubview:listTable];
        
        [self createTableViewHeaderView];
        [self createTableViewFooterView];
        
        
    }
}

-(void)createTableViewHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 228)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    listTable.tableHeaderView=headerView;
    
    int marginWidth=15;
    
    //分隔条
    UIView *temp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 13)];
    temp.backgroundColor = [UIColor colorWithHexString:@"#e0e0d8"];
    [headerView addSubview:temp];
    
    
    img1=[[UIImageView alloc] init];
    img1.frame = CGRectMake(marginWidth,marginWidth+13, 100, 100);
    img1.image=[UIImage imageNamed:@"tab1_item_test"];
    //设置圆角
    img1.layer.masksToBounds = YES;
    img1.layer.cornerRadius = 5.0;
    
    [headerView addSubview:img1];
    
    //---------第1排--------------
    title=[[UILabel alloc] init];
    title.frame=CGRectMake(marginWidth*2+100, marginWidth+13, kScreenWidth-(marginWidth*2)-100, 25);
    title.numberOfLines=1;
    title.font = [UIFont systemFontOfSize:12];
    title.textColor = [UIColor colorWithHexString:@"#664892"];
    title.text = @"-";
    title.textAlignment = NSTextAlignmentLeft;
    
    [headerView addSubview:title];
    //---------第2排--------------
    CGFloat y2=CGRectGetMaxY(title.frame);
    
    title1=[[UILabel alloc] init];
    title1.frame=CGRectMake(marginWidth*2+100, y2, kScreenWidth-(marginWidth*2)-100, 25);
    title1.numberOfLines=1;
    title1.font = [UIFont systemFontOfSize:16 ];
    title1.textColor = [UIColor colorWithHexString:@"#59585e"];
    title1.text = @"满足度";
    title1.textAlignment = NSTextAlignmentLeft;
    
    [headerView addSubview:title1];
    
    //---------第3排--------------
    CGFloat y3=CGRectGetMaxY(title1.frame);
    
    title2=[[UILabel alloc] init];
    title2.frame=CGRectMake(marginWidth*2+100, y3, kScreenWidth-(marginWidth*2)-100, 25);
    title2.numberOfLines=1;
    title2.font = [UIFont systemFontOfSize:16 ];
    title2.textColor = [UIColor colorWithHexString:@"#59585e"];
    title2.text = @"的中度";
    title2.textAlignment = NSTextAlignmentLeft;
    
    [headerView addSubview:title2];
    
    //---------第4排--------------
    CGFloat y4=CGRectGetMaxY(title2.frame);
    
    title3=[[UILabel alloc] init];
    title3.frame=CGRectMake(marginWidth*2+100, y4, kScreenWidth-(marginWidth*2)-100, 25);
    title3.numberOfLines=1;
    title3.font = [UIFont systemFontOfSize:16 ];
    title3.textColor = [UIColor colorWithHexString:@"#59585e"];
    title3.text = @"人気度";
    title3.textAlignment = NSTextAlignmentLeft;
    
    [headerView addSubview:title3];
    
    //-----------按钮-----------------
    

    CGFloat y=CGRectGetMaxY(img1.frame);
    
    btn1 = [[UIButton alloc]init];
    btn1.frame = CGRectMake(marginWidth, y+marginWidth, kScreenWidth-marginWidth*2, 45);
    btn1.titleLabel.font = [UIFont systemFontOfSize:20];
    btn1.backgroundColor=[UIColor colorWithHexString:@"#fbc106"];
    [btn1 setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [btn1 setTitle:@"口コミ" forState:UIControlStateNormal];
    //口コミ
    //無料鑑定すゐ
    //设置圆角
    btn1.layer.masksToBounds = YES;
    btn1.layer.cornerRadius = 5.0;
    
    btn1.tag = 501;
    
    [btn1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView addSubview:btn1];
    
    CGFloat y6=CGRectGetMaxY(btn1.frame);
    
    content1=[[UILabel alloc] init];
    content1.frame=CGRectMake(marginWidth, y6+10, kScreenWidth-(marginWidth*2), 25);
    content1.numberOfLines=1;
    content1.font = [UIFont systemFontOfSize:16];
    content1.textColor = [UIColor colorWithHexString:@"#555555"];
    content1.text = @"-";
    content1.textAlignment = NSTextAlignmentLeft;

    
    [headerView addSubview:content1];
    
    CGFloat y7=CGRectGetMaxY(content1.frame);
    
    
    //分隔线
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(marginWidth, y7+10, kScreenWidth-marginWidth*2, 1)];
    line1.backgroundColor = [UIColor colorWithHexString:@"#dedde2"];
    [headerView addSubview:line1];
    
    
    
    //-----------第1排星星---------------
    
    // 注意weakSelf
    //__weak __typeof(self)weakSelf = self;
    // 初始化
    self.starView1 = [TggStarEvaluationView evaluationViewWithChooseStarBlock:^(NSUInteger count) {
        // 做评星后点处理
        //[weakSelf something];
    }];
    
    
    
    self.starView1.frame = (CGRect){marginWidth*2+160,y2,10 * 10,25};
    [headerView addSubview:self.starView1];
    
    // 设置展示的星星数量
     self.starView1.starCount = 0;
    
    // 星星之间的间距，默认0.5
     self.starView1.spacing = 0.2;
    
    // 星星的点击事件使能,默认YES
     self.starView1.tapEnabled = NO;
    
     //-----------第2排星星---------------
    
    // 注意weakSelf
    //__weak __typeof(self)weakSelf = self;
    // 初始化
    self.starView2 = [TggStarEvaluationView evaluationViewWithChooseStarBlock:^(NSUInteger count) {
        // 做评星后点处理
        //[weakSelf something];
    }];
    
    self.starView2.frame = (CGRect){marginWidth*2+160,y3,10 * 10,25};
    [headerView addSubview:self.starView2];
    
    // 设置展示的星星数量
    self.starView2.starCount = 0;
    
    // 星星之间的间距，默认0.5
    self.starView2.spacing = 0.2;
    
    // 星星的点击事件使能,默认YES
    self.starView2.tapEnabled = NO;
    
    //-----------第3排星星---------------
    
    // 注意weakSelf
    //__weak __typeof(self)weakSelf = self;
    // 初始化
    self.starView3 = [TggStarEvaluationView evaluationViewWithChooseStarBlock:^(NSUInteger count) {
        // 做评星后点处理
        //[weakSelf something];
    }];
    
    self.starView3.frame = (CGRect){marginWidth*2+160,y4,10 * 10,25};
    [headerView addSubview:self.starView3];
    
    // 设置展示的星星数量
    self.starView3.starCount = 0;
    
    // 星星之间的间距，默认0.5
    self.starView3.spacing = 0.2;
    
    // 星星的点击事件使能,默认YES
    self.starView3.tapEnabled = NO;
    
}

-(void)createTableViewFooterView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 270)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    listTable.tableFooterView=footerView;
    
    //分隔条
    UIView *temp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 13)];
    temp.backgroundColor = [UIColor colorWithHexString:@"#e0e0d8"];
    [footerView addSubview:temp];
    
    int marginWidth=15;
    titleFooter1=[[UILabel alloc] init];
    titleFooter1.frame = CGRectMake(marginWidth, 13, kScreenWidth  - marginWidth*2, 45);
    titleFooter1.font = [UIFont systemFontOfSize:16];
    titleFooter1.textColor = [UIColor colorWithHexString:@"#372f54"];
    titleFooter1.text = @"口コミを書く ";
    titleFooter1.textAlignment = NSTextAlignmentLeft;
    
    [footerView addSubview:titleFooter1];
    
    CGFloat y=CGRectGetMaxY(titleFooter1.frame);
    
    //分隔线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(marginWidth, y, kScreenWidth-marginWidth*2, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#dedde2"];
    [footerView addSubview:line];
    
    CGFloat y1=CGRectGetMaxY(line.frame);
    
    _textView0=[[UITextView alloc] init];
    _textView0.frame = CGRectMake(marginWidth, y1, kScreenWidth  - marginWidth*2, 40);
    _textView0.font = [UIFont systemFontOfSize:16];
    _textView0.textColor = [UIColor colorWithHexString:@"#989898"];
    _textView0.text = @"";
    _textView0.textAlignment = NSTextAlignmentLeft;
    
    [footerView addSubview:_textView0];
    
    CGFloat y2=CGRectGetMaxY(_textView0.frame);
    
    //分隔线
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(marginWidth, y2, kScreenWidth-marginWidth*2, 1)];
    line1.backgroundColor = [UIColor colorWithHexString:@"#dedde2"];
    [footerView addSubview:line1];
    
    CGFloat y3=CGRectGetMaxY(line1.frame);
    
    titleFooter3=[[UILabel alloc] init];
    titleFooter3.frame = CGRectMake(marginWidth, y3, kScreenWidth  - marginWidth*2, 40);
    titleFooter3.font = [UIFont systemFontOfSize:16];
    titleFooter3.textColor = [UIColor colorWithHexString:@"#989898"];
    titleFooter3.text = @"コメント(200字）";
    titleFooter3.textAlignment = NSTextAlignmentLeft;
    
    [footerView addSubview:titleFooter3];
    
    CGFloat y4=CGRectGetMaxY(titleFooter3.frame);
    
    _textView1=[[UITextView alloc] init];
    _textView1.frame = CGRectMake(marginWidth, y4, kScreenWidth  - marginWidth*2, 100);
    _textView1.font = [UIFont systemFontOfSize:16];
    _textView1.textColor = [UIColor colorWithHexString:@"#555555"];
    _textView1.text = @"";
    _textView1.textAlignment = NSTextAlignmentLeft;
    
    _textView1.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    
    [footerView addSubview:_textView1];
    
    CGFloat y5=CGRectGetMaxY(_textView1.frame);
    
    //分隔线
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(marginWidth, y5+5, kScreenWidth-marginWidth*2, 1)];
    line2.backgroundColor = [UIColor colorWithHexString:@"#dedde2"];
    [footerView addSubview:line2];
    
    
    
    //-----------按钮-----------------
    
    
    CGFloat y6=CGRectGetMaxY(line2.frame);

    btnFooter1 = [[UIButton alloc]init];
    btnFooter1.frame = CGRectMake(kScreenWidth-marginWidth-90, y4+75, 90, 25);
    btnFooter1.titleLabel.font = [UIFont systemFontOfSize:14];
    btnFooter1.backgroundColor=[UIColor colorWithHexString:@"#fbc106"];
    [btnFooter1 setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [btnFooter1 setTitle:@"投稿" forState:UIControlStateNormal];
    //设置圆角
    btnFooter1.layer.masksToBounds = YES;
    btnFooter1.layer.cornerRadius = 5.0;

    btnFooter1.tag = 502;

    [btnFooter1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];

    [footerView addSubview:btnFooter1];
    
    
}

//绑定数据
-(void)bindData:(Comment *) comment{
    NSString *url= [Config getServiceUrl];
    if(comment){
       

        NSString *images= comment.images;
        
        NSString *imageUrl=[url stringByAppendingString:images];
        
        NSLog(@"%@",imageUrl);
        
        //@"http://www.360vrdh.com:8080/api/file/imgGet?fid=2"
        
        [img1 sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                    placeholderImage:[UIImage imageNamed:@"tab1_item_test"]];
        
        title.text=comment.title;
        content1.text=comment.descriptions;
        
        self.starView1.starCount = comment.like_a;
        self.starView2.starCount = comment.like_b;
        self.starView3.starCount = comment.like_c;
        
    }
}


-(void)add_comment{
    //[SVProgressHUD showWithStatus:@"正在加载..."];
    [_indicator startAnimating];
    
    NSString *identification=[[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *username=_textView0.text;//@"名無し";
    if([@"" isEqualToString:username]){
        username=@"名無し";
    }
    NSString *content=_textView1.text;
    
    __weak CommentViewController *weakSelf=self;
    
    [self.infoApi add_comment:_detail_id identification:identification username:username content:content complete:^(id result, NSError *error) {
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
            
            NSLog(@"Result: %@", result);
            Response *response=[Response objectWithKeyValues:result];
            if(response){
                NSInteger code=response.code;
                NSString *msg=response.message;
                
                NSLog(@"%@",msg);
                
                if(code==200){
                    [weakSelf loadData];
                    weakSelf.textView1.text=@"";
                }
                else{
                    //NSLog(@"%@",msg);
                }
            }
            
        }
    }];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.dataSource.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list"];
    
    if (!cell) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"list"];
    }
    Comment *comment=(Comment *)([self dataSource][indexPath.row]);
    if(comment){
        if(comment.ad_status==1){
            cell.labelTitle.text=@"ads";
            cell.labelContent.text=@"cd";
        }
    }
    cell.itemData=[self dataSource][indexPath.row];
    cell.index = indexPath.row;
    //cell.delegate = self;
    return cell;
}


//获取数据
- (void)loadData
{
   
    
    [_indicator startAnimating];
    //[SVProgressHUD showWithStatus:@"正在加载..."];
    
    [self.infoApi details:_detail_id complete:^(id result, NSError *error) {
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
            
            NSLog(@"Result: %@", result);
            Response *response=[Response objectWithKeyValues:result];
            if(response){
                NSInteger code=response.code;
                NSString *msg=response.message;
                
                NSLog(@"%@",msg);
                
                if(code==200){
                    
                    Comment *comment= [Comment objectWithKeyValues:response.result];
                    self.comment=comment;
                    [self bindData:comment];
                    
                    if(response.comment){
                        NSArray *array=[Comment objectArrayWithKeyValuesArray:response.comment];
                        
                        if(array&&array.count>0){
                        
                            self.dataSource=[array copy];
                            if (listTable) {
                                [listTable reloadData];
                            }
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"list" object:nil userInfo:@{@"list":self.dataSource}];
                        }
                    }
                }
                else{
                    //NSLog(@"%@",msg);
                }
            }
            
            
            
            //self.dataSource = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8", nil];
            
            
           
            
            [_indicator stopAnimating];
            //[SVProgressHUD dismiss];
            
        }
    }];

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
            
            
            if(self.comment){
                NSString *title=self.comment.title;
                NSString *tz_url=self.comment.tz_url;
                NSString *detail_url=self.comment.detail_url;
                
                NSString *webUrl=nil;
                
                if(tz_url&&![@"" isEqualToString:tz_url]){
                    webUrl=tz_url;
                }
                else if(detail_url){
                    NSString *url= [Config getServiceUrl];
                    webUrl=[url stringByAppendingString:detail_url];
                }
                
                if(webUrl&&![webUrl isEqualToString:@""]){
                    
                    NSLog(@"openweb,title:%@,url:%@",title,webUrl);
                    
                    [self GotoWebViewController:webUrl withTitle:title];
                }
                
                
            }
            
            
            break;
        }
        case 502:
            NSLog(@"ok");
            [self add_comment];
            break;
    }
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

