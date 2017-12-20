//
//  ReportAlertView.m
//  divination
//
//  Created by 杨世友 on 2017/12/20.
//  Copyright © 2017年 ysy15350. All rights reserved.
//

#import "ReportAlertView.h"
#import "UIColor+Hex.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

///alertView  宽
#define AlertW 280
///各个栏目之间的距离
#define XLSpace 10.0

@interface ReportAlertView()
//弹窗
@property (nonatomic,retain) UIView *alertView;
//title
@property (nonatomic,retain) UILabel *titleLbl;
//内容
@property (nonatomic,retain) UILabel *msgLbl;

//取消按钮
@property (nonatomic,retain) UIButton *cancleBtn;

@end

@implementation ReportAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle
{
    if (self == [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        
        self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
        
        self.alertView = [[UIView alloc] init];
        self.alertView.backgroundColor = [UIColor whiteColor];
        self.alertView.layer.cornerRadius = 5.0;
        
        self.alertView.frame = CGRectMake(0, 0, AlertW, 300);
        self.alertView.layer.position = self.center;
        
       
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AlertW, 50)];
        topView.backgroundColor = [UIColor colorWithHexString:@"#312950"];
        
       
        
        
        [self.alertView addSubview:topView];
        
        
        
        NSString *title=@"通報しました";
        
        
        self.titleLbl = [self GetAdaptiveLable:CGRectMake(2*XLSpace, 2*XLSpace, AlertW-4*XLSpace, 20) AndText:title andIsTitle:YES];
        self.titleLbl.textAlignment = NSTextAlignmentCenter;
        
        [self.alertView addSubview:self.titleLbl];
        
        CGFloat titleW = self.titleLbl.bounds.size.width;
        CGFloat titleH = self.titleLbl.bounds.size.height;
        
        self.titleLbl.frame = CGRectMake((AlertW-titleW)/2, 2*XLSpace, titleW, titleH);
        
        
        
        NSString *message=@"通報が完了しました。\nご協力ありがとうございます。\n24時間以内に、確認して必要に応じて対応をさせていただきます。\n今後もより良いサービスを提供できよう努めてまいりますので、よろしくお願い致します。";
        
       
        self.msgLbl = [self GetAdaptiveLable:CGRectMake(XLSpace, CGRectGetMaxY(self.titleLbl.frame)+XLSpace, AlertW-2*XLSpace, 20) AndText:message andIsTitle:NO];
        self.msgLbl.textAlignment = NSTextAlignmentCenter;
        
        
        
        [self.alertView addSubview:self.msgLbl];
        
        
      
        self.cancleBtn=[[UIButton alloc] init];
        self.cancleBtn.frame = CGRectMake(AlertW-30,10, 20, 20);
        UIImage *image = [UIImage imageNamed:@"icon_close"];
        [self.cancleBtn setBackgroundImage:image forState:UIControlStateNormal];
        
        //[self.cancleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.cancleBtn.tag = 1;
        [self.cancleBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.alertView addSubview:self.cancleBtn];
        
        
        //计算高度
        CGFloat alertHeight = CGRectGetMaxY(self.msgLbl.frame)+10;
        self.alertView.frame = CGRectMake(0, 0, AlertW, alertHeight);
        self.alertView.layer.position = self.center;
        
        [self addSubview:self.alertView];
        
        
        
    }
    
    return self;
}

#pragma mark - 弹出 -
- (void)showXLAlertView
{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)creatShowAnimation
{
    self.alertView.layer.position = self.center;
    self.alertView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - 回调 -设置只有2  -- > 确定才回调
- (void)buttonEvent:(UIButton *)sender
{
    if (sender.tag == 2) {
        if (self.resultIndex) {
            self.resultIndex(sender.tag);
        }
    }
    [self removeFromSuperview];
}

-(UILabel *)GetAdaptiveLable:(CGRect)rect AndText:(NSString *)contentStr andIsTitle:(BOOL)isTitle
{
    UILabel *contentLbl = [[UILabel alloc] initWithFrame:rect];
    contentLbl.numberOfLines = 0;
    contentLbl.text = contentStr;
    contentLbl.textAlignment = NSTextAlignmentCenter;
    if (isTitle) {
        contentLbl.textColor=[UIColor whiteColor];
        contentLbl.font = [UIFont boldSystemFontOfSize:16.0];
    }else{
        contentLbl.font = [UIFont systemFontOfSize:14.0];
    }
    
    NSMutableAttributedString *mAttrStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
    NSMutableParagraphStyle *mParaStyle = [[NSMutableParagraphStyle alloc] init];
    mParaStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [mParaStyle setLineSpacing:3.0];
    [mAttrStr addAttribute:NSParagraphStyleAttributeName value:mParaStyle range:NSMakeRange(0,[contentStr length])];
    [contentLbl setAttributedText:mAttrStr];
    [contentLbl sizeToFit];
    
    return contentLbl;
}

-(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
