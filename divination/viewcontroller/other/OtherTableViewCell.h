//
//  OtherTableViewCell.h
//  divination
//
//  Created by 杨世友 on 2017/12/20.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Divination.h"

@protocol OnItemClickListener <NSObject>

- (void)onItemClick:(NSInteger)index;

@end

@interface OtherTableViewCell : UITableViewCell

@property (nonatomic ,copy)UILabel *labelTitle;
@property (nonatomic ,copy)UILabel *labelDate;
@property (nonatomic ,copy)UILabel *labelContent;

@property (nonatomic ,assign)NSInteger index;

@property (nonatomic,strong) Divination *itemData;

@property (nonatomic ,assign)id<OnItemClickListener>listener;

@end
