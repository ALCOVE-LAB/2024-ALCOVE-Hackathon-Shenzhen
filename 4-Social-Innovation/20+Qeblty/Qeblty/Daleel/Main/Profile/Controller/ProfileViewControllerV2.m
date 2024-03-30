//
//  ProfileV2ViewController.m
//  Daleel
//
//  Created by mac on 2024/3/31.
//

#import "ProfileViewControllerV2.h"
#import "ProfileTableViewV2.h"
#import "EditProfileController.h"
#import "AwardsNetworkTool.h"
#import "BadgesModel.h"
#import "BadgesViewController.h"
#import "AccountSecurityController.h"
#import "PrayerSettingController.h"
#import "AboutViewController.h"

@interface ProfileViewControllerV2 ()

@property (nonatomic,strong) ProfileTableViewV2 *profileTableView;

@end

@implementation ProfileViewControllerV2

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 更新用户信息 - 积分
    [[AccountManager sharedInstance] refreshUserInfoSuccess:nil failure:nil];
}

- (void)setupViews {
    @weakify(self);

    // 用户信息变更监听
    [[AccountManager sharedInstance] getAccountSate:nil addListenerWithKey:@"ProfileViewController" listener:^(AccountManagerState state, id  _Nonnull msg) {
        @strongify(self);
        if(state == AccountManagerState_Logined || state == AccountManagerState_GuestLogined) {
            [self.profileTableView updateTableHeaderUserInfo];
        } else if (state == AccountManagerState_UpdatedUserInfo) {
            [self.profileTableView updateTableHeaderUserInfo];
            [self.profileTableView updatePoints];
        }
    }];
    
    ProfileTableViewV2 *profileTableView = [ProfileTableViewV2 getProfileTableviewWithFrame:CGRectMake(17, kHeight_NavBar, kScreenWidth - 34, kScreenHeight - kHeight_NavBar)];
    [self.view addSubview:profileTableView];
    _profileTableView = profileTableView;
    profileTableView.editProfileAction = ^{
        @strongify(self)
        // 判断用户是否是游客
        if (kUser.userInfo.touristFlag == 1) {
            //登陆
            [[AccountManager sharedInstance] pushLogin];
        }else {
            // 编辑用户信息
            EditProfileController *vc = [[EditProfileController alloc] init];
            [self pushViewController:vc];
        }
    };

    profileTableView.ClickPoint = ^{
        @strongify(self);
        BadgesViewController *vc = [[BadgesViewController alloc] init];
        [self pushViewController:vc];
    };
    
    profileTableView.SettingTabSignBlock = ^(UIButton * _Nonnull sender) {
        @strongify(self);
        [self logout];
    };
    
    [profileTableView.didClickCellSubject subscribeNext:^(NSIndexPath *x) {
        @strongify(self);
        if (x.row == 0) {
            // 编辑个人信息
            [self pushViewController:[[EditProfileController alloc] init]];
            return;
        }
        if (x.row == 1) {
            // 账号安全
            [self pushViewController:[[AccountSecurityController alloc] init]];
            return;
        }
        if (x.row == 2) {
            // 祈祷设置
            PrayerSettingController *vc = [[PrayerSettingController alloc] init];
            [self pushViewController:vc];
            return;
        }
        if (x.row == 3) {
            // 语言
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            };
            return;
        }
        if (x.row == 4) {
            // 清理缓存
            [self clearCache];
            return;
        }
        if (x.row == 5) {
            // 关于Qeblty
            [self pushViewController:[[AboutViewController alloc] init]];
            return;
        }
        
    }];
    [profileTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(kHeight_NavBar);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}



- (void)clearCache {
    [UIAlertController showAlertInViewController:self withTitle:kLocalize(@"clear_cache") message:[NSString stringWithFormat:kLocalize(@"clear_cache_tip"),[DeviceTool getCaceSize]] cancelButtonTitle:kLocalize(@"cancel") destructiveButtonTitle:kLocalize(@"clear") otherButtonTitles:@[] tapBlock:^(UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == UIAlertControllerBlocksDestructiveButtonIndex) {
            [DeviceTool clearCache];
        }
    }];
}
/// 退出
- (void)logout {
    [UIAlertController showAlertInViewController:self withTitle:kLocalize(@"are_you_sure_to_logout") message:nil cancelButtonTitle:kLocalize(@"cancel") destructiveButtonTitle:kLocalize(@"confirm") otherButtonTitles:@[] tapBlock:^(UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == UIAlertControllerBlocksDestructiveButtonIndex) {
            [kUser logout];
        }
    }];
}

@end
