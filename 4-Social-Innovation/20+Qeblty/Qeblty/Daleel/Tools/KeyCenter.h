//
//  KeyCenter.h
//  Gamfun
//
//  Created by mac on 2022/6/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyCenter : NSObject

/// yp - facebook 
+ (NSString *)facebookAppId;
+ (NSString *)facebookToken;

+ (NSString *)insAppId;
+ (NSString *)insAppSecrect;

+ (NSString *)tiktokAppKey;
+ (NSString *)tiktokAppSecrect;

+ (NSString *)snapAppId;
+ (NSString *)snapSecrect;

+ (NSString *)googleClientId;
+ (NSString *)googleClientSecret;

+ (NSString *)thinkingAppId;
+ (NSString *)thinkingServer;



@end

NS_ASSUME_NONNULL_END
