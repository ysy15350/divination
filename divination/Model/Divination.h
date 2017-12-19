//
//  Divination.h
//  divination
//
//  Created by 杨世友 on 2017/12/15.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Divination : NSObject
@property (nonatomic ,assign)NSInteger id;
@property (nonatomic ,assign)NSInteger type;
@property(nonatomic ,copy)NSString *title;
@property(nonatomic ,copy)NSString *descriptions;
@property(nonatomic ,copy)NSString *images;
@property(nonatomic ,copy)NSString *detail_url;
@property(nonatomic ,copy)NSString *tz_url;
@property (nonatomic ,assign)NSInteger update_time;

@end
