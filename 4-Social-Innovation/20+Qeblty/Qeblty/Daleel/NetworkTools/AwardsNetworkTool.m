//
//  AwardsNetworkTool.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "AwardsNetworkTool.h"

@implementation AwardsNetworkTool

/// 获取勋章列表
+ (void)getAwardsListWithUid:(NSString *)userId success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (userId) {
        [param setObject:userId forKey:@"userId"];
    }
    [NetworkService postWithUrl:URL(kRequestAwardsList) parameters:param needEncryption:isEntry success:success failure:failure];
}

/// 最近获取勋章列表
+ (void)getRecentAwardsListWithUid:(NSString *)userId success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (userId) {
        [param setObject:userId forKey:@"userId"];
    }
    [NetworkService postWithUrl:URL(kRequestRecentAwardsList) parameters:param needEncryption:isEntry success:success failure:failure];
}

+ (void)getAwardDetailWithAwardId:(NSString *)awardId awardActivityCode:(NSString *)awardActivityCode pageNumber:(NSInteger)pageNumber pageSize:(NSInteger)pageSize success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (awardId) {
        [param setObject:awardId forKey:@"awardId"];
    }
    if (awardActivityCode) {
        [param setObject:awardActivityCode forKey:@"awardActivityCode"];
    }
    [param setObject:@(pageNumber) forKey:@"pageNumber"];
    [param setObject:@(pageSize) forKey:@"pageSize"];
    [NetworkService postWithUrl:URL(kRequestAwardDetail) parameters:param needEncryption:isEntry success:success failure:failure];
}
/// 佩戴勋章
+ (void)wearAwardWithAwardId:(NSString *)awardId awardUrl:(NSString *)awardUrl success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (awardId) {
        [param setObject:awardId forKey:@"awardId"];
    }
    if (awardUrl) {
        [param setObject:awardUrl forKey:@"awardUrl"];
    }
    [NetworkService postWithUrl:URL(kRequestWearAward) parameters:param needEncryption:isEntry success:success failure:failure];
}
@end
