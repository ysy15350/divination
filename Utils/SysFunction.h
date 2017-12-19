//
//  SysFunction.h
//  longkin
//
//  Created by 杨世友 on 15/10/27.
//  Copyright © 2015年 longkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface SysFunction : UIViewController

+(void)initializeUserInterface:(UIViewController *) controller withTitle:(NSString *) title;

+(UIColor *)getFormHeadColor;
+(void)setRoundedRectangle:(UIView *)view withColor:(UIColor *)color;
+(void)setKeyValue:(NSString *)key withValue:(NSString *)value;
+(NSString *)getKeyValue:(NSString *)key;
+(NSString *)getDateString:(NSDate *)date withFormat:(NSString *)format;
+(NSString *)getDateStringOfTimeStamp:(NSInteger)date withFormat:(NSString *)format;

@end
