//
//  PhoneDivinationViewController.h
//  divination
//
//  Created by 杨世友 on 2017/12/14.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneDivinationViewController : UIViewController

@property (nonatomic ,strong)NSMutableArray *dataSource;
@property (nonatomic ,strong)NSMutableArray *tempArray;

@property (nonatomic ,assign)NSInteger detail_id;

//查询参数
@property (nonatomic,copy) NSString *param;

- (void)loadData;

//绑定list
-(void)bindData:(NSMutableArray *)data;

@end
