//
//  Tab1Cell.m
//  divination
//
//  Created by 杨世友 on 2017/12/13.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import "Tab1Cell.h"
#import "Config.h"
#import "IndexInfo.h"
#import "UIImageView+WebCache.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation Tab1Cell

-(void)setFrame:(CGRect)frame{
    
    //设置cell间距
    //frame.origin.x = 10;//这里间距为10，可以根据自己的情况调整
    //frame.size.width -= 2 * frame.origin.x;
    //frame.size.height -= 2 * frame.origin.x;
    
    
    self.layer.masksToBounds = YES;
    
    //设置圆角
    //self.layer.cornerRadius = 8.0;
    
    [super setFrame:frame];
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _img1 = [[UIImageView alloc] init];
    [self.contentView addSubview:_img1];
    _button=[[UIButton alloc] init];
    [self.contentView addSubview:_button];
    
    return self;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
   //https://github.com/rs/SDWebImage
    _img1.frame=CGRectMake(0, 10, kScreenWidth, self.contentView.bounds.size.height-10);
    NSString *imgName=[NSString stringWithFormat:@"tab1_img%ld",self.index+1];
    //_img1.image=[UIImage imageNamed:imgName];
    //http://www.360vrdh.com:8080/api/file/imgGet?fid=2
    
    NSString *url= [Config getServiceUrl];
    if(self.itemData){
        IndexInfo *indexInfo=(IndexInfo *)self.itemData;
    
        NSString *images= indexInfo.images;
        
        NSString *imageUrl=[url stringByAppendingString:images];
        
        NSLog(@"%@",imageUrl);
        
        //@"http://www.360vrdh.com:8080/api/file/imgGet?fid=2"
        
        [_img1 sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                     placeholderImage:[UIImage imageNamed:imgName]];
    }
    
    _button.frame=CGRectMake(0, 0, kScreenWidth, self.contentView.bounds.size.height);
   
    [_button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClicked:(UIButton *)btn
{
    //[self.delegate removedRoad:self.index];
    [self.listener onItemClick:self.index];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
