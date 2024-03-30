//
//  LoginNetworkTool.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "AccountNetworkTool.h"

@implementation AccountNetworkTool

/// 获取/刷新 token
+ (void)refreshTokenSuccess:(SuccessBlock)success failure:(FailureBlock)fail {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (kUser.userInfo.refreshToken) {
        [param setValue:kUser.userInfo.refreshToken forKey:@"refreshToken"];
    }
    [param setValue:[NSNumber numberWithInteger:kUser.userInfo.touristFlag] forKey:@"userType"];
    [NetworkService postWithUrl:URL(kRequestRefreshToken) parameters:param needEncryption:isEntry success:success failure:fail];
}

/// 获取国家列表
+ (void)getCountryCode:(NSNumber *)pageNumber size:(NSNumber *)pageSize success:(SuccessBlock)success failure:(FailureBlock)failuer {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [NetworkService postWithUrl:URL(kRequestCountryList) parameters:param needEncryption:isEntry success:success failure:failuer];
}

/// 验证手机号/三方uid 是否注注册  是否在注册冷静期内
+ (void)vaildAccountWithUid:(NSString *)userId phoneCountryCode:(NSString *_Nullable)countryCode accountType:(NSNumber *)accountType success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (userId) {
        [param setObject:userId forKey:@"account"];
    }
    if (countryCode) {
        [param setValue:countryCode forKey:@"countryCode"];
    }
    if (accountType) {
        [param setValue:accountType forKey:@"accountType"];
    }
    [NetworkService postWithUrl:URL(kRequestValidAccountId) parameters:param needEncryption:isEntry success:success failure:failure];
}

/// 获取验证码
/// @param phone 手机号
/// @param countryCode 国家代码
/// @param type 0注册1忘记密码 2绑定
+ (void)getCodeMessageWithPhoneNum:(NSString *)phone countryCode:(NSString *)countryCode type:(NSNumber *)type success:(SuccessBlock)success failure:(FailureBlock)failuer {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (phone) {
        [param setValue:phone forKey:@"phone"];
    }
    if (countryCode) {
        [param setValue:countryCode forKey:@"countryCode"];
    }
    if (type) {
        [param setValue:type forKey:@"type"];
    }
    [NetworkService postWithUrl:URL(kRequestGetSmsCode) parameters:param needEncryption:isEntry success:success failure:failuer];
}

/// 注册
/// @param userId 手机号/三方id
/// @param countryCode 国家代码
/// @param code 验证码
/// @param password 密码
/// @param type 注册类别0手机号1facebook2谷歌账号3苹果账号4华为
/// 返回数据： refreshToken     刷新token  token    用户token   isPass    是否通过验证码验证
+ (void)registWithUid:(NSString *)userId countryCode:(NSString *)countryCode smsCode:(NSString *)code password:(NSString *_Nullable)password type:(NSNumber *)type success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (userId) {
        [param setValue:userId forKey:@"username"];
    }
    if (countryCode) {
        [param setValue:countryCode forKey:@"countryCode"];
    }
    if (type) {
        [param setValue:type forKey:@"registerType"];
    }
    if (code) {
        [param setValue:code forKey:@"code"];
    }
    if (password) {
        [param setValue:password forKey:@"password"];
    }
    [NetworkService postWithUrl:URL(kRequestRegist) parameters:param needEncryption:isEntry success:success failure:failure];
}

/// 账号登录(手机号和三方)
/// @param loginUid 手机号或三方id
/// @param countryCode 国家代码
/// @param password 密码
+ (void)loginWithLoginUid:(NSString *)loginUid countryCode:(NSString *_Nullable)countryCode password:(NSString *_Nullable)password loginType:(NSNumber *_Nullable)loginType success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (loginUid) {
        [param setValue:loginUid forKey:@"username"];
    }
    if (countryCode) {
        [param setValue:countryCode forKey:@"countryCode"];
    }
    if (password) {
        [param setValue:password forKey:@"password"];
    }
    if (loginType) {
        [param setValue:loginType forKey:@"loginType"];
    }
    [NetworkService postWithUrl:URL(kRequestLogin) parameters:param needEncryption:isEntry success:success failure:failure];
}

/// 用户退出登录
+ (void)logoutSuccess:(SuccessBlock)success failure:(FailureBlock)failure {
    [NetworkService postWithUrl:URL(kRequestLogout) parameters:@{} needEncryption:isEntry success:success failure:failure];
}

/// 获取用户信息
+ (void)getUserInfo:(SuccessBlock)success failure:(FailureBlock)failure {
    [NetworkService postWithUrl:URL(kRequestUserInfo) parameters:@{} needEncryption:isEntry success:success failure:failure];
}

/// 修改用户信息
/// - Parameters:
///   - headUrl: 头像
///   - nickName: 昵称
///   - birthday: 生日
///   - gender: 性别 1男 2女
///   - introduction: 简介
+ (void)updateUserInfo:(NSString *_Nullable)headUrl nickName:(NSString *_Nullable)nickName birthday:(NSString *_Nullable)birthday gender:(int)gender introduction:(NSString *_Nullable)introduction success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (headUrl) {
        [param setValue:headUrl forKey:@"headUrl"];
    }
    if (nickName) {
        [param setValue:nickName forKey:@"nickName"];
    }
    if (birthday) {
        [param setValue:birthday forKey:@"birthday"];
    }
    if (gender > 0) {
        [param setValue:@(gender) forKey:@"gender"];
    }
    if (introduction) {
        [param setValue:introduction forKey:@"introduction"];
    }
    [NetworkService postWithUrl:URL(kRequestModifyUserInfo) parameters:param needEncryption:isEntry success:success failure:failure];
}

/// 删除账号
+ (void)deleteAccountSuccess:(SuccessBlock)success failure:(FailureBlock)failure {
    [NetworkService postWithUrl:URL(kRequestDeleteAccount) parameters:@{} needEncryption:isEntry success:success failure:failure];
}

/// 获取用户删除信息
+ (void)getDeleteInfoSuccess:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (kUserModel.userId) {
        [param setValue:kUserModel.userId forKey:@"userId"];
    }
    [NetworkService postWithUrl:URL(kRequestGetDeleteInfo) parameters:param needEncryption:isEntry success:success failure:failure];
}
/// 修改密码
+ (void)updateUserPassword:(NSString *)password Success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (password) {
        [param setValue:password forKey:@"password"];
    }
    if (kUserModel.phoneNumber) {
        [param setValue:kUserModel.phoneNumber forKey:@"phone"];
    }
    if (kUserModel.countryCode) {
        [param setValue:kUserModel.countryCode forKey:@"countryCode"];
    }
    [NetworkService postWithUrl:URL(kRequestModifyUserPSD) parameters:param needEncryption:isEntry success:success failure:failure];
}

/// 检查版本更新
+ (void)checkUpdateSuccess:(SuccessBlock)success failure:(FailureBlock)failure {
    [NetworkService postWithUrl:URL(kRequestCheckUpdate) parameters:@{} needEncryption:isEntry success:success failure:failure];
}

/// 上传谷歌token
+ (void)pushGooogleTokenParam:(NSDictionary *)param andWithSuccess:(SuccessBlock)success failure:(FailureBlock)failure {
    [NetworkService postWithUrl:URL(kRequestPushGoogleToken) parameters:param needEncryption:isEntry success:success failure:failure];
}

/// 创建游客账号
+ (void)touristRegistWithDeviceId:(NSString *)deviceId success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (deviceId) {
        [param setValue:deviceId forKey:@"deviceId"];
    }
    [NetworkService postWithUrl:URL(kRequestTouristRegist) parameters:param needEncryption:isEntry success:success failure:failure];
}

+ (void)checkRouristHavaSyncDataWithDeviceId:(NSString *)deviceId success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (deviceId) {
        [param setValue:deviceId forKey:@"deviceId"];
    }
    [NetworkService postWithUrl:URL(kRequestCheckRouristSync) parameters:param needEncryption:isEntry success:success failure:failure];
}

+ (void)mergeDataWithUserId:(NSString *)userId touristDeviceId:(NSString *)deviceId success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (deviceId) {
        [param setValue:deviceId forKey:@"deviceId"];
    }
    if (userId) {
        [param setValue:userId forKey:@"userId"];
    }
    [NetworkService postWithUrl:URL(kRequestMergeTourist) parameters:param needEncryption:isEntry success:success failure:failure];
}

/// 通过邀请注册的用户绑定
/// - Parameters:
///   - inviterId: 邀请人id
///   - userId: 被邀请人id
///   - channel: 渠道
+ (void)bindInviteAccountWithInviterId:(NSString *)inviterId userId:(NSString *)userId channel:(NSString *)channel success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *invitation = [NSMutableDictionary dictionary];
    [invitation setObject:userId forKey:@"invitedId"];
    [invitation setObject:inviterId forKey:@"inviterId"];
    NSString *deviceId = [DeviceTool getUUIDInKeychain];
    [invitation setObject:deviceId forKey:@"deviceId"];
    [invitation setObject:channel forKey:@"channel"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"signUp" forKey:@"actionItem"];
    [param setObject:invitation forKey:@"invitation"];
    [NetworkService postWithUrl:URL(kRequestInvitationBind) parameters:param needEncryption:isEntry success:success failure:failure];
}
@end

