//
//  CSWCommentCell.m
//  CityBBS
//
//  Created by  tianlei on 2017/4/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWCommentCell.h"
#import "CSWLayoutHelper.h"
#import "CSWLinkLabel.h"
#import "CSWUserPhotoView.h"

@interface CSWCommentCell()

@property (nonatomic, strong) CSWUserPhotoView *photoImageView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) CSWLinkLabel *commentContentLbl;

@end

@implementation CSWCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        //
        self.photoImageView = [[CSWUserPhotoView alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
        [self.contentView addSubview:self.photoImageView];
        self.photoImageView.layer.cornerRadius = 20;
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
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.photoImageView.mas_top).offset(6);
            make.left.equalTo(self.photoImageView.mas_right).offset(10);
//            make.right.lessThanOrEqualTo(self.contentView.mas_left).offset(10);
            
        }];
        

        //时间
        self.timeLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(12)
                                     textColor:[UIColor colorWithHexString:@"#b4b4b4"]];
        [self.contentView addSubview:self.timeLbl];
        
        [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.nameLbl.mas_left);
            make.top.equalTo(self.photoImageView.mas_centerY).offset(5);
            make.right.lessThanOrEqualTo(self.contentView.mas_right);
            
        }];
        
        //
//        self.commentContentLbl = [UILabel labelWithFrame:CGRectZero
//                                            textAligment:NSTextAlignmentLeft backgroundColor:[UIColor whiteColor]
//                                                    font:[CSWLayoutHelper helper].contentFont
//                                               textColor:[UIColor textColor]];
//        [self.contentView addSubview:self.commentContentLbl];
//        self.commentContentLbl.numberOfLines = 0;
        
        self.commentContentLbl = [[CSWLinkLabel alloc] initWithFrame:CGRectZero];
        self.commentContentLbl.font = [CSWLayoutHelper helper].contentFont;
        self.commentContentLbl.textColor = [UIColor textColor];
        self.commentContentLbl.numberOfLines = 0;
        [self.contentView addSubview:self.commentContentLbl];

        
        //
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lineColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLbl.mas_left);
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(LINE_HEIGHT);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        //
    }
    
    return self;

}


- (void)setCommentLayoutItem:(CSWCommentLayoutItem *)commentLayoutItem {

    _commentLayoutItem = commentLayoutItem;
    
    //
    self.photoImageView.userId = _commentLayoutItem.commentModel.commentUserId;
    
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:[_commentLayoutItem.commentModel.photo convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
    
    //
    self.nameLbl.text = _commentLayoutItem.commentModel.commentUserNickname;
    
    //
    self.timeLbl.text = [_commentLayoutItem.commentModel.commentDatetime convertToTimelineDate];

    //
    self.commentContentLbl.frame = _commentLayoutItem.commentFrame;
    self.commentContentLbl.attributedText = _commentLayoutItem.commentAttrStr;
    
}




@end
