//
//  PrayerNetworkTool.h
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrayerNetworkTool : NSObject

/// 获取登录时候祈祷列表
+ (void)getPrayerListLogWithParam:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failuer;

/// 获取铃声列表 
+ (void)getPrayerRingingListWithParam:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failuer;

/// 签到接口
+ (void)checkIn:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failuer;

/// 被邀请人签到 (不用过分在意结果)
+ (void)inviteCheckInSuccess:(SuccessBlock)success failure:(FailureBlock)failuer;

/// 签到日期传递
+ (void)checkInDays:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failuer;

/// 解锁铃声接口
+ (void)unlockRingring:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failuer;

/// 设置默认铃声
+ (void)setDefaultRing:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failuer;

/// 游客模式设置默认铃声
+ (void)touristSetDefaultRing:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failuer;

/// 设置祈祷时间提前或延后
+ (void)setPrayerTimeDelayOrBefore:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failuer;

/// 获取日历详情列表
+ (void)getcalendarListWithParam:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failuer;

/// 记录推送信息
+ (void)setPushMessageWithParam:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failuer;

@end

NS_ASSUME_NONNULL_END
