//
//  ResponseHead.h
//  longkin
//
//  Created by 杨世友 on 15/10/27.
//  Copyright © 2015年 longkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseHead :NSObject

@property(strong,nonatomic) NSString* response_code;

@property(strong,nonatomic) NSString* response_msg;

@property(strong,nonatomic) NSString* partner_id;

@property(strong,nonatomic) NSString* service;

@property(strong,nonatomic) NSString* response_time;

@property(strong,nonatomic) NSString* input_charset;

@property(strong,nonatomic) NSString* sign_type;

@property(strong,nonatomic) NSString* sign;

@property(strong,nonatomic) NSString* sessionid;

@property(strong,nonatomic) NSString* login_uid;

@end
