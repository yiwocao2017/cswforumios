//
//  CSWUserDetailEditVC.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CSWUserDetailEditVC.h"
#import "CSWUserEditCell.h"
#import "CSWUserEditModel.h"
#import "TLImagePicker.h"
#import "TLDatePicker.h"
#import "CSWEditVC.h"
#import "TLTextView.h"
#import "QNUploadManager.h"
#import "TLUploadManager.h"
#import "QNResponseInfo.h"
#import "QNConfiguration.h"


@interface CSWUserDetailEditVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) NSArray <CSWUserEditModel *>*models;
@property (nonatomic, strong) TLImagePicker *imgPicker;
@property (nonatomic, strong) UITableView *editTableView;
//@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) TLDatePicker *datePicker;
@property (nonatomic, strong) TLTextView *textView;

@end

@implementation CSWUserDetailEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑资料";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    
    UITableView *editTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.editTableView = editTableView;
    editTableView.delegate = self;
    editTableView.dataSource = self;
    editTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    editTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:editTableView];
    
    [editTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    editTableView.tableFooterView = self.textView;
    //
    CSWUserEditModel *photoModel = [CSWUserEditModel new];
    photoModel.title = @"头像";
    if ([TLUser user].userExt.photo) {
        
        photoModel.url = [[TLUser user].userExt.photo convertImageUrl];
 
    } else {
        
        photoModel.url = @"没有头像";

    
    }
    
    //昵称
    CSWUserEditModel *nickNameModel = [CSWUserEditModel new];
    nickNameModel.title = @"昵称";
    nickNameModel.content = [TLUser user].nickname ;
    
    //生日
    CSWUserEditModel *birthdayModel = [CSWUserEditModel new];
    birthdayModel.title = @"生日";
    birthdayModel.content =  [TLUser user].userExt.birthday ? [TLUser user].userExt.birthday : @"请选择生日";
    
    //性别
    CSWUserEditModel *sexModel = [CSWUserEditModel new];
    sexModel.title = @"性别";
    if ([TLUser user].userExt.gender) {
        
        sexModel.content = [[TLUser user].userExt.gender isEqualToString:@"1"] ? @"男" : @"女";
        
    } else {
        
        sexModel.content = @"请选择性别";

    
    }
    
    //昵称
    CSWUserEditModel *emailModel = [CSWUserEditModel new];
    emailModel.title = @"邮箱";
    emailModel.content =[TLUser user].userExt.email ? : @"请填写邮箱";
    
    //自我介绍
    if ([TLUser user].userExt.introduce) {
        self.textView.text = [TLUser user].userExt.introduce;
    }
    
    
    
    self.models = @[photoModel,nickNameModel,birthdayModel,sexModel,emailModel];
    
    
    __weak typeof(self) weakSelf = self;
    [self.imgPicker setPickFinish:^(NSDictionary * info, UIImage * img) {
        
        //图片上传
        TLNetworking *getUploadToken = [TLNetworking new];
        getUploadToken.showView = weakSelf.view;
        getUploadToken.code = IMG_UPLOAD_CODE;
        getUploadToken.parameters[@"token"] = [TLUser user].token;
        [getUploadToken postWithSuccess:^(id responseObject) {
            
//            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
            
            [TLProgressHUD showWithStatus:@""];
            
            //
            
            QNUploadManager *uploadManager = [[QNUploadManager alloc] initWithConfiguration:[QNConfiguration build:^(QNConfigurationBuilder *builder) {
                builder.zone = [QNZone zone2];
                
            }]];
          
            NSString *token = responseObject[@"data"][@"uploadToken"];
            
            UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
            NSData *imgData = UIImageJPEGRepresentation(image, 0.4);
            
            [uploadManager putData:imgData key:[TLUploadManager imageNameByImage:image] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                
                [TLProgressHUD dismiss];
                
                if (!info.error) {
                    
                    //设置头像
                    TLNetworking *http = [TLNetworking new];
                    http.showView = weakSelf.view;
                    http.code = USER_CHANGE_USER_PHOTO;
                    http.parameters[@"userId"] = [TLUser user].userId;
                    http.parameters[@"photo"] = key;
                    http.parameters[@"token"] = [TLUser user].token;
                    [http postWithSuccess:^(id responseObject) {
                        
                        [TLAlert alertWithSucces:@"修改头像成功"];
                        [TLUser user].userExt.photo = key;
                        
                        weakSelf.models[0].img = img;
                        [weakSelf.editTableView reloadData];
                        
                        //
                        [[TLUser user] updateUserInfo];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
                        
                    } failure:^(NSError *error) {
                        
                        
                    }];
                    
                } else {
                
                    [TLAlert alertWithError:@"图片上传失败"];
                }
                
                
            } option:nil];
            
        } failure:^(NSError *error) {
            
        }];


        
    }];
    
}

#pragma mark- datePicker
- (void)dateChange:(UIDatePicker *)datePicker {


   
}

#pragma mark- 资料保存
- (void)save {
    
    NSString *birthdayStr = self.models[2].content;
    NSString *sexStr = self.models[3].content;
    NSString *emailStr = self.models[4].content;

    
    
    if ([birthdayStr isEqualToString:@"请选择生日"]) {
        
        [TLAlert alertWithInfo:@"请填写生日"];
        return;
    }
    
    if ([sexStr isEqualToString:@"请选则性别"]) {
        
        [TLAlert alertWithInfo:@"请选择性别"];
        return;
    }
    
    if ([emailStr isEqualToString:@"请填写邮箱"]) {
        
        [TLAlert alertWithInfo:@"请填写邮箱"];
        return;
    }
    
    if (![self.textView.text valid]) {
        
        [TLAlert alertWithInfo:@"请填写自我介绍"];
        return;
    }
    
    
    //昵称修改上传不在此处
    
    //用户扩展信息修改
    TLNetworking *userExtHttp = [TLNetworking new];
    userExtHttp.showView = self.view;
    userExtHttp.code = @"805074";
    userExtHttp.parameters[@"userId"] = [TLUser user].userId;
    userExtHttp.parameters[@"token"] = [TLUser user].token;
    
    //--//
    userExtHttp.parameters[@"gender"] = [sexStr isEqualToString:@"男"] ? @"1" : @"0";
    
    userExtHttp.parameters[@"birthday"] = birthdayStr;
    userExtHttp.parameters[@"email"] = emailStr;
    userExtHttp.parameters[@"introduce"] = self.textView.text;

    [userExtHttp postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"保存成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
        TLUser *user = [TLUser user];
        
        user.userExt.birthday = birthdayStr;
        user.userExt.introduce = self.textView.text;
        user.userExt.email = emailStr;
        user.userExt.gender = [sexStr isEqualToString:@"男"] ? @"1" : @"0";
        
        [[TLUser user] updateUserInfo];
        //发出用户信息变更通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
}

#pragma mark- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    CSWUserEditModel *model = self.models[indexPath.row];
    if (model.url) { //选择图片
        
        [self.imgPicker picker];
        
    } else { //其它编辑
    
        switch (indexPath.row) {
            case 1: {//昵称
                
                CSWEditVC *editVC = [[CSWEditVC alloc] init];
                editVC.title = @"填写昵称";
                editVC.editModel = model;
                editVC.type = CSWUserEditTypeNickName;
                [editVC setDone:^{
                    
                    [tableView reloadData];
                }];
                [self.navigationController pushViewController:editVC animated:YES];
            
            }break;
            case 2: {//生日
                
                [self.datePicker show];
                
            }break;
            case 3: {//性别
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请选择您的性别" preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    model.content = @"男";
                   [tableView reloadData];
                    
                }]];
                
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    model.content = @"女";
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                }]];
                
                
                [self presentViewController:alertController animated:YES completion:nil];
                
            }break;
            case 4: {//邮箱
                
                CSWEditVC *editVC = [[CSWEditVC alloc] init];
                editVC.title = @"填写邮箱";
                editVC.editModel = model;
                editVC.type = CSWUserEditTypeEmail;
                [editVC setDone:^{
                    
                    [tableView reloadData];
                    
                }];
                
                //
                [self.navigationController pushViewController:editVC animated:YES];
                //
                
            }break;
                
           
        }
    
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (TLTextView *)textView {
    
    if (!_textView) {
        
        _textView = [[TLTextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
        _textView.font = FONT(15);
        _textView.textColor = [UIColor textColor];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.textContainerInset = UIEdgeInsetsMake(10, 6, 10, 6);
        _textView.placholder = @"个性签名~~";
        _textView.placeholderLbl.textColor = [UIColor textColor2];
    }
    return _textView;
    
}

- (TLDatePicker *)datePicker {
    
    if (!_datePicker) {
        __weak typeof(self) weakSelf = self;
        _datePicker = [TLDatePicker new];
        _datePicker.datePicker.datePickerMode = UIDatePickerModeDate;
        
        NSDate *loaclDate = [NSString getLocalDate];
        
        NSString *loaclStr = [NSString stringFromDate:loaclDate formatter:@"yyyy-MM-dd"];
        
        NSString *monthStr = [NSString stringFromDate:loaclDate formatter:@"MM-dd"];
        
        NSString *yearStr = [loaclStr substringToIndex:4];
        
        NSString *dateStr = [NSString stringWithFormat:@"%ld-%@", yearStr.integerValue - 100, monthStr];
        
        NSDate *minDate = [NSString dateFromString:dateStr formatter:@"yyyy-MM-dd"];
        
        _datePicker.datePicker.minimumDate = minDate;
        _datePicker.datePicker.maximumDate = loaclDate;
        
        [_datePicker.datePicker setDate:loaclDate animated:YES];
        
        [_datePicker setConfirmAction:^(NSDate *date) {
            
            CSWUserEditModel *editModel = weakSelf.models[2];
            editModel.content =  [NSString stringFromDate:date formatter:@"yyyy-MM-dd"];
            [weakSelf.editTableView reloadData];
            
        }];
    }
    return _datePicker;
    
}

- (TLImagePicker *)imgPicker {
    
    if (!_imgPicker) {
        
        __weak typeof(self) weakSelf = self;
        _imgPicker = [[TLImagePicker alloc] initWithVC:self];
        _imgPicker.allowsEditing = YES;
        
    }
    return _imgPicker;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 10;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}


#pragma mark- dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return indexPath.row == 0 ? 80 : 45;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.models.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CSWUserEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSWUserEditCellId"];
    if (!cell) {
        
        cell = [[CSWUserEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSWUserEditCellId"];
        
    }
    
    CSWUserEditModel *model = self.models[indexPath.row];
    
    cell.titleLbl.text = model.title;
    if (model.url || model.img) {
        
        //优先URl
        //img
        //imageName
        if (model.img) {
            
            cell.userPhoto.image = model.img;
            
        } else if (model.url) {
            
            [cell.userPhoto sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:USER_PLACEHOLDER_SMALL];
            
        }
        
        
    } else {
    
        cell.contentLbl.text = model.content;

    }
    
    cell.lineView.hidden = indexPath.row == self.models.count - 1? YES: NO;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}





@end
