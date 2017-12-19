//
//  Request.m
//  longkin
//
//  Created by 杨世友 on 15/10/18.
//  Copyright © 2015年 longkin. All rights reserved.
//

#import "AFNetworking.h"
#import "Request.h"
#import "MD5Util.h"
#import "JsonUtil.h"
#import "Response.h"
#import "SysFunction.h"

#define isDebug YES

@interface Request()

@property (strong,nonatomic) NSString *format;

@property (strong,nonatomic) NSString *input_charset;

@property (strong,nonatomic) NSString *login_uid;

@property (strong,nonatomic) NSString *partner_id;

@property (strong,nonatomic) NSString *request_time;

@property (strong,nonatomic) NSString *sessionid;

//平台类型 AndRoid=2 IOS=3

@property (strong,nonatomic) NSString *plat_type;

@property (strong,nonatomic) NSString *service;

@property (strong,nonatomic) NSString *sign;

@property (strong,nonatomic) NSString *sign_type;

//接口版本号
@property (strong,nonatomic) NSString *version;

@end

@implementation Request



-(NSMutableDictionary *)params
{
    if(!_params)
        _params=[[NSMutableDictionary alloc] init];
    
    NSLog(@"_params:%@",_params);
    
    return _params;
}

-(instancetype)initWithParam:(NSMutableDictionary *)param forService:(NSString *)serviceName
{
    self= [super init];
    
    if(self)
    {
        self.service=serviceName;
        self.input_charset=@"utf-8";
        self.login_uid=[SysFunction getKeyValue:@"login_uid"];
        self.sessionid=[SysFunction getKeyValue:@"sessionid"];
        self.request_time=[SysFunction getDateString:[NSDate date] withFormat:nil];
        
//        self.requestUrl=isDebug==YES?@"http://zhanbu.59156.cn/App/":@"http://zhanbu.59156.cn/App/";//
        
         self.requestUrl=isDebug==YES?@"http://uranai.no1app.tokyo/App/":@"http://uranai.no1app.tokyo/App/";
        
        self.partner_id=isDebug==YES?@"d89170ee-7ede-415b-8022-3be2793d1674"
        :@"17ab7302-6ba9-4c4e-ab48-9ff004951b41";
        
        NSLog(@"partner_id:%@",self.partner_id);
        
        //平台类型 AndRoid=2 IOS=3
//        [param setObject:@"3" forKey: @"plat_type"];
//        [param setObject:@"json" forKey: @"format"];
//        [param setObject:self.service forKey:@"service"];
//        [param setObject:self.sessionid forKey:@"sessionid"];
//        [param setObject:self.partner_id forKey:@"partner_id"];
//        [param setObject:self.request_time forKey:@"request_time"];
//        [param setObject:self.input_charset forKey:@"input_charset"];
        
        //        if(self.login_uid)
        //            [param setObject:self.login_uid forKey:@"login_uid"];
        
        NSString *requestString=[self getRequestString:param];
        
        self.sign=[self getMd5String:requestString];
        
        //sign和sign_type 不加密,加密后添加到param
        [param setObject:self.sign forKey:@"sign"];
        [param setObject:@"md5" forKey:@"sign_type"];
        
        self.params=param;
    }
    return  self;
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
    
    
    
    return  requestString;
}

//获取请求字符串的MD5加密字符串
-(NSString *)getMd5String:(NSString *) requestString
{
    NSString *md5Str=@"";
    
    NSString *md5Key = isDebug==YES ? @"ljbapp2015" : @"longkin123!@#*";
    
    NSLog(@"md5Key:%@",md5Key);
    
    requestString=[requestString stringByAppendingFormat:@"%@", md5Key];
    
    md5Str= [MD5Util getMD5codeUpperCase:requestString];
    
    return md5Str;
    
}

@end
