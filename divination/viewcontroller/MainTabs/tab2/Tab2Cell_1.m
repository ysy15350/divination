//
//  RoadCell.m
//  MHRoadMobile
//
//  Created by k on 16/8/31.
//
//

#import "Tab2Cell_1.h"
#import "Config.h"
#import "Divination.h"
#import "UIColor+Hex.h"
#import "SysFunction.h"
#import "UIImageView+WebCache.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@implementation Tab2Cell_1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _imgHead = [[UIImageView alloc] init];
    [self.contentView addSubview:_imgHead];
    
    _btnWebName = [[UIButton alloc] init];
    [self.contentView addSubview:_btnWebName];
    
    _labelTitle = [[UILabel alloc] init];
    [self.contentView addSubview:_labelTitle];
    
    _labelDate = [[UILabel alloc] init];
    [self.contentView addSubview:_labelDate];
    
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
    
    _imgHead.frame = CGRectMake(marginWidth,10, 35, 35);
    //_imgHead.image=[UIImage imageNamed:@"tab1_item_test"];
    
    //设置圆角
    _imgHead.layer.masksToBounds = YES;
    _imgHead.layer.cornerRadius = 5.0;
    
    
    Divination *divination=nil;
    
    NSString *url= [Config getServiceUrl];
    if(self.itemData){
        
        if([self.itemData isKindOfClass:[Divination class]]){
            
            divination=(Divination *)self.itemData;
            
            if(divination&&divination.type!=1){
            
                NSString *images= divination.images;
                
                NSString *imageUrl=[url stringByAppendingString:images];
                
                NSLog(@"%@",imageUrl);
                
                //@"http://www.360vrdh.com:8080/api/file/imgGet?fid=2"
                
                [_imgHead sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                            placeholderImage:[UIImage imageNamed:@"tab1_item_test"]];
            }
            
            //------------------------
            

            _btnWebName.frame = CGRectMake(60, 10, kScreenWidth  - 75, 35);
            _btnWebName.titleLabel.font = [UIFont systemFontOfSize:12];
            _btnWebName.backgroundColor=[UIColor colorWithHexString:@"#9c6cb6"];
            [_btnWebName setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
            if(divination)
                [_btnWebName setTitle:divination.title forState:UIControlStateNormal];
            //[_btnWebName setTitle:@"電話占い" forState:UIControlStateNormal];
           
            //设置圆角
            _btnWebName.layer.masksToBounds = YES;
            _btnWebName.layer.cornerRadius = 5.0;
            
            _btnWebName.tag=400;
            
            [_btnWebName addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            //----------------------第2排----------------------
            _labelTitle.frame = CGRectMake(marginWidth, 50, 75, 25);
            _labelTitle.font = [UIFont systemFontOfSize:16];
            //[UIFont fontWithName:@"Arial" size:12];
            _labelTitle.textColor = [UIColor colorWithHexString:@"#2e2b34"];
            //_labelTitle.text = @"匿名のユーザー";
            _labelTitle.textAlignment = NSTextAlignmentLeft;
            
            CGSize size = CGSizeMake(20,20); //设置一个行高上限
            NSDictionary *attribute = @{NSFontAttributeName: _labelTitle.font};
            CGSize labelsize = [_labelTitle.text boundingRectWithSize:size options:NSStringDrawingUsesDeviceMetrics attributes:attribute context:nil].size;
            //labelsize.height
            _labelTitle.frame = CGRectMake(marginWidth, 50, labelsize.width + 5, 25);// 系统的这个方法计算不是特别精确,所以要加3-5(不加的话,字符串长了以后label.frame.size.width会略小于字符串长度，导致文字显示不全)
            
            int labelDateMarginLeft=labelsize.width + 13+marginWidth;
            _labelDate.frame=CGRectMake(labelDateMarginLeft, 50, 75, 25);
            _labelDate.font = [UIFont systemFontOfSize:16];
            _labelDate.textColor = [UIColor colorWithHexString:@"#929292"];
            //_labelDate.text = @"12月16日";
            _labelDate.textAlignment = NSTextAlignmentLeft;
            if(divination){
                NSInteger update_time=divination.update_time;
                
                if(update_time>0){
                    _labelDate.text=[SysFunction getDateStringOfTimeStamp:update_time withFormat:@"MM月dd日"];
                }
            }
            
            //----------------------第3排----------------------
            
            _labelContent.frame=CGRectMake(marginWidth, 75, kScreenWidth-(marginWidth*2), 60);
            _labelContent.numberOfLines=3;
            _labelContent.font = [UIFont systemFontOfSize:16];
            _labelContent.textColor = [UIColor colorWithHexString:@"#555555"];
            if(divination)
                _labelContent.text =divination.descriptions;// @"これは誰ががとても評論しているのですこれは誰ががとても評論しているのですこれは誰ががとても評論しているのです";
            _labelContent.textAlignment = NSTextAlignmentLeft;
            
            //----------------------第4排----------------------
            
            int btnDetailWidth=120;
            
            _btnDetail.frame = CGRectMake(kScreenWidth-btnDetailWidth-marginWidth, 140, btnDetailWidth, 25);
            _btnDetail.titleLabel.font = [UIFont systemFontOfSize:16];
            _btnDetail.backgroundColor=[UIColor colorWithHexString:@"#ffcc00"];
            [_btnDetail setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
            [_btnDetail setTitle:@"詳しく見る＞＞" forState:UIControlStateNormal];
            //设置圆角
            _btnDetail.layer.masksToBounds = YES;
            _btnDetail.layer.cornerRadius = 2.0;
            
            _btnDetail.tag=401;
            
            [_btnDetail addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
}

- (void)buttonClicked:(UIButton *)btn
{
    switch (btn.tag) {
        case 400:
        {
            NSLog(@"1");
            [self.delegate openWebView:self.index];
            break;
        }
        case 401:
            NSLog(@"2");
            [self.delegate detailComment:self.index];
            break;
    }
    
}

@end
