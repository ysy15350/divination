//
//  InfoApi.m
//  divination
//
//  Created by 杨世友 on 2017/12/15.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import "InfoApi.h"
#import "WebApiTask.h"

static const NSString * moduleName = @"Info/";

@interface InfoApi()
@property(strong,nonatomic) NSString *service;
@property(strong,nonatomic) NSMutableDictionary *params;
@property(nonatomic,strong) WebApiTask *webApiTask;
@end

@implementation InfoApi

-(void)index_infoWithComplete:(void (^)(id, NSError *))block{
    
    self.params=[[NSMutableDictionary alloc] init];
    
    self.webApiTask=[[WebApiTask alloc] initWithService:[moduleName stringByAppendingString:@"index_info"] WithParam:self.params];
    
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

-(void)lists:(NSInteger)type page:(NSInteger)page num:(NSInteger)num complete:(void (^)(id, NSError *))block
{
    
    self.params=[[NSMutableDictionary alloc] init];
    [self.params setValue:[NSNumber numberWithInteger:type] forKey:@"type"];
    [self.params setValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [self.params setValue:[NSNumber numberWithInteger:num] forKey:@"num"];
    
    self.webApiTask=[[WebApiTask alloc] initWithService:[moduleName stringByAppendingString:@"lists"] WithParam:self.params];
    
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

-(void)details:(NSInteger)detail_id complete:(void (^)(id, NSError *))block{
    self.params=[[NSMutableDictionary alloc] init];
    [self.params setValue:[NSNumber numberWithInteger:detail_id] forKey:@"id"];
    
    self.webApiTask=[[WebApiTask alloc] initWithService:[moduleName stringByAppendingString:@"details"] WithParam:self.params];
    
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

-(void)add_comment:(NSInteger) detail_id identification:(NSString *)identification username:(NSString *)username content:(NSString *)content complete:(void (^)(id, NSError *))block{
    self.params=[[NSMutableDictionary alloc] init];
    [self.params setValue:[NSNumber numberWithInteger:detail_id] forKey:@"id"];
    [self.params setValue:identification forKey:@"identification"];
    [self.params setValue:username forKey:@"username"];
    [self.params setValue:content forKey:@"content"];
    
    self.webApiTask=[[WebApiTask alloc] initWithService:[moduleName stringByAppendingString:@"add_comment"] WithParam:self.params];
    
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


-(void)clinicComplete:(void (^)(id, NSError *))block{
    self.params=[[NSMutableDictionary alloc] init];
    
    self.webApiTask=[[WebApiTask alloc] initWithService:[moduleName stringByAppendingString:@"clinic"] WithParam:self.params];
    
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

-(void)clinic_detail:(NSInteger)detail_id complete:(void (^)(id, NSError *))block{
    self.params=[[NSMutableDictionary alloc] init];
    [self.params setValue:[NSNumber numberWithInteger:detail_id] forKey:@"id"];
    
    self.webApiTask=[[WebApiTask alloc] initWithService:[moduleName stringByAppendingString:@"clinic_detail"] WithParam:self.params];
    
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

-(void)tel_detail:(NSInteger) detail_id complete:(void(^)(id result, NSError *error))block{
    self.params=[[NSMutableDictionary alloc] init];
    [self.params setValue:[NSNumber numberWithInteger:detail_id] forKey:@"id"];
    
    self.webApiTask=[[WebApiTask alloc] initWithService:[moduleName stringByAppendingString:@"tel_detail"] WithParam:self.params];
    
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
