//
//  JsonUtil.h
//  longkin
//
//  Created by 杨世友 on 15/10/25.
//  Copyright © 2015年 longkin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Response;

@interface JsonUtil : NSObject
-(Response *)getDataByJson:(NSString *) jsonStr;
@end
