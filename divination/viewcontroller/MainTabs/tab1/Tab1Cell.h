//
//  Tab1Cell.h
//  divination
//
//  Created by 杨世友 on 2017/12/13.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OnItemClickListener <NSObject>

- (void)onItemClick:(NSInteger)index;

@end

@interface Tab1Cell : UITableViewCell

@property (nonatomic ,copy)UIButton *button;
@property (nonatomic ,copy)UIImageView *img1;
@property (nonatomic ,assign)NSInteger index;
@property (nonatomic ,assign)id<OnItemClickListener>listener;

@property (nonatomic,strong) NSDictionary *itemData;

@end
