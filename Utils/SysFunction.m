//
//  SysFunction.m
//  longkin
//
//  Created by 杨世友 on 15/10/27.
//  Copyright © 2015年 longkin. All rights reserved.
//

#import "SysFunction.h"

#import <QuartzCore/QuartzCore.h>


@implementation SysFunction

+(void)initializeUserInterface:(UIViewController *)controller withTitle:(NSString *)title
{
    
    //7.0以上版本解决高度上升问题
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        
        controller.edgesForExtendedLayout=UIRectEdgeNone;
        
        controller.extendedLayoutIncludesOpaqueBars = NO;
        controller.modalPresentationCapturesStatusBarAppearance = NO;
        
        NSString *s=[NSString stringWithFormat:@"ios版本%f",[[[UIDevice currentDevice] systemVersion] doubleValue]];
        
        NSLog(@"%@",s);
        
    }
    
    controller.view.backgroundColor = [self getFormHeadColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:controller.view.bounds];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    controller.navigationItem.titleView = titleLabel;
    
    [controller.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.164 green:0.657 blue:0.915 alpha:1.000]];
}

+(UIColor *)getFormHeadColor
{
    return  [UIColor colorWithRed:0.936 green:0.941 blue:0.936 alpha:1.000];
}

+(void)setRoundedRectangle:(UIView *)view withColor:(UIColor *)color
{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 6.0;
    view.layer.borderWidth = 1.0;
    view.layer.borderColor =[color CGColor];
}

+(void)setKeyValue:(NSString *)key withValue:(NSString *)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults] ;//获取标准函数对象
    
    [defaults setObject:value forKey:key];
    
    [[NSUserDefaults standardUserDefaults] synchronize];//synchronize 方法：同步之前存储的内容
    
    NSLog(@"SysFunction setKeyValue,key:%@,value:%@",key,value);
    
}
+(NSString *)getKeyValue:(NSString *)key
{
    NSString *value=nil;
    
    //NSUserDefaults 数据库存储的必须是属性列表，且很小，性能不是很好，不要存放图片
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];//获取标准函数对象
    value=[defaults objectForKey:key];
    
    NSLog(@"SysFunction getKeyValue,key:%@,value:%@",key,value);
    
    return value;
}


+(NSString *)getDateString:(NSDate *)date withFormat:(NSString *)format
{
    NSString * dateStr=@"";
    if(!format)
        format=@"yyyyMMddHHmmssSSS";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timeZone];
    //输出格式
    [dateFormatter setDateFormat:format];
    dateStr = [dateFormatter stringFromDate:date];
    
    return dateStr;
}
+(NSString *)getDateStringOfTimeStamp:(NSInteger )date withFormat:(NSString *)format{
    
    NSNumber *dateNum=[[NSNumber alloc] initWithInteger:date];
    
    NSTimeInterval time=[dateNum doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    NSLog(@"date:%@",[detaildate description]);
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:format];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}

@end
