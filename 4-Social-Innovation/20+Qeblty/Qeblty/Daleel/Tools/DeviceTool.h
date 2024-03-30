//
//  DeivceTool.h
//  Gamfun
//
//  Created by mac on 2022/7/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceTool : NSObject

/// app版本
+ (NSString *)appVersion;
/// buildVersion
+ (NSString *)buildVersion;
/// 手机名称
+ (NSString *)deviceName;
/// 手机系统版本
+ (NSString *)systemVersion;
/// 设备型号
+ (NSString *)deviceModel;

/// 获取钥匙串中的UUID 不刷机 不会变
+ (NSString *)getUUIDInKeychain;
+ (void)deleteKeyChain;

+ (NSDictionary *)getInfoDictionary;
+ (NSString *)appName;
/// 获取缓存大小
+ (NSString *)getCaceSize;
/// 清理缓存
+ (BOOL)clearCache;
/// 跟当前版本比较, yes 有新版本
+ (BOOL)compareVesionWithServerVersion:(NSString *)version;
+ (void)checkUpdateVeersion;

@end

NS_ASSUME_NONNULL_END
