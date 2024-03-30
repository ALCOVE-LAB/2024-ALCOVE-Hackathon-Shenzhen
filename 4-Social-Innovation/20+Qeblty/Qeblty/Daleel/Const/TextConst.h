//
//  TextConst.h
//  Gamfun
//
//  Created by mac on 2022/6/2.
//


/// adjust deviceId
extern NSString * const kDeviceId;
/// fcm token
extern NSString * const kFcmToken;
/// 三方授权成功
extern NSString * const kThirdPartAuthorizeSuccess;
/// 三方授权取消
extern NSString * const kThirdPartAuthorizeCancel;
/// 三方授权失败
extern NSString * const kThirdPartAuthorizeError;
/// 登录成功
extern NSString * const kLoginSuccess;
/// 登录失败
extern NSString * const kLoginError;
/// 注册成功
extern NSString * const kRegistSuccess;
/// 注册失败
extern NSString * const kRegistError;
/// 验证码发送
extern NSString * const kSendSmsCodeSuccess;
/// 验证码发送失败
extern NSString * const kSendSmsCodeError;
/// 验证账号注册
extern NSString * const kVaildAccountRegisted;
/// 验证账号未注册
extern NSString * const kVaildAccountUnRegisted;
/// 验证账号已删除
extern NSString * const kVaildAccountDeleted;
/// 验证账号错误
extern NSString * const kVaildAccountError;
/// 国家列表获取
extern NSString * const kPhoneCountryCodeListSuccess;
/// 国家列表获取
extern NSString * const kPhoneCountryCodeListError;
/// 是否有需要合并数据 YES
extern NSString * const kCheckUserDataNeedMerge;
/// 是否有需要合并数据 NO
extern NSString * const kCheckUserDataNoNeedMerge;
/// 是否有需要合并数据 接口调用出错
extern NSString * const kCheckUserDataMergeError;
/// 登录成功
extern NSString * const kLogoutSuccess;
/// app下载地址
extern NSString * const kDownloadAppUrl;
/// 佩戴勋章成功
extern NSString * const kWearBadgeSuccess;
/// 邀请人id userdefaultskey
extern NSString * const kInviterId;
/// 邀请渠道
extern NSString * const kInviteChannel;

#pragma mark - 埋点
/// 登录
extern NSString * const kThinkLogin;
/// 进入登录界面
extern NSString * const kThinkLoginEnter;
/// 进入输入密码
extern NSString * const kThinkLoginPSD;
/// 进入注册
extern NSString * const kThinkLoginSinup;
/// 进入登录页面
extern NSString * const kThinkLoginPage;
/// 取消登录页面
extern NSString * const kThinkCanclePage;
/// 成功接受推送消息
extern NSString * const kThinkReceiveMessage;
/// 推送转换
extern NSString * const kThinkMessageConvert;
/// 切换日历
extern NSString * const kThinkCalendarSwitch;
/// 贺卡合成
extern NSString * const kThinkTriviaCompose;
/// 浏览贺卡
extern NSString * const kThinkTriviaCheckCard;
/// 埋点事件
extern NSString * const kTriviaChallengeEnter;
/// 埋点事件进入贺卡搜集页
extern NSString * const kTriviaCollectEnter;
/// 埋点事件离开挑战
extern NSString * const kTriviaLeaveChallenge;
/// 埋点答题回顾
extern NSString * const kTriviaReviewEnter;
/// 埋点事件答题回顾
extern NSString * const kTriviaReviewQuestion;
/// 埋点事件点击提示
extern NSString * const kTriviaHintClick;
/// 埋点事件分享
extern NSString * const kShare;
/// 勋章缓存key
extern NSString * const kBadgeListCacheKey;
/// 新获得勋章缓存key
extern NSString * const kNewBadgesCacheKey;

#pragma mark - Unity 交互
/// Unity 对象名
extern NSString * const kUnityObjectName;

extern NSString * const kUnityToNative;
/// 加载勋章
extern NSString * const kUnityChangeBadge;
/// 勋章详情返回
extern NSString * const kBadgeDetailGoBack;
/// 佩戴勋章成功通知unity
extern NSString * const kWearingBadge;

