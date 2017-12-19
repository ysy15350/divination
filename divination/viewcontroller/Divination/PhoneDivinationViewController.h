//
//  PhoneDivinationViewController.h
//  divination
//
//  Created by 杨世友 on 2017/12/14.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DFPBannerView;

@interface PhoneDivinationViewController : UIViewController

@property (nonatomic, strong)DFPBannerView *bannerView;

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,copy) NSString *webUrl;

@property (nonatomic ,assign)NSInteger detail_id;

//查询参数
@property (nonatomic,copy) NSString *param;

- (void)loadData;

@end
