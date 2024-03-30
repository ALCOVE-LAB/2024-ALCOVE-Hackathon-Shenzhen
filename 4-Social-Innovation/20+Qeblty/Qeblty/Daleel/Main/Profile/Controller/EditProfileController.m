//
//  EditProfileController.m
//  Daleel
//
//  Created by mac on 2024/3/31.
//

#import "EditProfileController.h"
#import "EditProfileDetailController.h"
#import "EditProfileCell.h"
#import "EditProfileTableView.h"
#import "ImgPicker.h"
#import <BRDatePickerView.h>

@interface EditProfileController ()

/// 头像
@property (nonatomic,strong)UIImageView *iconBtn;
/// 昵称
@property (nonatomic,strong)UILabel *nameLB;
/// 蒙版
@property (nonatomic,strong)UIView *maskView;
/// 图标
@property (nonatomic,strong)UIImageView *photoImg;
/// 底部列表背景
@property (nonatomic,strong)UIView *bottomBgView;
@property (nonatomic,strong)EditProfileTableView *bottomTabView;
/// 图片选择
@property (nonatomic, strong) ImgPicker *imagePicker;
/// 生日
@property(nonatomic,copy)NSString *selectValue;
/// 生日选择控件
@property(nonatomic,strong)UIView *contentView;

@end

@implementation EditProfileController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initData];
}
- (void)setupViews {
    self.title = kLocalize(@"edit_profile");
    [self.view addSubview:self.iconBtn];
    [self.view addSubview:self.nameLB];
    [self.view addSubview:self.bottomBgView];
    [self.iconBtn addSubview:self.maskView];
    [self.iconBtn addSubview:self.photoImg];
    [self.bottomBgView addSubview:self.bottomTabView];
    
    [self.iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(kHeight_NavBar + 32);
        make.size.mas_equalTo(CGSizeMake(84, 84));
    }];
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconBtn);
        make.top.equalTo(self.iconBtn.mas_bottom).offset(12);
    }];
    [self.bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(17);
        make.trailing.mas_equalTo(-17);
        make.top.equalTo(self.nameLB.mas_bottom).offset(20);
        make.height.mas_equalTo(227);
    }];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(28);
    }];
    [self.photoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(32);
        make.trailing.mas_equalTo(-34);
        make.bottom.mas_equalTo(-7);
        make.height.mas_equalTo(14);
    }];
    [self.bottomTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - data
- (void)initData {
    [self.iconBtn loadImgUrl:kUserModel.headUrl placeholderImg:@"avatar_default"];
    self.nameLB.text = kUserModel.nickName;
    NSArray *arr = @[@{@"title":kLocalize(@"name"),@"detail":kUserModel.nickName},@{@"title":kLocalize(@"birthday"),@"detail":kUserModel.birthday.length > 0 ? kUserModel.birthday : @""},@{@"title":kLocalize(@"gender"),@"detail":kUserModel.gender == 1 ? kLocalize(@"gender_man") : kLocalize(@"gender_woman")},@{@"title":kLocalize(@"introduce"),@"detail":kUserModel.introduction.length > 0 ? kUserModel.introduction : @""}];
    self.bottomTabView.dataArr = [NSMutableArray arrayWithArray:arr];
    [self.bottomTabView reloadData];
}

- (void)saveImage:(UIImage *)img {
    if (!img) {
        return;
    }
//    self.iconBtn.image = img;
    [ProgressHUD showHudInView:self.view];
    [self.imagePicker uploadImage:img index:@(0) success:^(id  _Nonnull responseObject) {
        [ProgressHUD hideHUDForView:self.view];
        DLog(@"%@",responseObject);
        if (!kIsNilOrNull(responseObject)) {
            if ([responseObject[@"status"] integerValue] == 1) {
                [self updateUserInfo:responseObject[@"url"] birthday:nil gender:0];
            }else {
                kToast(kLocalize(@"avatar_illegal"));
                self.iconBtn.image = kImageName(@"avatar_violate");
            }
        }else {
            kToast(kLocalize(@"avatar_illegal"));
        }
    } progress:^(NSProgress * _Nonnull progress) {
        
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD hideHUDForView:self.view];
        if (error.code == 5560) {
            self.iconBtn.image = kImageName(@"avatar_violate");
            kToast(kLocalize(@"avatar_illegal"));
        }else{
            kToast(kLocalize(error.userInfo[kHttpErrorReason]));
        }
    }];
}

- (void)updateUserInfo:(NSString *_Nullable)headUrl birthday:(NSString *_Nullable)birthday gender:(NSInteger)gender {
    [ProgressHUD showHudInView:self.view];
    [AccountNetworkTool updateUserInfo:headUrl nickName:nil birthday:birthday gender:(int)gender introduction:nil success:^(id  _Nullable responseObject) {
        DLog(@"updateUserInfo:%@",responseObject);
        UserModel *model = [UserModel mj_objectWithKeyValues:responseObject];
        [kUser updateAndSaveUserinfo:model];
        [ProgressHUD hideHUDForView:self.view];
        [self initData];
    } failure:^(NSError * _Nonnull error) {
        kToast(error.userInfo[kHttpErrorReason]);
        [ProgressHUD hideHUDForView:self.view];
    }];
}

#pragma mark - lazy load
- (UIImageView *)iconBtn {
    if(!_iconBtn){
        _iconBtn = [[UIImageView alloc] init];
        _iconBtn.layer.cornerRadius = 42.f;
        _iconBtn.layer.masksToBounds = YES;
        _iconBtn.contentMode = UIViewContentModeScaleAspectFill;
        _iconBtn.userInteractionEnabled = YES;
        @weakify(self)
        [_iconBtn addTapAction:^{
         @strongify(self)
            [self addPortraite];
        }];
    }
    return _iconBtn;
}

- (UIView *)maskView {
    if(!_maskView){
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = RGB_ALPHA(0x000000, 0.7);
    }
    return _maskView;
}

- (UIImageView *)photoImg {
    if(!_photoImg){
        _photoImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_setting_editProfilePhoto"]];
    }
    return _photoImg;
}

- (UILabel *)nameLB {
    if(!_nameLB){
        _nameLB = [UILabel labelWithTextFont:kFont(22) textColor:[UIColor colorWithHexString:@"#1b1b1b"] text:@"Leo"];
    }
    return _nameLB;
}

- (UIView *)bottomBgView {
    if(!_bottomBgView){
        _bottomBgView = [[UIView alloc] init];
        _bottomBgView.backgroundColor = UIColor.whiteColor;
        _bottomBgView.layer.cornerRadius = 12.f;
        _bottomBgView.layer.masksToBounds = YES;
    }
    return _bottomBgView;
}

- (EditProfileTableView *)bottomTabView {
    if(!_bottomTabView){
        _bottomTabView = [[EditProfileTableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        @weakify(self)
        [_bottomTabView.didClickCellSubject subscribeNext:^(NSIndexPath *x) {
         @strongify(self)
            [self selectRowAction:x.row];
        }];
    }
    return _bottomTabView;
}

- (ImgPicker *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [[ImgPicker alloc] init];
    }
    return _imagePicker;
}

#pragma mark - event
- (void)selectRowAction:(NSInteger)row {
    switch (row) {
        case 0:{
            EditProfileDetailController *editProfileDetailVC = [[EditProfileDetailController alloc] init];
            editProfileDetailVC.type = kEditName;
            [self pushViewController:editProfileDetailVC];
        }break;
        case 1:
            [self showBirthdayAlert];
            break;
        case 2:{
            @weakify(self);
            [UIAlertController showActionSheetInViewController:self withTitle:kLocalize(@"pls_select_your_gender") message:@"" cancelButtonTitle:kLocalize(@"cancel") destructiveButtonTitle:nil otherButtonTitles:@[kLocalize(@"gender_man"),kLocalize(@"gender_woman")] tapBlock:^(UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                @strongify(self);
                if (buttonIndex == 2 || buttonIndex == 3) {
                    [self updateUserInfo:nil birthday:nil gender:buttonIndex-1];
                }
            }];
        }break;
        case 3:{
            EditProfileDetailController *editProfileDetailVC = [[EditProfileDetailController alloc] init];
            editProfileDetailVC.type = kEditIntroduce;
            [self pushViewController:editProfileDetailVC];
        }break;
        default:
            break;
    }
}

/// 用户头像
- (void)addPortraite {
    if (IS_IPAD) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:kLocalize(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:kLocalize(@"take_photo") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.imagePicker showPickInVC:self sourceType:UIImagePickerControllerSourceTypeCamera completion:^(UIImage * _Nullable img) {
                [self saveImage:img];
            }];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:kLocalize(@"album") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.imagePicker showPickInVC:self sourceType:UIImagePickerControllerSourceTypePhotoLibrary completion:^(UIImage * _Nullable img) {
                [self saveImage:img];
            }];
        }]];
        if (alert.popoverPresentationController != nil) {
            alert.popoverPresentationController.sourceView = self.view;
            alert.popoverPresentationController.sourceRect = CGRectMake(0, kScreenHeight-10, kScreenWidth, 500);
            
        }
        [self presentViewController:alert animated:YES completion:^{
        }];
    }else {
        [UIAlertController showActionSheetInViewController:self withTitle:nil message:nil cancelButtonTitle:kLocalize(@"cancel") destructiveButtonTitle:nil otherButtonTitles:@[kLocalize(@"take_photo"), kLocalize(@"album")] tapBlock:^(UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex == UIAlertControllerBlocksFirstOtherButtonIndex) {
                [self.imagePicker showPickInVC:self sourceType:UIImagePickerControllerSourceTypeCamera completion:^(UIImage * _Nullable img) {
                    [self saveImage:img];
                }];
            }else if (buttonIndex == UIAlertControllerBlocksFirstOtherButtonIndex + 1) {
                [self.imagePicker showPickInVC:self sourceType:UIImagePickerControllerSourceTypePhotoLibrary completion:^(UIImage * _Nullable img) {
                    [self saveImage:img];
                }];
            }
        }];
    }
}

/// 展示选择生日alert
- (void)showBirthdayAlert {
    if (@available (iOS 13.0 , *)) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:kLocalize(@"pls_set_birthday") preferredStyle:UIAlertControllerStyleActionSheet];
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth-60, 230)];
        [alert.view addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(40);
            make.leading.mas_equalTo(10);
            make.trailing.mas_equalTo(-10);
            make.height.mas_equalTo(230);
            make.bottom.mas_equalTo(-80);
        }];
       
        _contentView.backgroundColor = kClearColor;
        BRDatePickerView *datePicker = [[BRDatePickerView alloc] initWithPickerMode:BRDatePickerModeDate];
        datePicker.selectValue = kUserModel.birthday;
//        datePicker.minDate = [NSDate br_dateFromString:@"1960-1-1" dateFormat:@"yyyy-MM-dd"];
        datePicker.maxDate = [NSDate date];
        datePicker.isAutoSelect = YES;
        datePicker.showUnitType = BRShowUnitTypeNone;
        @weakify(self)
        datePicker.resultBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
            @strongify(self)
            self.selectValue = selectValue;
        };
        BRPickerStyle *customStyle = [[BRPickerStyle alloc] init];
        customStyle.hiddenTitleBarView = YES;
        customStyle.selectRowColor = RGB(0xFDF9F1);
        customStyle.selectRowTextFont = kFontMedium(18);
        customStyle.selectRowTextColor = RGB(0x1B1B1B);
        customStyle.language = kIsAR ? @"ar" : @"en";
        datePicker.pickerStyle = customStyle;
        [datePicker addPickerToView:_contentView];
        [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.bottom.mas_equalTo(0);
            make.trailing.mas_equalTo(-15);
        }];
        [alert addAction:[UIAlertAction actionWithTitle:kLocalize(@"confirm") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self updateUserInfo:nil birthday:self.selectValue gender:0];
        }]];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }else {
        [self selectBirthday];
    }
}
///选择生日
- (void)selectBirthday {
    BRDatePickerView *datePicker = [[BRDatePickerView alloc] initWithPickerMode:BRDatePickerModeDate];
    datePicker.title = kLocalize(@"Birthday");
    datePicker.selectValue = kUserModel.birthday;
    datePicker.minDate = [NSDate br_dateFromString:@"1960-1-1" dateFormat:@"yyyy-MM-dd"];
    datePicker.maxDate = [NSDate date];
    datePicker.isAutoSelect = NO;
    datePicker.showUnitType = BRShowUnitTypeNone;
    @weakify(self)
    datePicker.resultBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
        @strongify(self)
        [self updateUserInfo:nil birthday:self.selectValue gender:0];
    };
    BRPickerStyle *customStyle = [[BRPickerStyle alloc] init];
    customStyle.titleTextFont = kFontSemibold(16);
    customStyle.titleTextColor = RGB(0x0B0A0C);
    customStyle.cancelBtnTitle = kLocalize(@"Cancel");
    customStyle.cancelTextColor = RGB(0x888888);
    customStyle.doneBtnTitle = kLocalize(@"Confirm");
    customStyle.doneTextFont = kFontSemibold(14);
    customStyle.doneTextColor = RGB(0x4294EB);
    customStyle.topCornerRadius = 15;
    customStyle.selectRowColor = RGB_ALPHA(0x966FFE, 0.5);
    customStyle.selectRowTextFont = kFontSemibold(14);
    customStyle.selectRowTextColor = RGB_ALPHA(0x000000, 0.8);
    customStyle.language = kIsAR ? @"ar" : @"en";
    datePicker.pickerStyle = customStyle;
    [datePicker show];
}




@end
