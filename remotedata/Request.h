//
//  Request.h
//  longkin
//
//  Created by 杨世友 on 15/10/18.
//  Copyright © 2015年 longkin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Response;

@interface Request : NSObject

@property (strong,nonatomic) NSString * requestUrl;

@property (strong,nonatomic) NSMutableDictionary *params;

-(instancetype)initWithParam:(NSMutableDictionary *)param forService:(NSString *)serviceName;

@end
