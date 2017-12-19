//
//  Request+Normal.h
//  longkin
//
//  Created by 杨世友 on 15/11/1.
//  Copyright © 2015年 longkin. All rights reserved.
//

#import "Request.h"

//新建Object-c Class类，class Type选择,Category, Class选择Request
@interface Request (Normal)
-(Response *)requestByGet;
-(Response *)requestByPost;

@end
