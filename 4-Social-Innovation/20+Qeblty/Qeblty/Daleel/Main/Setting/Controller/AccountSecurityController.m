//
//  AccountSecurityController.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "AccountSecurityController.h"
#import "AccountSecurityTableView.h"
#import "DeleteAccountViewController.h"

@interface AccountSecurityController ()

@property(nonatomic,strong)AccountSecurityTableView *accountTV;

@end

@implementation AccountSecurityController

- (void)initialize {
    self.title = kLocalize(@"account_and_security");
}

- (void)setupViews {
    [self.view addSubview:self.accountTV];
    [self.accountTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kHeight_NavBar, 0, 0, 0));
    }];
}

- (void)requestData {
    NSArray *dataArr;
#warning 绑定的三方和非绑定的三方UI不同 但是要前系统不支持绑定账号 所以kUser.userInfo.registerType可以表示当前绑定的三方OR手机 以后放开绑定此处需要改！！！！
    ///注册类别:0手机号1facebook2谷歌账号3苹果账号4华为
    /// 处理是否绑定三方OR手机
    dataArr = @[@[@{@"title":kLocalize(@"delete_account")}]];
//    switch (kUser.userInfo.registerType) {
//        case 0:
//            dataArr = @[@[@{@"title":@"Facebook",@"image":@"facebook",@"isBind":@(0)},@{@"title":@"Google",@"image":@"google",@"isBind":@(0)},@{@"title":@"Apple",@"image":@"appleid",@"isBind":@(0)},@{@"title":kLocalize(@"phone_number"),@"image":@"PHONE",@"isBind":@(1)}],@[@{@"title":kLocalize(@"password")},@{@"title":kLocalize(@"delete_account")}]];
//            break;
//        case 1:
//            dataArr = @[@[@{@"title":@"Facebook",@"image":@"facebook",@"isBind":@(1)},@{@"title":@"Google",@"image":@"google",@"isBind":@(0)},@{@"title":@"Apple",@"image":@"appleid",@"isBind":@(0)},@{@"title":kLocalize(@"phone_number"),@"image":@"PHONE",@"isBind":@(0)}],@[@{@"title":kLocalize(@"password")},@{@"title":kLocalize(@"delete_account")}]];
//            break;
//        case 2:
//            dataArr = @[@[@{@"title":@"Facebook",@"image":@"facebook",@"isBind":@(0)},@{@"title":@"Google",@"image":@"google",@"isBind":@(1)},@{@"title":@"Apple",@"image":@"appleid",@"isBind":@(0)},@{@"title":kLocalize(@"phone_number"),@"image":@"PHONE",@"isBind":@(0)}],@[@{@"title":kLocalize(@"password")},@{@"title":kLocalize(@"delete_account")}]];
//            break;
//        case 3:
//            dataArr = @[@[@{@"title":@"Facebook",@"image":@"facebook",@"isBind":@(0)},@{@"title":@"Google",@"image":@"google",@"isBind":@(0)},@{@"title":@"Apple",@"image":@"appleid",@"isBind":@(1)},@{@"title":kLocalize(@"phone_number"),@"image":@"PHONE",@"isBind":@(0)}],@[@{@"title":kLocalize(@"password")},@{@"title":kLocalize(@"delete_account")}]];
//            break;
//
//        default:
//            dataArr = @[@[@{@"title":@"Facebook",@"image":@"facebook",@"isBind":@(0)},@{@"title":@"Google",@"image":@"google",@"isBind":@(0)},@{@"title":@"Apple",@"image":@"appleid",@"isBind":@(0)},@{@"title":kLocalize(@"phone_number"),@"image":@"PHONE",@"isBind":@(0)}],@[@{@"title":kLocalize(@"password")},@{@"title":kLocalize(@"delete_account")}]];
//            break;
//    }
    self.accountTV.dataArr = [NSMutableArray arrayWithArray:dataArr];
    [self.accountTV reloadData];
}

#pragma mark - lay load
- (AccountSecurityTableView *)accountTV {
    if (!_accountTV) {
        _accountTV = [[AccountSecurityTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        @weakify(self)
        [_accountTV.didClickCellSubject subscribeNext:^(NSIndexPath *x) {
         @strongify(self)
            [self didselected:x];
        }];
    }
    return _accountTV;
}

#pragma mark - event
- (void)didselected:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        BOOL isBind = [[self.accountTV.dataArr[indexPath.section][indexPath.row] valueForKey:@"isBind"] intValue];
//        if(isBind) {
//            // 已经绑定的 不支持解绑
//            kToast(kLocalize(@"binding_unbinding_is_not_supported"));
//        }else {
//            // 没有绑定的 目前不支持绑定
//             kToast(kLocalize(@"no_support_account_bind"));
//        }
//    }else {
//        if (indexPath.row == 0) {
//            if (kUserModel.phoneNumber.length <= 0) {
//                kToast(kLocalize(@"no_bind_phone_cant_change_password"));
//                return;
//            }
//            /// 如果是手机号登录,修改密码
//            [self pushViewController:[[SetPsdViewController alloc] init]];
//        }else {
            /// 删除账号
            [self pushViewController:[[DeleteAccountViewController alloc] init]];
//        }
//    }
}

@end
