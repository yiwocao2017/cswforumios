//
//  DraftsTableViewCell.h
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraftsListModel.h"

@interface DraftsTableViewCell : UITableViewCell

@property (nonatomic, strong) PoseInfo *poseInfo;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *repeatBtn;

@end
