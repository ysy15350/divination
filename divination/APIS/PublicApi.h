//
//  PublicApi.h
//  divination
//
//  Created by 杨世友 on 2017/12/15.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicApi : NSObject

//用户登录
//-(void)m_login_in:(NSString *)username withPassword:(NSString *)password complete:(void(^)(id result, NSError *error))block;

//获取token
-(void)send_token:(NSString *)account andPassword:(NSString *)password complete:(void(^)(id result, NSError *error))block;

@end