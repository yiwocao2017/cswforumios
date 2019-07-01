//
//  DraftsTableViewCell.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "DraftsTableViewCell.h"
#import "TLEmoticonHelper.h"

@interface DraftsTableViewCell ()

@property (nonatomic, strong) NSAttributedString *contentAttributedString;

@end

@implementation DraftsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    _repeatBtn.layer.cornerRadius = 3;
    _repeatBtn.clipsToBounds = YES;
}

- (void)setPoseInfo:(PoseInfo *)poseInfo {

    _poseInfo = poseInfo;
    
    NSString *timeStr = [NSString stringWithTimeString:poseInfo.publishDatetime timeFormatter:@"MMM dd, yyyy hh:mm:ss aa" fotmatter:@"yyyy.MM.dd hh:mm"];
    
    _timeLabel.text = [NSString stringWithFormat:@"存稿时间：%@", timeStr];
    
    _titleLabel.text = [NSString stringWithFormat:@"标题：%@", poseInfo.title];
    
    self.contentAttributedString = [TLEmoticonHelper convertEmoticonStrToAttributedString:[NSString stringWithFormat:@"内容：%@", poseInfo.content]];
    
    _contentLabel.attributedText = self.contentAttributedString;
}

@end
