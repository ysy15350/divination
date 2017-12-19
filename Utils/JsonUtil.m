//
//  JsonUtil.m
//  longkin
//
//  Created by 杨世友 on 15/10/25.
//  Copyright © 2015年 longkin. All rights reserved.
//

#import "JsonUtil.h"
#import "Response.h"

@implementation JsonUtil

-(Response *)getDataByJson:(NSString *) jsonStr
{
    NSLog(@"jsonStr:%@",jsonStr);
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString: @"\r\n" withString: @""];
    jsonStr=[jsonStr stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    Response *response = [Response objectWithKeyValues:jsonStr];
    return response;
    
    
    //    NSDictionary *data2 = [jsonStr objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    //
    //    Response *response = [[Response alloc] initWithDictionary:data2 error:nil];
  
    //    if(response)
    //    {
    //        NSLog(@"response data:%@",response.head);
    //    }
    
    
}

@end
