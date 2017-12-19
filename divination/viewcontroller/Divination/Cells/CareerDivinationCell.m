//
//  RoadCell.m
//  MHRoadMobile
//
//  Created by k on 16/8/31.
//
//

#import "CareerDivinationCell.h"
#import "Divination.h"
#import "Config.h"
#import "UIColor+Hex.h"
#import "UIImageView+WebCache.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@implementation CareerDivinationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _imgHead = [[UIImageView alloc] init];
    [self.contentView addSubview:_imgHead];
    
    _labelTitle = [[UILabel alloc] init];
    [self.contentView addSubview:_labelTitle];
    
    _labelContent = [[UILabel alloc] init];
    [self.contentView addSubview:_labelContent];
    
    _btnDetail = [[UIButton alloc] init];
    [self.contentView addSubview:_btnDetail];
    
    
    return self;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int marginWidth=15;
    
    _imgHead.frame = CGRectMake(marginWidth,marginWidth, 90, 90);
    _imgHead.image=[UIImage imageNamed:@"tab1_item_test"];
    
    //设置圆角
    _imgHead.layer.masksToBounds = YES;
    _imgHead.layer.cornerRadius = 5.0;
    
    Divination *divination=nil;
    
    NSString *url= [Config getServiceUrl];
    if(self.itemData){
        divination=(Divination *)self.itemData;
        
        NSString *images= divination.images;
        
        NSString *imageUrl=[url stringByAppendingString:images];
        
        NSLog(@"%@",imageUrl);
        
        //@"http://www.360vrdh.com:8080/api/file/imgGet?fid=2"
        
        [_imgHead sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                    placeholderImage:[UIImage imageNamed:@"tab1_item_test"]];
    }
    
    
    
    //----------------------第1排----------------------
    _labelTitle.frame = CGRectMake(marginWidth+90+10, marginWidth, kScreenWidth-(marginWidth+90+10+10), 15);
    _labelTitle.font = [UIFont systemFontOfSize:16];
    //[UIFont fontWithName:@"Arial" size:12];
    _labelTitle.textColor = [UIColor colorWithHexString:@"#2e2b34"];
    if(divination)
        _labelTitle.text = divination.title;//@"匿名のユーザー";
    _labelTitle.textAlignment = NSTextAlignmentLeft;
    
    
    
    //----------------------第2排----------------------
    
    CGFloat y1=CGRectGetMaxY(_labelTitle.frame);
    
    
    _labelContent.frame=CGRectMake(marginWidth+90+10, y1, kScreenWidth-(marginWidth+90+10+10), 40);
    _labelContent.numberOfLines=2;
    _labelContent.font = [UIFont systemFontOfSize:12];
    _labelContent.textColor = [UIColor colorWithHexString:@"#555555"];
    if(divination)
        _labelContent.text =divination.descriptions;// @"これは誰ががとても評論しているのですこれは誰ががとても評論しているのですこれは誰ががとても評論しているのです";
    _labelContent.textAlignment = NSTextAlignmentLeft;
    
    //----------------------第4排----------------------
    
    int btnDetailWidth=kScreenWidth-marginWidth*2-90-10-10;
    
    CGFloat y2=CGRectGetMaxY(_imgHead.frame);
    
    _btnDetail.frame = CGRectMake(marginWidth+90+10, y2-35, btnDetailWidth, 35);
    _btnDetail.titleLabel.font = [UIFont systemFontOfSize:12];
    _btnDetail.backgroundColor=[UIColor colorWithHexString:@"#9c6cb6"];
    [_btnDetail setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [_btnDetail setTitle:@"無料鑑定する" forState:UIControlStateNormal];
    //设置圆角
    _btnDetail.layer.masksToBounds = YES;
    _btnDetail.layer.cornerRadius = 2.0;
    
    [_btnDetail addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)buttonClicked:(UIButton *)btn
{
    [self.delegate detail:self.index];
}

@end
