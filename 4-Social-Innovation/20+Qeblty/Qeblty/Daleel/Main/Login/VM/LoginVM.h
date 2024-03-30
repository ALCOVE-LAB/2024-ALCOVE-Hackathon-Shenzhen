//
//  LoginVM.h
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "BaseVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginVM : BaseVM

/// 三方认证
- (void)thirdPartAuthorizeWithType:(AccountLoginType)loginType;

/// 登陆
- (void)LoginWithUid:(NSString *)userId countryCode:(NSString *_Nullable)countryCode password:(NSString *_Nullable)psd loginType:(AccountLoginType)type;

/// 注册
- (void)registWithUid:(NSString *)userId registType:(AccountLoginType)type countryCode:(NSString *_Nullable)countryCode password:(NSString *_Nullable)psd smsCode:(NSString *_Nullable)code;

/// 判断当前的设备的游客账号是否有可以合并的数据
- (void)checkRouristHavaSyncData;

/// 获取验证码
- (void)getSmsCodeWithPhoneNum:(NSString *)phoneNum countryCode:(NSString *)countryCode type:(AccountLoginType)type;

/// 验证手机号 三方uid 是否注册过 是否注销冷静期内
- (void)vaildAccountWithUid:(NSString *)uId phoneCountryCode:(NSString *_Nullable)countryCode accountType:(AccountLoginType)type;

/// 获取国家列表
- (void)getPhoneCountryCodeList;

@end

NS_ASSUME_NONNULL_END
