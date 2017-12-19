//
//  UserBaseApi.m
//  longkin
//
//  Created by 杨世友 on 15/10/30.
//  Copyright © 2015年 longkin. All rights reserved.
//

#import "UserBaseApi.h"
#import "MD5Util.h"
#import "WebApiTask.h"
#import "UserInfo.h"
#import "Response.h"

@interface UserBaseApi()
@property(strong,nonatomic) NSString *service;
@property(strong,nonatomic) NSMutableDictionary *params;

@property(nonatomic,strong) WebApiTask *webApiTask;
@end

@implementation UserBaseApi

-(WebApiTask *)webApiTask
{
    if(!_webApiTask) _webApiTask=[[WebApiTask alloc] init];
    return _webApiTask;
}

-(void)m_login_in:(NSString *)username withPassword:(NSString *)password complete:(void(^)(id result, NSError *error))block
{
    self.params=[[NSMutableDictionary alloc] init];
    
    [self.params setObject:username forKey:@"username"];
    
    password=[MD5Util getMD5codeLowerCase:password];
    [self.params setObject:password forKey:@"password"];
    
    self.webApiTask=[[WebApiTask alloc] initWithService:@"longkin.user.m_login_in" WithParam:self.params];
    
    [self.webApiTask RequestService:^(id result, NSError *error) {
        if (error)
        {
            if (block) block(nil, error);
        }
        else
        {
            
            NSArray * arraylist = [UserInfo keyValuesArrayWithObjectArray:result];
            
            NSLog(@"arraylist%ld", arraylist.count);
            
            //UserInfo *userinfo=[UserInfo objectWithKeyValues:result];
            
            if (block) block(arraylist, nil);
        }
    }];
}

@end
