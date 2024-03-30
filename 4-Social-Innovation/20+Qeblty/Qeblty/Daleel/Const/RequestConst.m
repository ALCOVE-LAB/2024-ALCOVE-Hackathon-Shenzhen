//
//  RequestConst.m
//  Gamfun
//
//  Created by mac on 2022/6/2.
//


/// 服务器域名
#if DEBUG
/// 开发专用服务器
//NSString * const kRequestServerDomain = @"http://71.131.214.250:8082";
//NSString * const kRequestWebDomain = @"http://71.131.214.250:8090/agreement/#";
//NSString * const kRequestDownloadBadgeDomain = @"https://api.qeblty.com/u3d/";
#warning mark - 6.1号正式服务地址
//NSString * const kRequestServerDomain = @"https://api.qeblty.com";
//NSString * const kRequestWebDomain = @"https://www.web.qeblty.com/agreement/#";
//NSString * const kRequestDownloadBadgeDomain = @"http://resource.qeblty.com/test/gameU3dBadge/";
/// 测试专用服务器
NSString * const kRequestServerDomain = @"https://qebltyapi.test.gamfunapp.com";
NSString * const kRequestWebDomain = @"https://qebltytestweb.gamfunapp.com/agreement/#";
NSString * const kRequestDownloadBadgeDomain = @"http://resource.qeblty.com/test/gameU3dBadge/";
#else
/// 正式服
//NSString * const kRequestServerDomain = @"https://www.qeblty.com";
//NSString * const kRequestWebDomain = @"https://www.web.qeblty.com/agreement/#";
NSString * const kRequestServerDomain = @"https://api.qeblty.com";
NSString * const kRequestWebDomain = @"https://www.web.qeblty.com/agreement/#";
NSString * const kRequestDownloadBadgeDomain = @"http://resource.qeblty.com/test/gameU3dBadge/";
#endif



#pragma mark - ================= 首页 ===================

NSString * const kRequestHomePage = @"/user/home-page";

#pragma mark - ================= login/register ===================
/// 刷新token
NSString * const kRequestRefreshToken = @"/user/refresh-token";
/// 获取国家列表
NSString * const kRequestCountryList = @"/user/find-country-code";
/// 查询手机号是否注册
NSString * const kRequestValidAccountId = @"/user/validate-account";
/// 登陆
NSString *const kRequestLogin = @"/user/daleel-login";
/// 获取验证码
NSString * const kRequestGetSmsCode = @"/user/sms-send";
/// 校验验证码 / 或者注册
NSString * const kRequestRegist = @"/user/register";
/// 邀请注册绑定
NSString * const kRequestInvitationBind = @"/activity/signing-invitation-transcribe";
/// 退出登录
NSString * const kRequestLogout = @"/user/log-out";
/// 获取用户信息
NSString * const kRequestUserInfo = @"/user/get-user-info";
/// 修改用户资料
NSString * const kRequestModifyUserInfo = @"/user/user-info-modify";
/// 上传文件
NSString * const kRequestUpLoadFile = @"/user/upload-file";
/// 删除账号
NSString * const kRequestDeleteAccount = @"/user/log-off";
/// 获取用户删除账号信息
NSString * const kRequestGetDeleteInfo = @"/user/user-log-off-info";
/// 修改用户密码
NSString * const kRequestModifyUserPSD = @"/user/modify-password";
/// 游客注册/登陆
NSString * const kRequestTouristRegist = @"/user/tourist-login";
/// 合并账号（登陆账号合并游客账号）
NSString * const kRequestMergeTourist = @"/user/tourist-user-info-sync";
/// 判断游客是否有可以合并的数据
NSString * const kRequestCheckRouristSync = @"/user/check-tourist-sync";

#pragma mark - ================== Prayer ===================
/// 祈祷项列表（不登陆）
NSString * const kRequestPrayerUnLog = @"/prayer/prayer-list";

/// 祈祷项列表（登陆）
NSString * const kRequestPrayerLog = @"/prayer/find-user-prayer-list";

/// 获取祈祷铃声
NSString * const kRequestPrayerRinging = @"/prayer/find-prayer-ringing";

/// 签到
NSString * const kRequestPrayerCheckIn = @"/prayer/check-in";

/// 签到值传递
NSString * const kRequestPrayerCheckInDays = @"/user/reset-check-in-days";

/// 铃声解锁
NSString * const kRequestPrayerUnlockRing = @"/prayer/unlock-ringring";
/// 设置铃声
NSString * const kRequestPrayerSetDefaultRing = @"/prayer/default-ringing-save";
/// 游客模式设置铃声
NSString * const kRequestPrayerTouristSetDefaultRing = @"/prayer/default-tourist-ringing-save";
/// 设置祈祷时间
NSString * const kRequestPrayerSetTimeBeforeOrDelay = @"/prayer/reminder-time-save";
/// 记录推送信息
NSString * const kRequestPrayerPushMessage = @"/prayer/pre-prayer-push";


#pragma mark - ================== 勋章相关 ===================
/// 勋章列表
NSString * const kRequestAwardsList = @"/award/find-user-award-list";
/// 最近获得勋章列表
NSString * const kRequestRecentAwardsList = @"/award/find-user-award-recent";
/// 查询勋章详情
NSString * const kRequestAwardDetail = @"/award/find-user-award-record-detail";
/// 佩戴勋章
NSString * const kRequestWearAward = @"/award/wearing-award";

#pragma mark - ================== Calendar ===================
/// 查询用户某一段时间的行为记录
NSString *const kRequestCalendarRecords = @"/user/find-user-action-record-days";

/// 查询用户某一天的行为记录
NSString *const kRequestCalendarDetailRecords = @"/user/find-user-action-record-day";

#pragma mark - ================== Account/Profile ===================
/// 检查更新
NSString * const kRequestCheckUpdate = @"/user/get-version";

/// 上传谷歌token
NSString * const kRequestPushGoogleToken = @"/user/escalation-google-token";


#pragma mark - ================== Question/Prayer ===================

/// 请求所有的答题
NSString * const kRequestAnswerStart = @"/activity/answer-start";
/// 请求第一题
NSString * const kRequestAnswerFirstQuestion = @"/activity/answer-first-question";
/// 问题提示接口
NSString * const kRequestAnswerTips = @"/activity/answer-tips";
/// 答完一题上传接口
NSString * const kRequestQuestionEveryAnswer = @"/activity/current-question-end";
/// 获取碎片数量接口
NSString * const kRequestQuestionGetFragment = @"/activity/get-fragment";
/// 获取碎片合成卡片接口
NSString * const kRequestFragmentCompose = @"/activity/synthesis-card";
/// 获取合成完的卡片列表
NSString * const kRequestCardsForTriviaChallenge = @"/activity/get-card";
/// 历史答题回顾
NSString * const kRequestQuestionReview = @"/activity/answer-review";
/// 分享贺卡
NSString * const kRequestShareCard = @"/activity/share-card";
/// 获取月份答题记录
NSString * const kRequestQuestionRecord = @"/activity/answer-log";
/// 保存答题提醒闹铃
NSString * const kRequestQuestionClockSave = @"/activity/greeting-card-clock-save";
/// 答题提醒闹铃列表查询
NSString * const kRequestQuestionClockQuery = @"/activity/greeting-card-clock-query";
/// 答题提醒闹删除
NSString * const kRequestQuestionClockDelete = @"/activity/greeting-card-clock-del";
/// 答题修改提醒闹铃
NSString * const kRequestQuestionClockUpdate = @"/activity/greeting-card-clock-update";


