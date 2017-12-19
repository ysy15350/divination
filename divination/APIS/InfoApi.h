//
//  InfoApi.h
//  divination
//
//  Created by 杨世友 on 2017/12/15.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoApi : NSObject

//-(void)m_login_in:(NSString *)username withPassword:(NSString *)password complete:(void(^)(id result, NSError *error))block;

//首页 三张 图片接口
-(void)index_infoWithComplete:(void(^)(id result, NSError *error))block;

//文章列表接口
-(void)lists:(NSInteger) type page:(NSInteger) page num:(NSInteger) num complete:(void(^)(id result, NSError *error))block;

//评论列表详情接口
-(void)details:(NSInteger) detail_id complete:(void(^)(id result, NSError *error))block;

//提交评论
-(void)add_comment:(NSInteger) detail_id identification:(NSString *)identification username:(NSString *)username content:(NSString *)content complete:(void(^)(id result, NSError *error))block;

//诊断首页
-(void)clinicComplete:(void(^)(id result, NSError *error))block;

//诊断详情
-(void)clinic_detail:(NSInteger) detail_id complete:(void(^)(id result, NSError *error))block;

//点后占卜详情接口
-(void)tel_detail:(NSInteger) detail_id complete:(void(^)(id result, NSError *error))block;


@end
