//
//  WebApiTask.m
//  longkin
//
//  Created by 杨世友 on 15/10/27.
//  Copyright © 2015年 longkin. All rights reserved.
//

#import "AFNetworking.h"
#import "WebApiTask.h"
#import "Request.h"
#import "Response.h"
#import "SysFunction.h"

@interface WebApiTask ()
@property(strong,nonatomic) NSString *service;
@property(strong,nonatomic) NSMutableDictionary *params;//业务参数

@property(nonatomic,strong) Request *request;
@property(nonatomic,strong) Response *response;
@end

@implementation WebApiTask

-(instancetype)initWithService:(NSString *)service WithParam:(NSMutableDictionary *)param
{
    self= [super init];
    if(self)
    {
        self.service=service;
        self.params=param;
        NSLog(@"service:%@",self.service);
        NSLog(@"params:%@",self.params);
    }
    return  self;
}

-(Request *)request
{
    _request=[[Request alloc] initWithParam:self.params forService:self.service ];
    
    //NSLog(@"_request:%@",_request);
    return _request;
}

-(Response *)response
{
    if(!_response) _response=[[Response alloc] init];
    return _response;
}

-(NSMutableDictionary *)params
{
    if(!_params)_params= [[NSMutableDictionary alloc] init];
    
    //NSLog(@"_params:%@",_params);
    return _params;
}

//获取请求字符串（用于加密）
-(NSString *)getRequestString:(NSDictionary *)params
{
    NSArray *keys= [params.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    id key, value;
    
    NSString *requestString=@"";
    
    for (int i = 0; i < [keys count]; i++)
    {
        key = [keys objectAtIndex: i];
        value = [params objectForKey: key];
        NSString *str=@"";
        
        if(i<[keys count]-1)
            str=[NSString stringWithFormat:@"%@=%@&", key, value];
        else
            str=[NSString stringWithFormat:@"%@=%@", key, value];
        
        requestString=[requestString stringByAppendingString:str];
        
    }
    
    //https://app.longkin.net?format=json&input_charset=utf-8&isnonovice=10&page=0&pagesize=5&partner_id=17ab7302-6ba9-4c4e-ab48-9ff004951b41&plat_type=3&request_time=20151108224422090&service=longkin.invest.m_invest_trade_list&sessionid=37BA6B40-F98F-425E-9BC6-46A9AD2C42B5&sign=198C7CCE7D777313668ADB3CFC8BCD9C&sign_type=md5
    
    
    return  requestString;
}

-(void)RequestService:(void(^)(id result, NSError *error))block
{
    
    
   
    //每次向block发送消息时，系统会创建一个指向该对象的强指针
    //block 简写：如果没有参数可将  ^(){}  写成：^{}
    
    //有返回值的block:如 ^BOOL(id obj,...)，可省略BOOL(^(id obj,...){})
    
    //可将block存储起来，如添加到 NSMutableArray 中，和block变量中
    
    // NSMutableArray *myBlocks;//数组对其内容都是强引用的
    
    // [myBlocks addObject:^{//[self response]self:强指针
    //  }];//将一个无参无返回值（或者返回值为BOOL）的block添加到集合中;
    
    //注意：block中使用了self(强指针),myBlocks中的内容（block块本身）也是强指针，这样二者都无法从栈中释放，所以需要将变量设置为弱指针，如：__weak MyClass *week;
    
    //doit：block类型的变量名
    // void (^doit)(void) =myBlocks[0];
    
    //__block BOOL isSuccess;//__block定义的变量可在blcok中赋值，否则isSuccess为只读
    //只要block存在，block中所有对象都有一个强指针指向它们
    
    //局部变量(指针变量)是指向堆中的强指针，直到方法结束，强指针被释放
    //block注意（存储循环）：如果在block语句块中 使用了self，需要将变量设置为弱指针(不会在堆中保存该对象):__weak;
    
    __weak WebApiTask *weakSelf=self;
    
    NSString *url=[NSString stringWithFormat:@"%@/%@",self.request.requestUrl,self.service];
    NSLog(@"请求地址字符串:%@",url);
    
    //AFNetworking忽略缓存
    NSURLCache *shareCache= [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    
    [NSURLCache setSharedURLCache:shareCache];
    //[shareCache release];
    
    //mutableCopy copy
    NSDictionary *parameters =[self.request.params copy];//获取请求参数（系统参数、业务参数）
    
    NSString * paramterStr= [self getRequestString:parameters];
    NSLog(@"请求参数字符串：%@",paramterStr);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *token=[SysFunction getKeyValue:@"token"];
    
    NSLog(@"缓存 token:%@",token);

    if([self.service containsString:@"send_token"]){
        token=@"header-token";
    }
    
    NSLog(@"缓存 token:%@",token);
    
    
    NSString *Authorization=[NSString stringWithFormat:@"gamea_%@",token];
    
    NSLog(@"参数token：%@",Authorization);
    
    [manager.requestSerializer setValue:Authorization forHTTPHeaderField:@"Authorization"];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        //获取cookie
       // NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//        for (NSHTTPCookie *tempCookie in cookies) {
//            //打印获得的cookie
//            NSLog(@"getCookie: %@", tempCookie);
//        }
        
        //        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        //        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        //        //系统自带JSON解析
        //        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        
        
        
        weakSelf.response= [Response objectWithKeyValues:responseObject];//有一个强指针指向self
        
        NSLog(@"response code: %ld",weakSelf.response.code);
        NSLog(@"response message: %@",weakSelf.response.message);
        NSLog(@"response token: %@",weakSelf.response.token);
        NSLog(@"response : %@",responseObject);
        
        if(weakSelf.response.token){
            NSString *token=weakSelf.response.token;
            [SysFunction setKeyValue:@"token" withValue:token];
        }
        
        if (block) block(responseObject, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
    
}


@end
