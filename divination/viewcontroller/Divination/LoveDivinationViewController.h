//
//  PhoneDivinationViewController.h
//  divination
//
//  Created by 杨世友 on 2017/12/14.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DFPBannerView;

@interface LoveDivinationViewController : UIViewController

@property (nonatomic, strong)DFPBannerView *bannerView;

@property (nonatomic ,strong)NSMutableArray *dataSource;
@property (nonatomic ,strong)NSMutableArray *tempArray;

//查询参数
@property (nonatomic,copy) NSString *param;

- (void)loadData;

//绑定list
-(void)bindData:(NSMutableArray *)data;

@end
