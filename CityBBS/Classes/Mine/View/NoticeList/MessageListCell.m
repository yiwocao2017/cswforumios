//
//  MessageListCell.m
//  CityBBS
//
//  Created by 蔡卓越 on 2017/5/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "MessageListCell.h"
#import "MLLinkLabel.h"
#import "PYPhotosView.h"
#import "CSWTimeLineToolBar.h"
#import "CSWClickLinkLabel.h"
#import "CSWCommentAndLikeView.h"
#import "CSWUserPhotoView.h"
#import "CSWLinkLabel.h"
#import "TLEmoticonHelper.h"

@interface MessageListCell ()

@property (nonatomic, strong) CSWUserPhotoView *photoImageView;

@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *timeLbl;

//--//
@property (nonatomic, strong) UILabel *titleLbl; //标题lbl
@property (nonatomic, strong) CSWLinkLabel *contentLbl; //内容lbl
@property (nonatomic, strong) PYPhotosView *photosView; //内容lbl
@property (nonatomic, strong) UILabel *commentLbl; //评论内容lbl
@property (nonatomic, strong) UIView *bgView;   //帖子背景

//工具栏
@property (nonatomic, strong) CSWTimeLineToolBar *toolBar;

//底部评论背景 + 箭头
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) CSWCommentAndLikeView *commentAndLikeView;

@end

@implementation MessageListCell

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
        
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.photoImageView.mas_top).offset(10);
            make.left.mas_equalTo(self.photoImageView.mas_right).mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_lessThanOrEqualTo(15);
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
        
        CGFloat w = SCREEN_WIDTH - (self.photoImageView.xx + 10) - 15;

        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(self.photoImageView.xx + 10, self.photoImageView.yy, w, 50)];
        
        self.bgView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        self.bgView.layer.cornerRadius = 5;
        self.bgView.clipsToBounds = YES;
        
        [self.contentView addSubview:self.bgView];
        
        //帖子标题
        self.titleLbl = [UILabel labelWithFrame:CGRectMake(self.photoImageView.xx + 10, self.photoImageView.yy, w , 50)
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor whiteColor]
                                           font:layout.titleFont
                                      textColor:[UIColor themeColor]];
        self.titleLbl.numberOfLines = 0;
        [self.contentView addSubview:self.titleLbl];
        
        //内容
//        self.contentLbl = [[CSWLinkLabel alloc] initWithFrame:CGRectMake(self.titleLbl.x, self.titleLbl.yy + 7, w, 50)];
        self.contentLbl = [[CSWLinkLabel alloc] initWithFrame:CGRectMake(self.titleLbl.x, self.titleLbl.yy + 7, w, 50)];
        self.contentLbl.font = layout.contentFont;
        self.contentLbl.textColor = [UIColor textColor];
        self.contentLbl.numberOfLines = 0;
        self.contentLbl.lineHeightMultiple = 1.2;
        [self.contentView addSubview:self.contentLbl];
        self.contentLbl.backgroundColor = [UIColor whiteColor];
        
        //图片浏览--可能无
        self.photosView = [[PYPhotosView  alloc] init];
        [self.contentView addSubview:self.photosView];
        self.photosView.photoMargin = layout.photoMargin;
        self.photosView.photoHeight = layout.photoWidth;
        self.photosView.photoWidth = layout.photoWidth;
        
//        评论内容
        self.commentLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(14)
                                     textColor:[UIColor textColor]];
        [self.contentView addSubview:self.commentLbl];
        
        [self.commentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.contentLbl.mas_bottom).mas_equalTo(10);
            make.left.mas_equalTo(self.nameLbl.mas_left);
            make.right.mas_equalTo(-10);
            make.height.mas_lessThanOrEqualTo(15);
        }];
        
        //分享 --- 点赞 -- 评论
        self.toolBar = [[CSWTimeLineToolBar alloc] init];
        [self.contentView addSubview:self.toolBar];
        
//        //点赞和评论
        self.arrowImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.arrowImageView];
        self.arrowImageView.image = [UIImage imageNamed:@"timeline_article_arrow"];
        
        self.commentAndLikeView = [[CSWCommentAndLikeView alloc] init];
        [self.contentView addSubview:self.commentAndLikeView];
        
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

- (void)setLayoutItem:(CSWLayoutItem *)layoutItem {
    
    _layoutItem = layoutItem;
    
    //--//
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:[_layoutItem.article.photo convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
    self.nameLbl.text= _layoutItem.article.nickname;
    self.photoImageView.userId = _layoutItem.article.publisher;
    
    //
    self.timeLbl.text = [_layoutItem.article.publishDatetime convertToDetailDate];
    
    //1.title
    
    CGRect titleFrame = _layoutItem.titleFrame;
    
    titleFrame.origin.x += 10;
    titleFrame.origin.y += 10;
    titleFrame.size.width -= 20;
    
    self.titleLbl.frame = titleFrame;
    self.titleLbl.text = _layoutItem.article.title;
    self.titleLbl.backgroundColor = kClearColor;
    
    CGRect contentFrame = _layoutItem.contentFrame;
    
    contentFrame.origin.x += 10;
    contentFrame.origin.y += 10;
    
    //2.cocntent
    self.contentLbl.frame = contentFrame;
    self.contentLbl.attributedText = _layoutItem.contentAttributedString;
    self.contentLbl.backgroundColor = kClearColor;

    CGRect bgViewFrame = CGRectMake(_layoutItem.titleFrame.origin.x, _layoutItem.titleFrame.origin.y, _layoutItem.titleFrame.size.width, titleFrame.size.height + contentFrame.size.height + 20);
    //3.bgView
    self.bgView.frame = bgViewFrame;
    
    //3.图片浏览
    if (/*有图*/_layoutItem.isHasPhoto) {
        
        self.photosView.hidden = NO;
        self.photosView.frame = _layoutItem.phototsFrame;
        self.photosView.thumbnailUrls = _layoutItem.article.thumbnailUrls;
        self.photosView.originalUrls = _layoutItem.article.originalUrls;
        
    } else {
        
        
        self.photosView.hidden = YES;
        
    }
    
    //
    if (_layoutItem.type == CSWArticleLayoutTypeArticleDetail) {
        self.toolBar.hidden = YES;
        self.arrowImageView.hidden = YES;
        self.commentAndLikeView.hidden = YES;
        
        //评论内容
        
        CGRect commnetFrame = _layoutItem.comtentFrame;
        
        commnetFrame.origin.y = self.bgView.yy + 10;
        
        self.commentLbl.frame = commnetFrame;
        
        self.commentLbl.attributedText = [TLEmoticonHelper convertEmoticonStrToAttributedString:_layoutItem.article.plateName];
        ;
        
        return;
    }
    
    self.toolBar.hidden = NO;
    self.arrowImageView.hidden = NO;
    self.commentAndLikeView.hidden = NO;
    
    //工具栏----重要节点，分割作用
    
    CGRect toolBarFrame = _layoutItem.toolBarFrame;
    
    toolBarFrame.origin.y += 20;
    
    self.toolBar.frame = toolBarFrame;
    self.toolBar.layoutItem = _layoutItem;
    
    //先整体判断隐藏与否
    self.arrowImageView.hidden = !_layoutItem.isHasComment && !_layoutItem.isHasLike;
    self.commentAndLikeView.hidden = !_layoutItem.isHasComment && !_layoutItem.isHasLike;
    
    if (!_layoutItem.isHasLike && !_layoutItem.isHasComment) {
        
        return;
    }
    
    
    self.arrowImageView.frame = _layoutItem.arrowFrame;
    self.commentAndLikeView.frame= _layoutItem.bottomBgFrame;
    self.commentAndLikeView.layoutItem = _layoutItem;
    
}

@end
