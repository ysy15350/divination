//
//  Response.h
//  longkin
//
//  Created by 杨世友 on 15/10/27.
//  Copyright © 2015年 longkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "ResponseHead.h"

@interface Response:NSObject
//@property(readonly,nonatomic) ResponseHead* head;
//@property(strong,nonatomic) NSDictionary* body;
@property(nonatomic ,assign) NSInteger code;
@property(nonatomic ,copy) NSString *message;
@property(nonatomic ,copy) NSString *token;
@property(strong,nonatomic) NSDictionary* info;
@property(strong,nonatomic) NSDictionary* comment;
@property(strong,nonatomic) NSDictionary* result;
@end
