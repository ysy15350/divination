//
//  RoadCell.h
//  MHRoadMobile
//
//  Created by k on 16/8/31.
//
//

#import <UIKit/UIKit.h>


@protocol CommentSelectDelegate <NSObject>
- (void)openWebView:(NSInteger)index;
- (void)detailComment:(NSInteger)index;
@end

@interface Tab2Cell_1 : UITableViewCell

@property (nonatomic ,copy)UIImageView *imgHead;
@property (nonatomic ,copy)UIButton *btnWebName;
@property (nonatomic ,copy)UILabel *labelTitle;
@property (nonatomic ,copy)UILabel *labelDate;
@property (nonatomic ,copy)UILabel *labelContent;
@property (nonatomic ,copy)UIButton *btnDetail;
@property (nonatomic ,assign)NSInteger index;
@property (nonatomic ,assign)id<CommentSelectDelegate>delegate;

@property (nonatomic,strong) NSDictionary *itemData;

@end
