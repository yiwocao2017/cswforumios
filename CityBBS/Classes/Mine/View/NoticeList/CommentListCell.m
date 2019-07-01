//
//  CommentListCell.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CommentListCell.h"
#import "MLLinkLabel.h"
#import "PYPhotosView.h"
#import "CSWTimeLineToolBar.h"
#import "CSWClickLinkLabel.h"
#import "CSWCommentAndLikeView.h"
#import "CSWUserPhotoView.h"
#import "CSWLinkLabel.h"

@interface CommentListCell ()

@property (nonatomic, strong) CSWUserPhotoView *photoImageView;

@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UILabel *plateLbl;

//--//
@property (nonatomic, strong) UILabel *titleLbl; //标题lbl
@property (nonatomic, strong) CSWLinkLabel *contentLbl; //内容lbl
@property (nonatomic, strong) PYPhotosView *photosView; //内容lbl

@end

@implementation CommentListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //
        self.photoImageView = [[CSWUserPhotoView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
        [self.contentView addSubview:self.photoImageView];
        self.photoImageView.layer.cornerRadius = 25;
        self.photoImageView.layer.masksToBounds = YES;
        self.photoImageView.backgroundColor = [UIColor clearColor];
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;

        //名称
        self.nameLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(14)
                                     textColor:[UIColor textColor]];
        [self.contentView addSubview:self.nameLbl];
        
        //来自板块
        self.plateLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentRight
                                backgroundColor:[UIColor whiteColor]
                                           font:FONT(13)
                                      textColor:[UIColor themeColor]];
        [self.contentView addSubview:self.plateLbl];
        
        //
        
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.photoImageView.mas_top).offset(10);
            make.left.equalTo(self.photoImageView.mas_right).offset(10);
            make.right.lessThanOrEqualTo(self.plateLbl.mas_left);
            
        }];
        
        [self.plateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.greaterThanOrEqualTo(self.nameLbl.mas_right);
            make.top.equalTo(self.nameLbl.mas_top);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            
        }];
        
        //--//
        //时间
        self.timeLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(10)
                                     textColor:[UIColor colorWithHexString:@"#b4b4b4"]];
        [self.contentView addSubview:self.timeLbl];
        
        [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.nameLbl.mas_left);
            make.top.equalTo(self.nameLbl.mas_bottom).offset(3);
            make.right.lessThanOrEqualTo(self.contentView.mas_right);
            
        }];
        
        //--------头部以下-----------//
        CSWLayoutHelper *layout = [CSWLayoutHelper helper];
        
        
        //帖子标题
        CGFloat w = SCREEN_WIDTH - (self.photoImageView.xx + 10) - 15;
        self.titleLbl = [UILabel labelWithFrame:CGRectMake(self.photoImageView.xx + 10, self.photoImageView.yy, w , 50)
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor colorWithHexString:@"eeeeee"]
                                           font:layout.titleFont
                                      textColor:[UIColor themeColor]];
        self.titleLbl.layer.cornerRadius = 5;
        self.titleLbl.clipsToBounds = YES;
        self.titleLbl.numberOfLines = 0;
        
        [self.contentView addSubview:self.titleLbl];
        
        //内容
        self.contentLbl = [[CSWLinkLabel alloc] initWithFrame:CGRectMake(self.titleLbl.x, self.titleLbl.yy + 7, w, 20)];
        self.contentLbl.font = layout.contentFont;
        self.contentLbl.textColor = [UIColor textColor];
//        self.contentLbl.text = @"赞了你的帖子";
        self.contentLbl.numberOfLines = 0;
        self.contentLbl.lineHeightMultiple = 1.2;
        [self.contentView addSubview:self.contentLbl];
        self.contentLbl.backgroundColor = [UIColor whiteColor];
        
        //底线
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(@(LINE_HEIGHT));
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }
    
    return self;
    
}


#pragma mark- linkLableDelegate
- (void)didClickLink:(MLLink*)link linkText:(NSString*)linkText linkLabel:(MLLinkLabel*)linkLabel {
    
    
}

- (void)setCommontInfo:(CommontInfo *)commontInfo {

    _commontInfo = commontInfo;
    
    Post *post = _commontInfo.post;
    
    //--//
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:[post.pic convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
    self.photoImageView.userId = _commontInfo.commer;
    
    self.nameLbl.text= _commontInfo.nickname;
    
    self.timeLbl.text = [_commontInfo.commDatetime convertToDetailDate];
    
    //1.title
    
    self.titleLbl.text = [NSString stringWithFormat:@"  标题：%@", post.title];
    
    self.contentLbl.text = _commontInfo.content;
    
}

@end
