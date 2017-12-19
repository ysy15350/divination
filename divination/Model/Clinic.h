//
//  Clinic.h
//  divination
//
//  Created by 杨世友 on 2017/12/16.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Clinic : NSObject

@property (nonatomic ,assign)NSInteger id;
@property(nonatomic ,copy)NSString *title;
@property(nonatomic ,copy)NSString *descriptions;
@property(nonatomic ,copy)NSString *content;
@property(nonatomic ,copy)NSString *images;

@end
