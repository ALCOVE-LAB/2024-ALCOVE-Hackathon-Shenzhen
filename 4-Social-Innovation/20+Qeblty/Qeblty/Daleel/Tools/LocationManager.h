//
//  LocationManager.h
//  Daleel
//
//  Created by mac on 2022/12/7.
//

/**
 定位管理 （多代理支持）
 包括 获取权限 获取经纬 国家  指北heading
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LocationManagerDelegate <NSObject>

// 需要指北针校验
- (BOOL)locationManagerShouldDisplayHeadingCalibration;

// 指北针回调
- (void)locationManagerDidUpdateHeading:(CLHeading *)newHeading;

@end

@interface LocationManager : NSObject

+ (instancetype)sharedInstance;

/// 申请权限 并 监听 权限变化
- (void)requestAuthorizationAndAddListenerWithKey:(NSString *)keyName listenerBlock:(void(^)(BOOL success, CLAuthorizationStatus status))block;

/// 移除监听
- (void)removeAuthorizationListenerWithKey:(NSString *)keyName;

/// 获取经纬度 国家信息 (一次性的)
- (void)getLocation:(void(^)(CLLocation *location, NSString *latitude, NSString *longitudeStr, NSString *city))locationBlock fail:(void(^)(NSError *error))failBlock;

/// 开始指北  需要配置代理 实时获取
- (void)startUpdateHeading;

- (void)stopUpdateHeading;

/// 添加代理
- (void)addDelegate:(id<LocationManagerDelegate>)receiver;

/// 移除代理
- (void)removeDelegate:(id<LocationManagerDelegate>)receiver;

@end

NS_ASSUME_NONNULL_END
