//
//  CSWSetVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWSetVC.h"
#import "TLSettingGroup.h"
#import "CSWUserDetailEditVC.h"
#import "TLChangeMobileVC.h"
#import "TLUserForgetPwdVC.h"
#import "TLChangeLoginNameVC.h"
#import "TLChangeNickNameVC.h"

#import "TLTabBar.h"

@interface CSWSetVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) TLSettingGroup *group;

@property (nonatomic, strong) UIButton *loginOutBtn;

@property (nonatomic, copy) NSString *cacheStr;

@property (nonatomic, strong) UITableView *mineTableView;

@end

@implementation CSWSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    UITableView *mineTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    mineTableView.delegate = self;
    mineTableView.dataSource = self;

    mineTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 1)];
    [self.view addSubview:mineTableView];
    
    [mineTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    mineTableView.rowHeight = 45;
    mineTableView.tableFooterView = self.loginOutBtn;
    
    _mineTableView = mineTableView;
    
    __weak typeof(self) weakSelf = self;
    //
    TLSettingModel *changeLoginName = [TLSettingModel new];
    changeLoginName.text = @"修改登录名";
    [changeLoginName setAction:^{
        
        TLChangeLoginNameVC *changeLoginNameVC = [TLChangeLoginNameVC new];
        
        [weakSelf.navigationController pushViewController:changeLoginNameVC animated:YES];
        
    }];
    
    //
    TLSettingModel *loginNameAndPwd = [TLSettingModel new];
    loginNameAndPwd.text = @"账号和密码";
    [loginNameAndPwd setAction:^{
        
        TLUserForgetPwdVC *forgetPwdVC = [[TLUserForgetPwdVC alloc] init];
        [weakSelf.navigationController pushViewController:forgetPwdVC animated:YES];
        
    }];
    
    //
    TLSettingModel *changePhone = [TLSettingModel new];
    changePhone.text = @"修改手机号";
    [changePhone setAction:^{
        
        TLChangeMobileVC *changeMobileVC = [[TLChangeMobileVC alloc] init];
        [weakSelf.navigationController pushViewController:changeMobileVC animated:YES];
    }];
    
    //
    TLSettingModel *userDetail = [TLSettingModel new];
    userDetail.text = @"个人资料";
    [userDetail setAction:^{
        
        CSWUserDetailEditVC *editVC = [[CSWUserDetailEditVC alloc] init];
        [weakSelf.navigationController pushViewController:editVC animated:YES];
    }];
    
    //
    TLSettingModel *clear = [TLSettingModel new];
    clear.text = @"清除缓存";
    [clear setAction:^{
        
        [self clearMemory];
    }];
    
    self.group = [TLSettingGroup new];
    self.group.items = @[changeLoginName,loginNameAndPwd,changePhone,userDetail,clear];
    

}

- (void)clearMemory {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[SDImageCache sharedImageCache] clearDisk];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            hud.mode = MBProgressHUDModeAnnularDeterminate;
            hud.label.text = @"清除中...";
            
        });
        
        float progress = 0.0f;
        
        while (progress < 1.0f) {
            
            progress += 0.02f;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                hud.progress = progress;
            });
            usleep(50000);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *image = [UIImage imageNamed:@"person_complete"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            
            imageView.frame = CGRectMake(0, 0, 35, 35);
            
            hud.customView = imageView;
            hud.mode = MBProgressHUDModeCustomView;
            hud.label.text = @"清除完成";
            
            self.cacheStr = @"0.00KB";
            //刷新某一行数据
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
            [_mineTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
            
            [hud hideAnimated:YES afterDelay:1];
        });
        
    });
    
}

#pragma mark- 退出登录
- (void)loginOut {

    UITabBarController *tbcController = self.tabBarController;
    
    //
    [self.navigationController popViewControllerAnimated:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        tbcController.selectedIndex = 0;
        
//        tbcController.tabBar
        TLTabBar *tabBar = (TLTabBar *)tbcController.tabBar;
        tabBar.selectedIdx = 0;
        
    });
    
    //去除alias
    [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];
    
    
}

- (UIButton *)loginOutBtn {

    if (!_loginOutBtn) {
        
        _loginOutBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        _loginOutBtn.backgroundColor = [UIColor whiteColor];
        [_loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_loginOutBtn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        _loginOutBtn.titleLabel.font = FONT(15);
        [_loginOutBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginOutBtn;

}


#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.group.items[indexPath.row].action) {
        
        self.group.items[indexPath.row].action();
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  return   self.group.items.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCellId"];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = FONT(15);
        cell.textLabel.textColor = [UIColor textColor];
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        cell.detailTextLabel.textColor = [UIColor textColor];
        cell.detailTextLabel.font = FONT(14);
        
    }
    
    cell.textLabel.text = self.group.items[indexPath.row].text;
    if ([cell.textLabel.text isEqualToString:@"清除缓存"]) {
        
        NSUInteger size = [[SDImageCache sharedImageCache] getSize];
        
        if (size < 1024*1024) {
            
            self.cacheStr = [NSString stringWithFormat:@"%.2fKB",size/(1024*1024.0)];
            
        } else if (size < 1024*1024*1024) {
            
            self.cacheStr = [NSString stringWithFormat:@"%.2fM",size/(1024*1024*1024.0)];
        }
        
        cell.detailTextLabel.text = self.cacheStr;

    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}

#pragma mark - UITableViewDelegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

@end
