//
//  GNQueue.h
//  divination
//
//  Created by 杨世友 on 2017/12/18.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GNQueue : NSObject
{
    NSMutableArray *queue;
    int maxSize;
}

- (id)initWithSize:(int)maxSize;
- (id)dequeue;
- (void)enqueue:(id)anObject ;
- (int)count;

@end
