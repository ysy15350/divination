//
//  WebApiTask.h
//  longkin
//
//  Created by 杨世友 on 15/10/27.
//  Copyright © 2015年 longkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebApiTask : NSObject

-(instancetype)initWithService:(NSString *)service WithParam:(NSMutableDictionary *)param;

-(void)RequestService:(void(^)(id result, NSError *error))block;
@end
