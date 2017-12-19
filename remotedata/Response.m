//
//  Response.m
//  longkin
//
//  Created by 杨世友 on 15/10/27.
//  Copyright © 2015年 longkin. All rights reserved.
//

#import "Response.h"

@interface Response()
@property (readwrite,nonatomic)  ResponseHead* head;//在h文件中定义为readonly，赋值需在m文件重写属性，指定为readwrite,以此保证私有方法能够设置，外部无法设置

@end

@implementation Response

-(ResponseHead *)head
{
    if(!_head)
        _head=[[ResponseHead alloc] init];
    return _head;
}


//-(NSDictionary *)body
//{
//    //惰性实例化，当body对象为空时，实例化body对象，保证在获取body对象是不为nil
//    if(!_body)
//        _body=[[NSDictionary alloc] init];
//    return _body;
//}

-(NSDictionary *)result
{
    //惰性实例化，当body对象为空时，实例化body对象，保证在获取body对象是不为nil
    if(!_result)
        _result=[[NSDictionary alloc] init];
    return _result;
}

-(void)dealloc
{
    NSLog(@"Response对象dealloc");
}

@end
