//
//  LoginVM.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "LoginVM.h"
#import "LoginThirdAuthorizeTool.h"
#import "PhoneCountryCodeGroupModel.h"
#import "AccountManager.h"

@implementation LoginVM

/// 三方认证
- (void)thirdPartAuthorizeWithType:(AccountLoginType)loginType {
    [ProgressHUD showHudInView:nil];
    [LoginThirdAuthorizeTool authorizeWithPlatformType:loginType success:^(NSString * _Nonnull userId, AccountLoginType type) {
        [ProgressHUD hideHUD];
        [self sendVMMessage:kThirdPartAuthorizeSuccess data:@{@"userId":userId,@"accountType":@(type)}];
    } cancelShare:^{
        [ProgressHUD hideHUD];
        [self sendVMMessage:kThirdPartAuthorizeCancel data:nil];
    } fail:^(NSError * _Nullable error) {
        [ProgressHUD hideHUD];
        [self sendVMMessage:kThirdPartAuthorizeError data:error];
    }];
}

/// 登陆
- (void)LoginWithUid:(NSString *)userId countryCode:(NSString *_Nullable)countryCode password:(NSString *_Nullable)psd loginType:(AccountLoginType)type {
    [ProgressHUD showHudInView:nil];
    [AccountNetworkTool loginWithLoginUid:userId countryCode:countryCode password:psd loginType:@(type) success:^(id  _Nullable responseObject) {
        [ProgressHUD hideHUD];
        // 保存用户信息以及token
        UserModel *userInfo = [UserModel mj_objectWithKeyValues:responseObject];
        [self sendVMMessage:kLoginSuccess data:userInfo];
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD hideHUD];
        [self sendVMMessage:kLoginError data:error];
    }];
}

/// 注册
- (void)registWithUid:(NSString *)userId registType:(AccountLoginType)type countryCode:(NSString *_Nullable)countryCode password:(NSString *_Nullable)psd smsCode:(NSString *_Nullable)code {
    [ProgressHUD showHudInView:nil];
    [AccountNetworkTool registWithUid:userId countryCode:countryCode smsCode:code password:psd type:@(type) success:^(id  _Nullable responseObject) {
        [ProgressHUD hideHUD];
        // 保存用户信息以及token
        UserModel *userInfo = [UserModel mj_objectWithKeyValues:responseObject];
        [self sendVMMessage:kRegistSuccess data:userInfo];
        
        if ([kUserDefaults objectForKey:kInviterId] && [kUserDefaults objectForKey:kInviteChannel]) {
            // 动态唤醒app参数
            [self bindAccountWithInviteUserId:[kUserDefaults objectForKey:kInviterId] userId:userInfo.userId channel:[kUserDefaults objectForKey:kInviteChannel]];
        } else {
            // 安装应用传参
            
        }
        
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD hideHUD];
        [self sendVMMessage:kRegistError data:error];
    }];
}

/// 获取验证码
- (void)getSmsCodeWithPhoneNum:(NSString *)phoneNum countryCode:(NSString *)countryCode type:(AccountLoginType)type {
    [AccountNetworkTool getCodeMessageWithPhoneNum:phoneNum countryCode:countryCode type:@(type) success:^(id  _Nullable responseObject) {
        [self sendVMMessage:kSendSmsCodeSuccess data:nil];
    } failure:^(NSError * _Nonnull error) {
        [self sendVMMessage:kSendSmsCodeError data:error];
    }];
}

/// 验证手机号 三方uid 是否注册过 是否注销冷静期内
- (void)vaildAccountWithUid:(NSString *)uId phoneCountryCode:(NSString *_Nullable)countryCode accountType:(AccountLoginType)type {
    [ProgressHUD showHudInView:nil];
    [AccountNetworkTool vaildAccountWithUid:uId phoneCountryCode:countryCode accountType:@(type) success:^(id  _Nullable responseObject) {
        [ProgressHUD hideHUD];
        NSInteger statusCode = [responseObject[@"status"] integerValue]; // destroyFlag
        NSInteger destroyFlag = [responseObject[@"destroyFlag"] integerValue];
        if (statusCode == 1) {
            // 已经注册过
            [self sendVMMessage:kVaildAccountRegisted data:@{@"userId":uId,@"accountType":@(type)}];
        }else if (statusCode == 0){
            // 没注册过
            [self sendVMMessage:kVaildAccountUnRegisted data:@{@"userId":uId,@"accountType":@(type)}];
        }else {
            if (destroyFlag == 1){
                // 注销冷静期内
                [self sendVMMessage:kVaildAccountDeleted data:@{@"userId":uId,@"accountType":@(type)}];
            }else {
                // 其他状态 已经注销了
                [self sendVMMessage:kVaildAccountUnRegisted data:@{@"userId":uId,@"accountType":@(type)}];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD hideHUD];
        [self sendVMMessage:kVaildAccountError data:error];
    }];
}

- (void)checkRouristHavaSyncData {
    [AccountNetworkTool checkRouristHavaSyncDataWithDeviceId:[DeviceTool getUUIDInKeychain] success:^(id  _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSString *needSync = [dic valueForKey:@"needSync"];
        if ([needSync intValue] > 0) { // 有合并的数据
            [self sendVMMessage:kCheckUserDataNeedMerge data:responseObject];
        } else {
            [self sendVMMessage:kCheckUserDataNoNeedMerge data:responseObject];
        }
    } failure:^(NSError * _Nonnull error) {
        [self sendVMMessage:kCheckUserDataMergeError data:error];
    }];
}

/// 获取国家列表
- (void)getPhoneCountryCodeList {
    [ProgressHUD showHudInView:nil];
    [AccountNetworkTool getCountryCode:@(1) size:@(100) success:^(id  _Nullable responseObject) {
        NSArray <PhoneCountryCodeGroupModel *>  *phoneCountryCodeGroupArr =  [PhoneCountryCodeGroupModel mj_objectArrayWithKeyValuesArray:responseObject];
        [ProgressHUD hideHUD];
        [self sendVMMessage:kPhoneCountryCodeListSuccess data:phoneCountryCodeGroupArr];
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD hideHUD];
        [self sendVMMessage:kPhoneCountryCodeListError data:error];
    }];
}

#pragma mark - pravite method
/// 绑定账号
- (void)bindAccountWithInviteUserId:(NSString *)inviteUserId userId:(NSString *)userId channel:(NSString *)channel {
    [AccountNetworkTool bindInviteAccountWithInviterId:inviteUserId userId:userId channel:channel success:^(id  _Nullable responseObject) {
        NSLog(@"绑定成功");
    } failure:^(NSError * _Nonnull error) {
        // 绑定失败
        kToast(error.userInfo[kHttpErrorReason]);
    }];
}


@end
