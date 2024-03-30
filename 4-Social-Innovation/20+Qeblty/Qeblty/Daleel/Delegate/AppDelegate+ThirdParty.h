//
//  AppDelegate+ThirdParty.h
//  Daleel
//
//  Created by mac on 2022/12/5.
//

#import "AppDelegate.h"
#import <Firebase.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GoogleSignIn/GoogleSignIn.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (ThirdParty)<FIRMessagingDelegate,UNUserNotificationCenterDelegate>

- (void)registerThirdParty:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

@end

NS_ASSUME_NONNULL_END
