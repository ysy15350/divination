//
//  AppDelegate.m
//  divination
//
//  Created by 杨世友 on 2017/12/13.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

//禁用横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    
    
    
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"supportedInterfaceOrientationsForWindow"];
    //    NSLog(@"supportedInterfaceOrientationsForWindow:%@",str);
    
    
    NSInteger soTime;
    
    int i = 0;
    
    
    //
    if (str != nil)
    {
        soTime = [str integerValue];
        
    }
    
    
    if (i == 0) {
        soTime = 0;
        
    }else {
        soTime = [str integerValue];
        
    }
    
    
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"first"]isEqualToString:@"one"])
    {
        
        
        //如果是第一次启动的话,使用UserGuideViewController (用户引导页面) 作为根视图
        soTime = 0;
        
    }
    else
    {
        
        //如果不是第一次启动的话,使用LoginViewController作为根视图
        
        soTime = [str integerValue];
    }
    
    
    if (soTime == 0)
    {
        return UIInterfaceOrientationMaskPortrait;
    }else
    {
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置全局状态栏字体颜色为白色
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}



- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
