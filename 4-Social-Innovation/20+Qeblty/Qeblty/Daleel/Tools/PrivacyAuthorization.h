//
//  PrivacyAuthorization.h
//  Gamfun
//
//  Created by mac on 2022/7/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrivacyAuthorization : NSObject

/**
 相机授权状态
 */
+ (BOOL)authorizationStatusForMediaTypeCamera;

/**
 相册授权状态
 */
+ (BOOL)authorizationStatusForPhotoLibrary;

/**
 跳转到设置
 */
+ (void)openSetting;


@end

NS_ASSUME_NONNULL_END
