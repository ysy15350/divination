//
//  CommentCell.h
//  divination
//
//  Created by 杨世友 on 2017/12/14.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OnItemClickListener <NSObject>

- (void)onItemClick:(NSInteger)index;

- (void)onItemDeleteClick:(NSInteger)index;

- (void)onItemReportClick:(NSInteger)index;

@end

@interface CommentCell : UITableViewCell

@property (nonatomic ,copy)UILabel *labelTitle;
@property (nonatomic ,copy)UILabel *labelDate;
@property (nonatomic ,copy)UILabel *labelContent;
@property (nonatomic ,copy)UIButton *btnDelete;//删除
@property (nonatomic ,copy)UIButton *btnReport;//举报


@property (nonatomic ,assign)NSInteger index;

@property (nonatomic,strong) NSDictionary *itemData;

@property (nonatomic ,assign)id<OnItemClickListener>listener;

@end
