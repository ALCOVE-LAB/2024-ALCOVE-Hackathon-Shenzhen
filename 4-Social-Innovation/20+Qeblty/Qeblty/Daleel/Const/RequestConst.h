//
//  RequestConst.h
//  Gamfun
//
//  Created by mac on 2022/6/2.
//

/// 服务器域名
extern NSString * const kRequestServerDomain;
extern NSString * const kRequestWebDomain;
extern NSString * const kRequestDownloadBadgeDomain;

#pragma mark - ================= 首页 ===================
/// 首页接口    获取祈祷答题进度以及答题第一题预览
extern NSString * const kRequestHomePage;

#pragma mark - ================= 账号相关 注册登录 ===================
/// 刷新token
extern NSString * const kRequestRefreshToken;
/// 获取国家列表
extern NSString * const kRequestCountryList;
/// 查询手机号是否注册
extern NSString * const kRequestValidAccountId;
/// 登录
extern NSString * const kRequestLogin;
/// 获取验证码
extern NSString * const kRequestGetSmsCode;
/// 注册
extern NSString * const kRequestRegist;
/// 分享注册绑定
extern NSString * const kRequestInvitationBind;
/// 退出登录
extern NSString * const kRequestLogout;
/// 获取用户信息
extern NSString * const kRequestUserInfo;
/// 修改用户资料
extern NSString * const kRequestModifyUserInfo;
/// 上传文件
extern NSString * const kRequestUpLoadFile;
/// 删除账号
extern NSString * const kRequestDeleteAccount;
/// 获取用户删除账号信息
extern NSString * const kRequestGetDeleteInfo;
/// 修改用户密码
extern NSString * const kRequestModifyUserPSD;
/// 游客注册/登陆
extern NSString * const kRequestTouristRegist;
/// 合并账号（登陆账号合并游客账号）
extern NSString * const kRequestMergeTourist;
/// 检测游客账号是否有合并数据
extern NSString * const kRequestCheckRouristSync;

#pragma mark - ================= 祈祷相关 ===================
/// 未登录祈祷列表
extern NSString * const kRequestPrayerUnLog;
/// 登录祈祷列表
extern NSString * const kRequestPrayerLog;
/// 祈祷铃声列表
extern NSString * const kRequestPrayerRinging;
/// 签到
extern NSString * const kRequestPrayerCheckIn;
/// 签到日期
extern NSString * const kRequestPrayerCheckInDays;
/// 铃声解锁
extern NSString * const kRequestPrayerUnlockRing;
///设置默认铃声
extern NSString * const kRequestPrayerSetDefaultRing;
///游客模式设置默认铃声
extern NSString * const kRequestPrayerTouristSetDefaultRing;
///设置祈祷时间
extern NSString * const kRequestPrayerSetTimeBeforeOrDelay;
/// 记录推送信息
extern NSString * const kRequestPrayerPushMessage;
#pragma mark - ================== 勋章相关 ===================
/// 勋章列表
extern NSString * const kRequestAwardsList;
/// 最近获得勋章列表
extern NSString * const kRequestRecentAwardsList;
/// 查询勋章详情
extern NSString * const kRequestAwardDetail;

extern NSString * const kRequestCalendarRecords;

extern NSString * const kRequestCalendarDetailRecords;
/// 佩戴勋章
extern NSString * const kRequestWearAward;

#pragma mark - ================== Account/Profile ===================
/// 检查更新
extern NSString * const kRequestCheckUpdate;

extern NSString * const kRequestPushGoogleToken;

#pragma mark - ================== Question/Prayer ===================

/// 请求所有的答题
extern NSString * const kRequestAnswerStart;
/// 请求第一题
extern NSString * const kRequestAnswerFirstQuestion;
///  问题提示接口
extern NSString * const kRequestAnswerTips;
/// 答完一题上传
extern NSString * const kRequestQuestionEveryAnswer;
/// 获取碎片接口
extern NSString * const kRequestQuestionGetFragment;
/// 获取碎片合成卡片接口
extern NSString * const kRequestFragmentCompose;
/// 获取合成完的卡片列表
extern NSString * const kRequestCardsForTriviaChallenge;
/// 历史答题回顾
extern NSString * const kRequestQuestionReview;
/// 分享贺卡
extern NSString * const kRequestShareCard;
/// 获取月份答题记录
extern NSString * const kRequestQuestionRecord;
/// 保存答题提醒闹铃
extern NSString * const kRequestQuestionClockSave;
/// 答题提醒闹铃列表查询
extern NSString * const kRequestQuestionClockQuery;
/// 答题提醒闹删除
extern NSString * const kRequestQuestionClockDelete;
/// 答题修改提醒闹铃
extern NSString * const kRequestQuestionClockUpdate;
