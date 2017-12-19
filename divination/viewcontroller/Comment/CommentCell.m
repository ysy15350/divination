//
//  CommentCell.m
//  divination
//
//  Created by 杨世友 on 2017/12/14.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import "CommentCell.h"
#import "Comment.h"
#import "SysFunction.h"
#import "UIColor+Hex.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //_imgHead = [[UIImageView alloc] init];
    //[self.contentView addSubview:_imgHead];
    
    _labelTitle = [[UILabel alloc] init];
    [self.contentView addSubview:_labelTitle];
    
    _labelDate = [[UILabel alloc] init];
    [self.contentView addSubview:_labelDate];
    
    _labelContent = [[UILabel alloc] init];
    [self.contentView addSubview:_labelContent];
    
    
    
    
    return self;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int marginWidth=15;
    
    if(self.itemData){
        Comment *comment=(Comment *)self.itemData;
        
            if(comment.ad_status==0){
            
                //----------------------第2排----------------------
                _labelTitle.frame = CGRectMake(marginWidth, 10, 75, 25);
                _labelTitle.font = [UIFont systemFontOfSize:16];
                //[UIFont fontWithName:@"Arial" size:12];
                _labelTitle.textColor = [UIColor colorWithHexString:@"#2e2b34"];
                _labelTitle.text = comment.username;//@"匿名のユーザー";
                _labelTitle.textAlignment = NSTextAlignmentLeft;
                
                CGSize size = CGSizeMake(20,20); //设置一个行高上限
                NSDictionary *attribute = @{NSFontAttributeName: _labelTitle.font};
                CGSize labelsize = [_labelTitle.text boundingRectWithSize:size options:NSStringDrawingUsesDeviceMetrics attributes:attribute context:nil].size;
                //labelsize.height
                _labelTitle.frame = CGRectMake(marginWidth, 10, labelsize.width + 5, 25);// 系统的这个方法计算不是特别精确,所以要加3-5(不加的话,字符串长了以后label.frame.size.width会略小于字符串长度，导致文字显示不全)
                
               NSInteger create_time= comment.create_time;
                
                int labelDateMarginLeft=labelsize.width + 13+marginWidth;
                _labelDate.frame=CGRectMake(labelDateMarginLeft, 10, 100, 25);
                _labelDate.font = [UIFont systemFontOfSize:16];
                _labelDate.textColor = [UIColor colorWithHexString:@"#929292"];
                
                    _labelDate.text = [SysFunction getDateStringOfTimeStamp:create_time withFormat:@"MM-dd HH:mm"];;//@"12月16日";
                
               
                _labelDate.textAlignment = NSTextAlignmentLeft;
                
                //----------------------第3排----------------------
                
                _labelContent.frame=CGRectMake(marginWidth, 25+10, kScreenWidth-(marginWidth*2), 60);
                _labelContent.numberOfLines=3;
                _labelContent.font = [UIFont systemFontOfSize:16];
                _labelContent.textColor = [UIColor colorWithHexString:@"#555555"];
                _labelContent.text = comment.content;//@"これはががとても評論しているのですこれは誰ががとても評論しているのでこれはががとても評論しているのです";
                _labelContent.textAlignment = NSTextAlignmentLeft;
             
            }
            else if(comment.ad_status==1){
                //_labelTitle.text=@"";
                _labelDate.text=@"";
                //_labelContent.text=@"";
            }
    }
    
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
