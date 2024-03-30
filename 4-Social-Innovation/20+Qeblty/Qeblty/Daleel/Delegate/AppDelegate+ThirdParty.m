//
//  AppDelegate+ThirdParty.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "AppDelegate+ThirdParty.h"
#import <MOBFoundation/MobSDK+Privacy.h>
#import <ShareSDK/ShareSDK.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "AccountManager.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "PrayerViewController.h"
@implementation AppDelegate (ThirdParty)

- (void)registerThirdParty:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupGooglePush];
    [self initMob];
    // facebook
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [kUser setIQkeyboard:YES];
}

#pragma mark - MobShare
- (void)initMob {
    // MobSDK
    [MobSDK uploadPrivacyPermissionStatus:YES onResult:^(BOOL success) {
    }];
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        [platformsRegister setupFacebookWithAppkey:[KeyCenter facebookAppId] appSecret:[KeyCenter facebookToken] displayName:@"Qeblty"];
//        [platformsRegister setupTikTokByAppKey:[KeyCenter tiktokAppKey] appSecret:[KeyCenter tiktokAppSecrect]];
        [platformsRegister setupInstagramWithClientId:[KeyCenter insAppId] clientSecret:[KeyCenter insAppSecrect] redirectUrl:@"https://privacy.gamfunapp.com/privacy-policy"];
//        [platformsRegister setSnapChatClientId:[KeyCenter snapAppId] clientSecret:[KeyCenter snapSecrect] redirectUrl:@"gamfunSnapchat"];
    }];
}



#pragma mark - google push
- (void)setupGooglePush {
    [FIRMessaging messaging].delegate = self;
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
}

/// 获取注册令牌
- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    DLog(@"fcmToken===%@",fcmToken);
    if (fcmToken.length > 0) {
        [[AccountManager sharedInstance] saveFcmToken:fcmToken];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //firebase
    [FIRMessaging messaging].APNSToken = deviceToken;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    DLog(@"didReceiveRemoteNotification : %@",userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
    if(application.applicationState == UIApplicationStateInactive) {
    }
}

#pragma mark - UNUserNotificationCenterDelegate
/// app处在前台收到推送消息执行的方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)) {
    NSDictionary *userInfo = notification.request.content.userInfo;
    DLog(@"willPresentNotification userInfo -> %@", userInfo);
    // 远程消息收到后发送通知remoteMessageNotification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"remoteMessageNotification" object:nil userInfo:userInfo];
        
    /// 前台展示通知，可添加三种提醒（可自行选择几种实现，不写alert则不会有横幅提醒）
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

/// ios 10以后系统，点击通知栏 app执行的方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    
    DLog(@"userInfo -> %@", userInfo);
    
    
    
    /// 如果应用在前台
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        [self handleRmoteMessage:userInfo withactive:YES];
        return;
    }
    [self handleRmoteMessage:userInfo withactive:NO];
    completionHandler();
}

- (void)handleRmoteMessage:(NSDictionary *)dic withactive:(BOOL)isActive {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    PrayerViewController *vc = [[PrayerViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [appDelegate.window setRootViewController:nav];
    [appDelegate.window makeKeyAndVisible];
}
#pragma mark - AppsFlyer
- (void)appsFlyerInitialize {
    if ([kUserDefaults boolForKey:kNotificationLimit]) {
        if (@available(iOS 10, *)) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            }];
        }
        
        else {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}


@end
