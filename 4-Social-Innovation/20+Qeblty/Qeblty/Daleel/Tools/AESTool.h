//
//  AESTool.h
//  Gamfun
//
//  Created by mac on 2022/7/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AESTool : NSObject


/// AES 加密 返回加密后字符串
+ (NSString *)aesEncrypt:(NSString *)sourceStr;
/// AES 解密 返回对象
+ (NSDictionary *)aesDecrypt:(NSString *)secreStr;

@end

NS_ASSUME_NONNULL_END
