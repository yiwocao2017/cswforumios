//
//  TLPlateChooseView.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/14.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLPlateChooseView.h"
#import "TLPlateChooseCell.h"
#import "CSWSmallPlateModel.h"

@interface TLPlateChooseView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *chooseCollectionView;
@property (nonatomic, strong) UIControl *bgCtrl;


@end


@implementation TLPlateChooseView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    
    if (self) {
        
        self.isShow = NO;
        [self addSubview:self.chooseCollectionView];
        self.backgroundColor = [UIColor whiteColor];
        self.chooseCollectionView.backgroundColor = [UIColor whiteColor];
        self.chooseCollectionView.frame = CGRectMake(0, 20, SCREEN_WIDTH, 160);
        
        //箭头表示
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        [self addSubview:arrowImageView];
        arrowImageView.image = [UIImage imageNamed:@"compose_arrow_up"];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.width.mas_equalTo(13);
            make.height.mas_equalTo(7);
            make.bottom.equalTo(self.mas_bottom).offset(-6);
            //            make.top.equalTo(self.chooseCollectionView.mas_bottom);
        }];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        
 
        
        
    }
    return self;
}

- (void)show {
    
    if (!self) {
        return;
    }
    self.isShow = YES;

    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    //mask
    self.bgCtrl = [[UIControl alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    self.bgCtrl.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.bgCtrl addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgCtrl];
    [self.bgCtrl addSubview:self];
    
//    [UIView animateWithDuration:0.25 animations:^{
//        
//        
//    }];

}

//-------//
- (void)remove:(UIControl *)ctrl {

    
    [ctrl removeFromSuperview];
}

- (void)dismiss {
    
    self.isShow = NO;
    [self.bgCtrl removeFromSuperview];

}

- (void)setPlateModelRoom:(NSArray<CSWSmallPlateModel *> *)plateModelRoom {

    //c此处不要copy,保持模型数据一致
//    _plateModelRoom = [plateModelRoom copy];
    _plateModelRoom = plateModelRoom;
    [self.chooseCollectionView reloadData];

}


#pragma mark- collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //取消上一个选中
    [self.plateModelRoom enumerateObjectsUsingBlock:^(CSWSmallPlateModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelected) {
            obj.isSelected = NO;
            *stop = YES;
        }
    }];
    
    //找出dangqing
    self.plateModelRoom[indexPath.row].isSelected = YES;
    if (self.choosePlate) {
        self.choosePlate(indexPath.row,self.plateModelRoom[indexPath.row]);
    }
    
    [self.bgCtrl removeFromSuperview];

}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {


    return YES;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    
    return self.plateModelRoom.count;

}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    TLPlateChooseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TLPlateChooseCell" forIndexPath:indexPath ];
    
    CSWSmallPlateModel *plate = self.plateModelRoom[indexPath.row];
    cell.titleLbl.text = plate.name;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[plate.pic convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
    if (plate.isSelected) {
        
        cell.titleLbl.textColor = [UIColor themeColor];
        
    } else {
        
        cell.titleLbl.textColor = [UIColor textColor];
        
    }
    return cell;

}


- (UICollectionView *)chooseCollectionView {
    
    if (!_chooseCollectionView) {
        
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_HEIGHT);
        
        //布局对象
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH/4.0, 80);
        
        //
        _chooseCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        _chooseCollectionView.delegate = self;
        _chooseCollectionView.backgroundColor = [UIColor whiteColor];
        _chooseCollectionView.dataSource = self;
        _chooseCollectionView.showsVerticalScrollIndicator = NO;
        
        [_chooseCollectionView registerClass:[TLPlateChooseCell class] forCellWithReuseIdentifier:@"TLPlateChooseCell"];
        
    }
    
    return _chooseCollectionView;
    
}


@end
