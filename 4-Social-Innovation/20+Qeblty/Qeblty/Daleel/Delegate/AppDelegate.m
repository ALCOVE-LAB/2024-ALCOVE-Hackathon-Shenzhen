//
//  AppDelegate.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "AppDelegate.h"
#import "CustomNavigationController.h"
#import "AppDelegate+ThirdParty.h"
#import "LoginViewController.h"
#import "BadgesViewController.h"
#import "GuideController.h"
#import "PrayerViewController.h"
#import "Daleel-Swift.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController = [self pickViewController];
    
    [self.window makeKeyAndVisible];

    

    
    // 三方配置
    [self registerThirdParty:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURL *url = userActivity.webpageURL;
        if ([url.absoluteString containsString:@"www.universallinks.qeblty.com"]) {
            NSArray *array = [url.absoluteString componentsSeparatedByString:@"?"];
            if (array.count > 1) {
                NSString *parmString = array[1];
                NSString *typeString = [parmString stringByReplacingOccurrencesOfString:@"type=" withString:@""];
                if ([typeString isEqualToString:@"share"]) {
                    @weakify(self);
                    [[AccountManager sharedInstance] getAccountSate:^(AccountManagerState state) {
                        @strongify(self);
                        if(state == AccountManagerState_Logined || state == AccountManagerState_GuestLogined) {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self enterBadgeWall];
                            });
                        }else {
                            [[AccountManager sharedInstance] pushLogin];
                        }
                    } addListenerWithKey:@"Appdelegate" listener:^(AccountManagerState state, id  _Nonnull msg) {
                        @strongify(self);
                        if(state == AccountManagerState_Logined || state == AccountManagerState_GuestLogined) {
                            [[AccountManager sharedInstance] removeListenerWithKey:@"Appdelegate"];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self enterBadgeWall];
                            });
                        }
                    }];
                }
            }
        }
    }
    return YES;
}
- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType{
    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([GIDSignIn.sharedInstance handleURL:url]) {
        return YES;
    }
    if ([[FBSDKApplicationDelegate sharedInstance] application:app
                                                       openURL:url
                                             sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                    annotation:options[UIApplicationOpenURLOptionsAnnotationKey]]) {
        return YES;
    }
    return NO;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
//    if (@available(iOS 14, *)) {
//        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
//        }];
//    }
}

/// 进入勋章墙
- (void)enterBadgeWall {
    BadgesViewController *vc = [[BadgesViewController alloc] init];
    [[UIViewController getCurrentViewController] pushViewController:vc];
}

#pragma mark --根控制器选择
// 选择应该显示的控制器
- (UIViewController *)pickViewController {
    // 判断 沙盒和当前的版本号是否一致
    BOOL isFirstInstall = [kUserDefaults boolForKey:kFirstInstall];
    if (isFirstInstall) {
        PrayerViewController *vc = [[PrayerViewController alloc] init];
        CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:vc];
        return nav;
    }else {
        //   不一致,显示新特性页面(引导页)
        GuideController* guide = [[GuideController alloc] init];
        return guide;
    }
}

@end
