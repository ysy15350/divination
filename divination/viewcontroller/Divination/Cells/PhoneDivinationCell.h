//
//  PhoneDivinationCell.h
//  divination
//
//  Created by 杨世友 on 2017/12/16.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Divination.h"

@protocol PhoneDivinationSelectDelegate <NSObject>
- (void)detail:(NSInteger)index;
@end

@interface PhoneDivinationCell : UITableViewCell



@property (nonatomic ,copy)UILabel *labelTitle;
@property (nonatomic ,copy)UILabel *labelContent;
@property (nonatomic ,copy)UIImageView *img1;

@property (nonatomic ,assign)NSInteger index;
@property (nonatomic ,assign)id<PhoneDivinationSelectDelegate>delegate;

@property (nonatomic,strong) NSDictionary *itemData;

//初始化cell类
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
//设置数据
-(void)setData:(Divination *) data;

@end
