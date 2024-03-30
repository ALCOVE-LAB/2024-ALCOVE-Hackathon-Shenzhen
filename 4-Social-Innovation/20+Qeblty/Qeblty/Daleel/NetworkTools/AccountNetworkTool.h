//
//  LoginNetworkTool.h
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AccountNetworkTool : NSObject

/// 刷新用户token
+ (void)refreshTokenSuccess:(SuccessBlock)success failure:(FailureBlock)fail;

/// 获取国家列表
+ (void)getCountryCode:(NSNumber *)pageNumber size:(NSNumber *)pageSize success:(SuccessBlock)success failure:(FailureBlock)failuer;

/// 验证手机号/三方uid 是否注注册  是否在注册冷静期内
+ (void)vaildAccountWithUid:(NSString *)userId phoneCountryCode:(NSString *_Nullable)countryCode accountType:(NSNumber *)accountType success:(SuccessBlock)success failure:(FailureBlock)failure ;

/// 发送验证码
/// @param phone 手机号
/// @param countryCode 国家代码
/// @param type 0注册1忘记密码 2绑定
+ (void)getCodeMessageWithPhoneNum:(NSString *)phone countryCode:(NSString *)countryCode type:(NSNumber *)type success:(SuccessBlock)success failure:(FailureBlock)failuer;

/// 注册
/// @param userId 手机号/三方id
/// @param countryCode 国家代码
/// @param code 验证码
/// @param password 密码
/// @param type 注册类别0手机号1facebook2谷歌账号3苹果账号4华为
/// 返回数据： refreshToken     刷新token  token    用户token   isPass    是否通过验证码验证
+ (void)registWithUid:(NSString *)userId countryCode:(NSString *)countryCode smsCode:(NSString *)code password:(NSString *_Nullable)password type:(NSNumber *)type success:(SuccessBlock)success failure:(FailureBlock)failure;

/// 账号登录(手机号和三方)
/// @param loginUid 手机号或三方id
/// @param countryCode 国家代码
/// @param password 密码
+ (void)loginWithLoginUid:(NSString *)loginUid countryCode:(NSString *_Nullable)countryCode password:(NSString *_Nullable)password loginType:(NSNumber *_Nullable)loginType success:(SuccessBlock)success failure:(FailureBlock)failure;

/// 用户退出登录
+ (void)logoutSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

/// 获取用户信息
+ (void)getUserInfo:(SuccessBlock)success failure:(FailureBlock)failure;

/// 修改用户信息
/// - Parameters:
///   - headUrl: 头像
///   - nickName: 昵称
///   - birthday: 生日
///   - gender: 性别 1男 2女
///   - introduction: 简介
+ (void)updateUserInfo:(NSString *_Nullable)headUrl nickName:(NSString *_Nullable)nickName birthday:(NSString *_Nullable)birthday gender:(int)gender introduction:(NSString *_Nullable)introduction success:(SuccessBlock)success failure:(FailureBlock)failure;

/// 删除账号
+ (void)deleteAccountSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

/// 获取用户删除信息
+ (void)getDeleteInfoSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

/// 修改密码
+ (void)updateUserPassword:(NSString *)password Success:(SuccessBlock)success failure:(FailureBlock)failure;

/// 检查版本更新
+ (void)checkUpdateSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

/// 上传googleToken
+ (void)pushGooogleTokenParam:(NSDictionary *)param andWithSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

/// 游客注册登录
+ (void)touristRegistWithDeviceId:(NSString *)deviceId success:(SuccessBlock)success failure:(FailureBlock)failure;

/// 合并账号
+ (void)mergeDataWithUserId:(NSString *)userId touristDeviceId:(NSString *)deviceId success:(SuccessBlock)success failure:(FailureBlock)failure;

/// 检测游客账号是否有合并数据
+ (void)checkRouristHavaSyncDataWithDeviceId:(NSString *)deviceId success:(SuccessBlock)success failure:(FailureBlock)failure;

/// 通过邀请注册的用户绑定
/// - Parameters:
///   - inviterId: 邀请人id
///   - userId: 被邀请人id
///   - channel: 渠道
+ (void)bindInviteAccountWithInviterId:(NSString *)inviterId userId:(NSString *)userId channel:(NSString *)channel success:(SuccessBlock)success failure:(FailureBlock)failure;
@end

NS_ASSUME_NONNULL_END
