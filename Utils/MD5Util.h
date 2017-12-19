//
//  MD5Util.h
//  longkin
//
//  Created by 杨世友 on 15/10/26.
//  Copyright © 2015年 longkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MD5Util : NSObject

//32位大写
+(NSString *)getMD5codeUpperCase:(NSString *)signString;

//32位小写
+(NSString*) getMD5codeLowerCase:(NSString*) signString;

@end
