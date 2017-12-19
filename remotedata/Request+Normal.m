//
//  Request+Normal.m
//  longkin
//
//  Created by 杨世友 on 15/11/1.
//  Copyright © 2015年 longkin. All rights reserved.
//

#import "Request+Normal.h"

#import "Request.h"
#import "MD5Util.h"
#import "JsonUtil.h"
#import "Response.h"
#import "SysFunction.h"


@implementation Request (Normal)
-(NSString *)getRequestStr
{
    NSArray *keys= [self.params.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    id key, value;
    
    NSString *requestString=@"";
    
    for (int i = 0; i < [keys count]; i++)
    {
        key = [keys objectAtIndex: i];
        value = [self.params objectForKey: key];
        NSString *str=@"";
        
        if(i<[keys count]-1)
            str=[NSString stringWithFormat:@"%@=%@&", key, value];
        else
            str=[NSString stringWithFormat:@"%@=%@", key, value];
        
        requestString=[requestString stringByAppendingString:str];
    }
    return requestString;
}

-(Response *)requestByGet
{
    NSString *requestString= [self getRequestStr];
    
    NSString *requestUrl=[NSString stringWithFormat:@"http://115.28.78.72:83?%@",requestString];
    
    //    NSURL * URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURL *url = [NSURL URLWithString:requestUrl];
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:url];
    NSURLResponse * response = nil;
    NSError * error = nil;
    
    //需要在项目中info.plist(以文本方式打开)，添加//
    /*
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"error: %@",[error localizedDescription]);
    }else{
        
        //NSLog(@"response : %@",response);
        NSString *backData=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        JsonUtil *jsonUtil= [[JsonUtil alloc] init];
        [jsonUtil getDataByJson:backData];
        
    }
    
    return nil;
}

//斯坦福教程示例
-(void)request
{
    NSString * URLString = @"http://115.28.78.72:83";
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    //        [NSURLSessionConfiguration ephemeralSessionConfiguration];//临时会话配置，如果要下载什么内容，下载完成就完了
    //defaultSessionConfiguration:默认会话设置，可能在下载多个文件，执行多项内容
    //backgroundSessionConfiguration:表示开始下载文件后,即使用户切换到其他应用或应用停止 也会继续下载
    NSURLSessionConfiguration *configuration=[NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session=[NSURLSession sessionWithConfiguration:configuration];//...;//用于管理一个会话的时间开始与网络通信
    NSURLSessionDownloadTask *task;
    task= [session downloadTaskWithRequest:request completionHandler:^(NSURL *localfile,NSURLResponse *response,NSError *error){
        
        //localfile :本地文件URL,是网络URL的保存地址，将URL内容从网上下载下来，保存在本地文件中，再返回文件URL
        
    }];
    
    [task resume];
    
}

-(Response *)requestByPost
{
    NSString * URLString = @"http://115.28.78.72:83";
    NSURL * URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableData *body = [ NSMutableData data ];
    
    NSString *requestString= [self getRequestStr];
    [body appendData :[[ NSString stringWithFormat : @"%@" , requestString ] dataUsingEncoding : NSUTF8StringEncoding ]];
    
    //NSLog(@"requestString:%@",requestString);
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:URL]; //设置请求的地址
    [request setHTTPBody:body];  //设置请求的参数
    
    NSURLResponse * response;
    NSError * error;
    NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        NSLog(@"error : %@",[error localizedDescription]);
    }else{
        //NSLog(@"response : %@",response);
        //NSLog(@"post:backData : %@",[[NSString alloc]initWithData:backData encoding:NSUTF8StringEncoding]);
        
        NSString *json=[[NSString alloc]initWithData:backData encoding:NSUTF8StringEncoding];
        
        
        JsonUtil *jsonUtil= [[JsonUtil alloc] init];
        Response *response= [jsonUtil getDataByJson:json];
        
        return response;
        
    }
    
    return nil;
}
@end
