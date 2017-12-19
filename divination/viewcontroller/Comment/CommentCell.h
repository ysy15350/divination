//
//  CommentCell.h
//  divination
//
//  Created by 杨世友 on 2017/12/14.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell

@property (nonatomic ,copy)UILabel *labelTitle;
@property (nonatomic ,copy)UILabel *labelDate;
@property (nonatomic ,copy)UILabel *labelContent;

@property (nonatomic ,assign)NSInteger index;

@property (nonatomic,strong) NSDictionary *itemData;

@end
