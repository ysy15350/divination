//
//  ResponseHead.m
//  longkin
//
//  Created by 杨世友 on 15/10/27.
//  Copyright © 2015年 longkin. All rights reserved.
//

#import "ResponseHead.h"
#import "SysFunction.h"

@interface ResponseHead()

@end

@implementation ResponseHead

-(void)setLogin_uid:(NSString *)login_uid
{
    _login_uid=login_uid;
    if(_login_uid)
    {
        [SysFunction setKeyValue:@"login_uid" withValue:login_uid];
    }
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"\ncode:%@\nmsg:%@\ntime:%@\nservice:%@\nsessionid:%@\nlogin_uid:%@",_response_code,_response_msg,_response_time,_service,_sessionid,_login_uid];
}


@end
