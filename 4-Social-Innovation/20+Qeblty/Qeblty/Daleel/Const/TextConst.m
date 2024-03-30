//
//  TextConst.m
//  Gamfun
//
//  Created by mac on 2022/6/2.
//


/// adjust deviceId
NSString * const kDeviceId = @"deviceId";
/// fcm token
NSString * const kFcmToken = @"googleToken";
/// 三方收取
NSString * const kThirdPartAuthorizeSuccess = @"kThirdPartAuthorizeSuccess";
/// 三方授权取消
NSString * const kThirdPartAuthorizeCancel = @"kThirdPartAuthorizeCancel";
/// 三方授权失败
NSString * const kThirdPartAuthorizeError = @"kThirdPartAuthorizeError";
/// 登录成功
NSString * const kLoginSuccess = @"kLoginSuccess";
/// 登录失败
NSString * const kLoginError = @"kLoginError";
/// 注册成功
NSString * const kRegistSuccess = @"kRegistSuccess";
/// 注册失败
NSString * const kRegistError = @"kRegistError";
/// 验证码发送
NSString * const kSendSmsCodeSuccess = @"kSendSmsCodeSuccess";
/// 验证码发送失败
NSString * const kSendSmsCodeError = @"kSendSmsCodeError";
/// 验证账号注册
NSString * const kVaildAccountRegisted = @"kVaildAccountRegisted";
/// 验证账号未注册
NSString * const kVaildAccountUnRegisted = @"kVaildAccountUnRegisted";
/// 验证账号已删除
NSString * const kVaildAccountDeleted = @"kVaildAccountDeleted";
/// 验证账号错误
NSString * const kVaildAccountError = @"kVaildAccountError";
/// 国家列表获取
NSString * const kPhoneCountryCodeListSuccess = @"kPhoneCountryCodeListSuccess";
/// 国家列表获取
NSString * const kPhoneCountryCodeListError = @"kPhoneCountryCodeListError";
/// 是否有需要合并数据 YES
NSString * const kCheckUserDataNeedMerge = @"kCheckUserDataNeedMerge";
/// 是否有需要合并数据 NO
NSString * const kCheckUserDataNoNeedMerge = @"kCheckUserDataNoNeedMerge";
/// 是否有合并数据接口调用失败
NSString * const kCheckUserDataMergeError = @"kCheckUserDataMergeError";
/// 登录成功
NSString * const kLogoutSuccess = @"kLogoutSuccess";
/// 下载地址
NSString * const kDownloadAppUrl = @"https://apps.apple.com/us/app/gamfun/id1591231528";
/// 佩戴勋章成功
NSString * const kWearBadgeSuccess = @"kWearBadgeSuccess";
/// 邀请人id userdefaultskey
NSString * const kInviterId = @"kInviter_id_key";
/// 邀请渠道
NSString * const kInviteChannel = @"kInvite_channel_key";

#pragma mark - 埋点
/// 登录
NSString * const kThinkLogin = @"login_click";
/// 进入登录界面
NSString * const kThinkLoginEnter = @"phone_login_enter";
/// 进入输入密码
NSString * const kThinkLoginPSD = @"phone_signin_enter";
/// 进入注册
NSString * const kThinkLoginSinup = @"phone_signup_enter";
/// 进入登录页面
NSString * const kThinkLoginPage = @"login_enter";
/// 取消登录
NSString * const kThinkCanclePage = @"login_cancel";
/// 成功接受推送消息
NSString * const kThinkReceiveMessage = @"push_receive";
/// 推送转换
NSString * const kThinkMessageConvert = @"push_convert";
/// 切换日历
NSString * const kThinkCalendarSwitch = @"calendar_switch";
/// 贺卡合成
NSString * const kThinkTriviaCompose = @"trivia_compose";
/// 浏览贺卡
NSString * const kThinkTriviaCheckCard = @"trivia_check_card";
/// 埋点进入答题回顾
NSString * const kTriviaReviewEnter = @"trivia_review_enter";
/// 埋点事件进入答题
NSString * const kTriviaChallengeEnter = @"trivia_challenge_enter";
/// 埋点事件进入贺卡搜集页
NSString * const kTriviaCollectEnter = @"trivia_collect_enter";
/// 埋点事件离开挑战
NSString * const kTriviaLeaveChallenge = @"trivia_leave_challenge";
/// 埋点事件答题回顾
NSString * const kTriviaReviewQuestion = @"trivia_review_question";
/// 埋点事件点击提示
NSString * const kTriviaHintClick = @"trivia_hint_click";
/// 埋点事件分享
NSString * const kShare = @"share";
/// 勋章缓存key
NSString * const kBadgeListCacheKey = @"badge_list_cache_key";
/// 新获得勋章缓存key
NSString * const kNewBadgesCacheKey = @"new_badge_list_cache_key";

#pragma mark - Unity 交互
/// Unity 对象名
NSString * const kUnityObjectName = @"GameEnter";

NSString * const kUnityToNative = @"kUnityToNative";

/// 初始化徽章
NSString * const kUnityChangeBadge = @"ChangeBadge";
/// 勋章详情返回
NSString * const kBadgeDetailGoBack = @"BadgeBigToSmall";
/// 勋章佩戴成功通知unity
NSString * const kWearingBadge = @"WearFinish";
