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

-(void)click_report:(NSString *)detail_id andType:(NSString *)type complete:(void (^)(id, NSError *))block{
    
    self.params=[[NSMutableDictionary alloc] init];
    
    [self.params setObject:detail_id forKey:@"id"];
    
    [self.params setObject:type forKey:@"type"];
    
    self.webApiTask=[[WebApiTask alloc] initWithService:[moduleName stringByAppendingString:@"click_report"] WithParam:self.params];
    
    [self.webApiTask RequestService:^(id result, NSError *error) {
        if (error)
        {
            if (block) block(nil, error);
        }
        else
        {
        
            NSLog(@"result%@", result);
            
          
            if (block) block(result, nil);
        }
    }];
}

-(void)delete_list:(NSString *)identification andOtherId:(NSString *)other_id complete:(void (^)(id, NSError *))block{
    self.params=[[NSMutableDictionary alloc] init];
    
    [self.params setObject:identification forKey:@"identification"];
    
    [self.params setObject:other_id forKey:@"other_id"];
    [self.params setObject:@"1" forKey:@"type"];
    
    self.webApiTask=[[WebApiTask alloc] initWithService:[moduleName stringByAppendingString:@"delete_list"] WithParam:self.params];
    
    [self.webApiTask RequestService:^(id result, NSError *error) {
        if (error)
        {
            if (block) block(nil, error);
        }
        else
        {
            
            NSLog(@"result%@", result);
            
            
            if (block) block(result, nil);
        }
    }];
}

@end
