//
//  RoadCell.h
//  MHRoadMobile
//
//  Created by k on 16/8/31.
//
//

#import <UIKit/UIKit.h>


@protocol LoveDivinationSelectDelegate <NSObject>
- (void)detail:(NSInteger)index;
@end

@interface LoveDivinationCell : UITableViewCell

@property (nonatomic ,copy)UIImageView *imgHead;
@property (nonatomic ,copy)UILabel *labelTitle;
@property (nonatomic ,copy)UILabel *labelContent;
@property (nonatomic ,copy)UIButton *btnDetail;
@property (nonatomic ,assign)NSInteger index;
@property (nonatomic ,assign)id<LoveDivinationSelectDelegate>delegate;

@property (nonatomic,strong) NSDictionary *itemData;

@end
