//
//  AwardsNetworkTool.h
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AwardsNetworkTool : NSObject

/// 获取勋章列表
+ (void)getAwardsListWithUid:(NSString *)userId success:(SuccessBlock)success failure:(FailureBlock)failure;

/// 最近获取勋章列表
+ (void)getRecentAwardsListWithUid:(NSString *)userId success:(SuccessBlock)success failure:(FailureBlock)failure;

/// 获取勋章详情(勋章获取时间列表)
+ (void)getAwardDetailWithAwardId:(NSString *)awardId awardActivityCode:(NSString *)awardActivityCode pageNumber:(NSInteger)pageNumber pageSize:(NSInteger)pageSize success:(SuccessBlock)success failure:(FailureBlock)failure;


/// 佩戴勋章
/// - Parameters:
///   - awardId: 勋章id
///   - awardUrl: 勋章url
///   - success: 成功回调
///   - failure: 失败回调
+ (void)wearAwardWithAwardId:(NSString *)awardId awardUrl:(NSString *)awardUrl success:(SuccessBlock)success failure:(FailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
