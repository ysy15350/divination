//
//  UserBaseApi.h
//  longkin
//
//  Created by 杨世友 on 15/10/30.
//  Copyright © 2015年 longkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserBaseApi : NSObject

//用户登录
-(void)m_login_in:(NSString *)username withPassword:(NSString *)password complete:(void(^)(id result, NSError *error))block;

@end
