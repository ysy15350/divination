//
//  RoadCell.h
//  MHRoadMobile
//
//  Created by k on 16/8/31.
//
//

#import <UIKit/UIKit.h>


@protocol CareerDivinationSelectDelegate <NSObject>
- (void)detail:(NSInteger)index;
@end

@interface CareerDivinationCell : UITableViewCell

@property (nonatomic ,copy)UIImageView *imgHead;
@property (nonatomic ,copy)UILabel *labelTitle;
@property (nonatomic ,copy)UILabel *labelContent;
@property (nonatomic ,copy)UIButton *btnDetail;
@property (nonatomic ,assign)NSInteger index;
@property (nonatomic ,assign)id<CareerDivinationSelectDelegate>delegate;

@property (nonatomic,strong) NSDictionary *itemData;

@end
