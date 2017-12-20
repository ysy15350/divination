//
//  OtherTableViewCell.m
//  divination
//
//  Created by 杨世友 on 2017/12/20.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import "OtherTableViewCell.h"
#import "UIColor+Hex.h"

@implementation OtherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

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
    
    int marginWidth=15;
    
    //分隔线
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(marginWidth, 44, kScreenWidth-marginWidth*2, 1)];
    line1.backgroundColor = [UIColor colorWithHexString:@"#dedde2"];
    [self.contentView addSubview:line1];
    
    
    return self;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int marginWidth=15;
    
    //----------------------第2排----------------------
    _labelTitle.frame = CGRectMake(marginWidth, 10, 75, 25);
    _labelTitle.font = [UIFont systemFontOfSize:16];
    //[UIFont fontWithName:@"Arial" size:12];
    _labelTitle.textColor = [UIColor colorWithHexString:@"#2e2b34"];
    _labelTitle.text = @"匿名のユーザー";
    _labelTitle.textAlignment = NSTextAlignmentLeft;
    
    
 
    if(_itemData){
        _labelTitle.text=_itemData.title;
       
        
        CGSize size = CGSizeMake(20,20); //设置一个行高上限
        NSDictionary *attribute = @{NSFontAttributeName: _labelTitle.font};
        CGSize labelsize = [_labelTitle.text boundingRectWithSize:size options:NSStringDrawingUsesDeviceMetrics attributes:attribute context:nil].size;
        //labelsize.height
        _labelTitle.frame = CGRectMake(marginWidth, 10, labelsize.width + 5, 25);// 系统的这个方法计算不是特别精确,所以要加3-5(不加的话,字符串长了以后label.frame.size.width会略小于字符串长度，导致文字显示不全)
        
        
        int labelDateMarginLeft=labelsize.width + 13+marginWidth;
        _labelContent.frame=CGRectMake(labelDateMarginLeft, 10, 100, 25);
        _labelContent.font = [UIFont systemFontOfSize:16];
        _labelContent.textColor = [UIColor colorWithHexString:@"#929292"];
        
        _labelContent.text = @"12月16日";
        
        
        _labelContent.textAlignment = NSTextAlignmentLeft;
        
        _labelContent.text = _itemData.descriptions;
        
    }
    
    
    

    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
