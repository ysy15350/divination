//
//  Comment.h
//  divination
//
//  Created by 杨世友 on 2017/12/16.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property(nonatomic ,copy)NSString *title;
@property(nonatomic ,copy)NSString *images;
@property (nonatomic ,assign)NSInteger like_a;
@property (nonatomic ,assign)NSInteger like_b;
@property (nonatomic ,assign)NSInteger like_c;
@property(nonatomic ,copy)NSString *tz_url;
@property(nonatomic ,copy)NSString *detail_url;
@property(nonatomic ,copy)NSString *descriptions;

@property(nonatomic ,copy)NSString *username;
@property(nonatomic ,copy)NSString *content;
@property (nonatomic ,assign)NSInteger create_time;
@property (nonatomic ,assign)NSInteger update_time;

@end
