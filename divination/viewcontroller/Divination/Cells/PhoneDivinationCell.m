//
//  PhoneDivinationCell.m
//  divination
//
//  Created by 杨世友 on 2017/12/16.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import "PhoneDivinationCell.h"
#import "Config.h"
#import "Divination.h"
#import "UIColor+Hex.h"
#import "UIImageView+WebCache.h"
#import "UILabel+LabelHeight.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation PhoneDivinationCell


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}

- (void)initLayuot
{
  
    NSLog(@"initLayuotinitLayuotinitLayuotinitLayuotinitLayuot");
    
    _labelTitle = [[UILabel alloc] init];
    [self.contentView addSubview:_labelTitle];
    
    _labelContent = [[UILabel alloc] init];
    [self.contentView addSubview:_labelContent];
    
    _img1 = [[UIImageView alloc] init];
    [self.contentView addSubview:_img1];
    
}



-(void)setData:(Divination *)data{
    
    //获得当前cell高度
    CGRect frame = [self frame];
    
    
    int marginWidth=15;
    
    
    //----------------------第1排----------------------
    _labelTitle.frame = CGRectMake(marginWidth, marginWidth, kScreenWidth-(marginWidth*2), 30);
    _labelTitle.font = [UIFont systemFontOfSize:20];
    //[UIFont fontWithName:@"Arial" size:12];
    //_labelTitle.backgroundColor = [UIColor blueColor];
    _labelTitle.textColor = [UIColor colorWithHexString:@"#383057"];
    _labelTitle.text=@"ががとても評論";
    _labelTitle.textAlignment = NSTextAlignmentLeft;
    
    
    
    //----------------------第2排----------------------
    
    CGFloat y1=CGRectGetMaxY(_labelTitle.frame);
    
    
    _labelContent.frame = CGRectMake(marginWidth, y1+10, kScreenWidth-(marginWidth*2), 30);
    _labelContent.font = [UIFont systemFontOfSize:14];
    //[UIFont fontWithName:@"Arial" size:12];
    //_labelTitle.backgroundColor = [UIColor blueColor];
    _labelContent.textColor = [UIColor colorWithHexString:@"#3e3d42"];
    _labelContent.text=@"これは誰ががとても評論しているのですこれは誰ががとても評論しているのですこれは誰ががとても評論しているのです";
    
    //设置label的最大行数
    _labelContent.numberOfLines = 10;
    CGSize size = CGSizeMake(300, 1000);
    CGSize labelSize = [_labelContent.text sizeWithFont:_labelContent.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    _labelContent.frame = CGRectMake(_labelContent.frame.origin.x, _labelContent.frame.origin.y, labelSize.width, labelSize.height);
    
    
    _labelContent.textAlignment = NSTextAlignmentLeft;
    
    //_labelContent.backgroundColor = [UIColor yellowColor];
    
    
    CGFloat y2=CGRectGetMaxY(_labelContent.frame);
    
    //http://www.360vrdh.com:8080/api/file/imgGet?fid=84
    
    if(data&&data.images){
    
        _img1.frame=CGRectMake(marginWidth, y2+marginWidth, kScreenWidth-marginWidth*2, 100);
        NSString *imgName=[NSString stringWithFormat:@"tab1_img%ld",self.index+1];
        //_img1.image=[UIImage imageNamed:imgName];
        //http://www.360vrdh.com:8080/api/file/imgGet?fid=2
        
        NSString *url= [Config getServiceUrl];
        NSString *imageUrl=[[NSString alloc] init];
        if(data){
           
            //NSString *images= data.images;
            
            //imageUrl=[url stringByAppendingString:images];
            
            //NSLog(@"%@",imageUrl);
            
        }
        
        imageUrl=@"http://www.360vrdh.com:8080/api/file/imgGet?fid=84";// @"http://www.360vrdh.com:8080/api/file/imgGet?fid=2"
        
        //[_img1 sd_setImageWithURL:[NSURL URLWithString:imageUrl]
        //         placeholderImage:[UIImage imageNamed:imgName]];
        
        [_img1 sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:(SDWebImageRetryFailed) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            //_img1.frame = CGRectMake(marginWidth, y2+marginWidth, image.size.width, image.size.height);
            
            _img1.frame = CGRectMake(marginWidth, y2+marginWidth, (image.size.width*100)/image.size.height, 100);
           
        }];
    }else{
        _img1.frame = CGRectMake(marginWidth, y2+marginWidth, 0,0);
    }
    
     CGFloat y3=CGRectGetMaxY(_img1.frame);
    
    
    //计算出自适应的高度
    frame.size.height =y3==0?y2+20:y3+20;
    
    self.frame = frame;
}

- (void)buttonClicked:(UIButton *)btn
{
    [self.delegate detail:self.index];
}

@end
