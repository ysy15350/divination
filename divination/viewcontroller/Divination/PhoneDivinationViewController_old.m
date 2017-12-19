//
//  PhoneDivinationViewController.m
//  divination
//
//  Created by 杨世友 on 2017/12/14.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import "PhoneDivinationViewController.h"
#import "UIColor+Hex.h"
#import "Config.h"
#import "InfoApi.h"
#import "Response.h"
#import "Divination.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "PhoneDivinationCell.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface PhoneDivinationViewController ()<UITableViewDelegate,UITableViewDataSource,PhoneDivinationSelectDelegate>{
    UIActivityIndicatorView *_indicator;
    UILabel *label;//标题
    UITableView *listTable;
    NSInteger pageIndex;
    NSInteger pageSize;
    NSInteger type;//1:恋爱相谈,2事业占卜，3评论列表
}

@property(nonatomic,strong) InfoApi *infoApi;

@end

@implementation PhoneDivinationViewController

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
    
    type=1;//1:恋爱相谈,2事业占卜，3评论列表
    pageIndex=1;
    pageSize=10;
    
    self.dataSource = [[NSMutableArray alloc] init];
    self.dataSource = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8", nil];
    self.tempArray = [NSMutableArray array];
    
    [self createListTable];
    [self createTopView];
    [self createBottomView];
    
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

- (void)createBottomView
{
    //底部tabBar height 49  间距 :15 bottom height:75
    UIImageView *bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight-(kScreenWidth/5), kScreenWidth, (kScreenWidth/5))];
    //bottomView.backgroundColor = [UIColor colorWithHexString:@"#312950"];
    
    NSString *imgName=[NSString stringWithFormat:@"tab1_img%d",4];
    bottomView.image=[UIImage imageNamed:imgName];
    
    [self.view addSubview:bottomView];
}

- (void)createListTable
{
    if (!listTable) {
        listTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        listTable.showsVerticalScrollIndicator = NO;
        listTable.delegate = self;
        listTable.dataSource = self;
        [self setExtraCellLineHidden:listTable];
        
        
        __weak typeof(self) weakSelf = self;
        
        listTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            pageIndex = 1;
            
            [weakSelf loadData];
        }];
        //        listTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //            pageNo ++;
        //            [weakSelf loadMore];
        //        }];
        
        listTable.frame = CGRectMake(0, 90, kScreenWidth, kScreenHeight-90-(15+(kScreenWidth/5)));
        
        [self.view addSubview:listTable];
    }
}

- (void)setExtraCellLineHidden: (UITableView *)tableView


{
    
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return 120;
    
    UITableViewCell *cell = [self tableView:listTable cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定cellIdentifier为自定义的cell
    static NSString *CellIdentifier = @"Cell";
    //自定义cell类
    PhoneDivinationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PhoneDivinationCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    NSLog(@"%ld",indexPath.row);
    //Divination *data=[self dataSource][indexPath.row];
    Divination *data=[[Divination alloc] init];
    if(indexPath.row==1||indexPath.row==3||indexPath.row==4)
        data.images=@"http://www.360vrdh.com:8080/api/file/imgGet?fid=84";
    [cell setData:data];
    cell.itemData=[self dataSource][indexPath.row];
    cell.index = indexPath.row;
    cell.delegate = self;
    return cell;
}



//获取数据
- (void)loadData
{
    [listTable.mj_header endRefreshing];
    [listTable.mj_footer endRefreshing];
    
    
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
            
            
            
            //self.dataSource = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8", nil];
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"list" object:nil userInfo:@{@"list":self.dataSource}];
            
            
            
            [_indicator stopAnimating];
            //[SVProgressHUD dismiss];
            
        }
    }];
    
    
    
    
    
}

-(void)loadMore
{
    
}

-(void)bindData:(NSMutableArray *)data
{
    self.dataSource =data;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"list" object:nil userInfo:@{@"list":self.dataSource}];
    
    if (listTable) {
        [listTable reloadData];
    }
    
    [SVProgressHUD dismiss];
    
}

-(void)detail:(NSInteger)index{
    Divination *divination= [self.dataSource objectAtIndex:index];
    if(divination){
        NSString *url= [Config getServiceUrl];
        NSString *webUrl=[url stringByAppendingString:divination.detail_url];
        NSLog(@"detail:%@",webUrl);
        //[self GotoWebViewController:webUrl];
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
