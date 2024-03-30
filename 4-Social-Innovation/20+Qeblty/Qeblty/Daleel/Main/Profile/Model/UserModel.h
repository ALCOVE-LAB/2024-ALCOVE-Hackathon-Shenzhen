//
//  UserModel.h
//  Gamfun
//
//  Created by mac on 2024/3/29.
//

#import "BaseModel.h"
#import "AuthInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : BaseModel

/// 网络请求使用 用户userId
@property(nonatomic,copy)NSString *userId;
/// 1男2女
@property(nonatomic,assign)NSInteger gender;
/// 生日
@property(nonatomic,copy)NSString *birthday;
/// 电话号
@property(nonatomic,copy)NSString *phoneNumber;
/// 注册类别:0手机号1facebook2谷歌账号3苹果账号4华为
@property(nonatomic,assign)NSInteger registerType;
/// 头像
@property(nonatomic,copy)NSString *headUrl;
/// 昵称
@property(nonatomic,copy)NSString *nickName;
/// 国家编码
@property(nonatomic,copy)NSString *countryCode;
/// 简介
@property(nonatomic,copy)NSString *introduction;
/// 用户使用token
@property(nonatomic,copy)NSString *token;
/// refreshToken
@property(nonatomic,copy)NSString *refreshToken;
/// 积分
@property(nonatomic,assign)NSInteger points;
/// 注册时间
@property(nonatomic,copy)NSString *registerDate;
///  是否是游客 0 否 1是
@property(nonatomic,assign)NSInteger touristFlag;
/// 佩戴的勋章
@property(nonatomic,copy)NSString *awardUrl;
/// 认证信息
@property (nonatomic, copy) NSArray <AuthInfoModel *> *authInfoList;
/// 签约信息
@property (nonatomic, copy) NSArray *signingList;

@end


NS_ASSUME_NONNULL_END
