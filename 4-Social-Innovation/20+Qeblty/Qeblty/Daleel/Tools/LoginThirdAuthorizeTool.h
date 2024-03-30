//
//  LoginThirdAuthorizeTool.h
//  Daleel
//
//  Created by mac on 2022/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginThirdAuthorizeTool : NSObject

/// 三方认证
/// @param type  认证平台
/// @param successBlock 成功回调 authorizedUser返回的用户信息
/// @param cancelBlock 取消回调  （这个回调测试 不太准确）
/// @param failBlock 失败回调
+ (void)authorizeWithPlatformType:(AccountLoginType)type
                          success:(void(^_Nullable)(NSString *userId, AccountLoginType type))successBlock
                      cancelShare:(void(^_Nullable)(void))cancelBlock
                             fail:(void(^_Nullable)(NSError *_Nullable error))failBlock;

@end

NS_ASSUME_NONNULL_END
