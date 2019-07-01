//
//  SystemNoticeCell.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/19.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "SystemNoticeCell.h"

@interface SystemNoticeCell ()

@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *msgNameLbl;
@property (nonatomic,strong) UILabel *msgTimeLbl;
@property (nonatomic,strong) UILabel *msgContentLbl;

@property (nonatomic,strong) UIView *msgBgView;

@end

@implementation SystemNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //icon
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 32, 32)];
        self.iconImageView.image = [UIImage imageNamed:@"消息"];
        [self addSubview:self.iconImageView];
        
        //
        self.msgNameLbl = [UILabel labelWithFrame:CGRectMake( self.iconImageView.xx + 10, self.iconImageView.y, SCREEN_WIDTH - self.iconImageView.xx - 10 - 10 , 10)
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor clearColor]
                                             font:[UIFont secondFont]
                                        textColor:[UIColor colorWithHexString:@"#484848"]];
        [self addSubview:self.msgNameLbl];
        self.msgNameLbl.height = [[UIFont secondFont] lineHeight];
        
        //
        self.msgTimeLbl = [UILabel labelWithFrame:CGRectMake(self.msgNameLbl.x, self.msgNameLbl.yy + 5, self.msgNameLbl.width , 10)
                                     textAligment:NSTextAlignmentLeft
                                  backgroundColor:[UIColor clearColor]
                                             font:[UIFont thirdFont]
                                        textColor:[UIColor colorWithHexString:@"#999999"]];
        self.msgTimeLbl.height = [[UIFont thirdFont] lineHeight];
        [self addSubview:self.msgTimeLbl];
        
        //
        self.msgBgView = [[UIView alloc] initWithFrame:CGRectMake(self.msgNameLbl.x, self.msgTimeLbl.yy + 10, self.msgTimeLbl.width - 10, 100)];
        self.msgBgView.layer.cornerRadius = 5;
        self.msgBgView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        self.msgBgView.layer.masksToBounds = YES;
        [self addSubview:self.msgBgView];
        
        //
        self.msgContentLbl = [UILabel labelWithFrame:CGRectMake(10, 10, self.msgBgView.width - 20, self.msgBgView.height - 20)
                                        textAligment:NSTextAlignmentLeft
                                     backgroundColor:[UIColor clearColor]
                                                font:[UIFont fontWithName:@"PingFangSC-Regular" size:12]
                                           textColor:[UIColor colorWithHexString:@"#999999"]];
        self.msgContentLbl.numberOfLines = 0;
        [self.msgBgView addSubview:self.msgContentLbl];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 15, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        [self addSubview:line];
        
        
    }
    return self;
    
}

- (void)setNoticeInfoModel:(NoticeInfoModel *)noticeInfoModel {

    _noticeInfoModel = noticeInfoModel;
    
    self.msgNameLbl.text = _noticeInfoModel.smsTitle; //名称
    self.msgTimeLbl.text = [_noticeInfoModel.pushedDatetime convertToDetailDate];//更新时间
    self.msgContentLbl.text = [NSString filterHTML:_noticeInfoModel.smsContent]; //消息内容
    
    self.msgBgView.height = _noticeInfoModel.contentHeight + 20;
    self.msgContentLbl.height = _noticeInfoModel.contentHeight;
}

@end
