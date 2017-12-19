//
//  PublicApi.m
//  divination
//
//  Created by 杨世友 on 2017/12/15.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import "PublicApi.h"
#import "WebApiTask.h"

static const NSString * moduleName = @"Public/";

@interface PublicApi()
@property(strong,nonatomic) NSString *service;
@property(strong,nonatomic) NSMutableDictionary *params;

@property(nonatomic,strong) WebApiTask *webApiTask;
@end

@implementation PublicApi

-(void)send_token:(NSString *)account andPassword:(NSString *)password complete:(void (^)(id, NSError *))block{
    self.params=[[NSMutableDictionary alloc] init];
    
    [self.params setObject:@"gamea2017" forKey:@"account"];
    
    [self.params setObject:@"gamea_123456" forKey:@"password"];
    
    self.webApiTask=[[WebApiTask alloc] initWithService:[moduleName stringByAppendingString:@"send_token"] WithParam:self.params];
    
    [self.webApiTask RequestService:^(id result, NSError *error) {
        if (error)
        {
            if (block) block(nil, error);
        }
        else
        {
            
            //NSArray * arraylist = [UserInfo keyValuesArrayWithObjectArray:result];
            
            NSLog(@"result%@", result);
            
            //UserInfo *userinfo=[UserInfo objectWithKeyValues:result];
            
            if (block) block(result, nil);
        }
    }];
}

@end
