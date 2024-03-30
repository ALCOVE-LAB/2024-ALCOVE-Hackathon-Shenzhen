//
//  PrayerNetworkTool.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "PrayerNetworkTool.h"

@implementation PrayerNetworkTool

+ (void)getPrayerListLogWithParam:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failuer {
    
    [NetworkService postWithUrl:URL(kRequestPrayerLog) parameters:param needEncryption:isEntry success:success failure:failuer];
}

+ (void)getPrayerRingingListWithParam:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failuer {
    
    [NetworkService postWithUrl:URL(kRequestPrayerRinging) parameters:param needEncryption:isEntry success:success failure:failuer];
}

+ (void)checkIn:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failuer {
    [NetworkService postWithUrl:URL(kRequestPrayerCheckIn) parameters:param needEncryption:isEntry success:success failure:failuer];
}

+ (void)inviteCheckInSuccess:(SuccessBlock)success failure:(FailureBlock)failuer {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"checkIn" forKey:@"actionItem"];
    [NetworkService postWithUrl:URL(kRequestInvitationBind) parameters:param needEncryption:isEntry success:success failure:failuer];
}
+ (void)checkInDays:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failuer {
    [NetworkService postWithUrl:URL(kRequestPrayerCheckInDays) parameters:param needEncryption:isEntry success:success failure:failuer];
}

+ (void)unlockRingring:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failuer {
    [NetworkService postWithUrl:URL(kRequestPrayerUnlockRing) parameters:param needEncryption:isEntry success:success failure:failuer];
}

+ (void)setDefaultRing:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failuer {
    [NetworkService postWithUrl:URL(kRequestPrayerSetDefaultRing) parameters:param needEncryption:isEntry success:success failure:failuer];
}

+ (void)touristSetDefaultRing:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failuer {
    [NetworkService postWithUrl:URL(kRequestPrayerTouristSetDefaultRing) parameters:param needEncryption:isEntry success:success failure:failuer];
}

+ (void)setPrayerTimeDelayOrBefore:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failuer {
    [NetworkService postWithUrl:URL(kRequestPrayerSetTimeBeforeOrDelay) parameters:param needEncryption:isEntry success:success failure:failuer];
}

+ (void)getcalendarListWithParam:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failuer {
    [NetworkService postWithUrl:URL(kRequestCalendarDetailRecords) parameters:param needEncryption:isEntry success:success failure:failuer];
}

+ (void)setPushMessageWithParam:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failuer {
    [NetworkService postWithUrl:URL(kRequestPrayerPushMessage) parameters:param needEncryption:isEntry success:success failure:failuer];
}

@end
