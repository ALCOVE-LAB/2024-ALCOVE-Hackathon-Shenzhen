//
//  LocalNotificationManager.m
//  Daleel
//
//  Created by mac on 2022/12/9.
//

#import "LocalNotificationManager.h"
#import <UserNotifications/UserNotifications.h>
#import "AppDelegate.h"
//#import "PrayerViewController.h"

//static LocalNotificationManager *localNotificationManager = nil;
@interface LocalNotificationManager ()

@end

@implementation LocalNotificationManager

/** 添加本地推送通知*/
+ (void)dl_addLocalNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body timeInterval:(long)timeInterval identifier:(NSString *)identifier userInfo:(NSDictionary *)userInfo repeats:(int)repeats sound:(NSString *)sound{
    if (title.length == 0 || body.length == 0 || identifier.length == 0) {
        return;
    }
    if ([kUserDefaults boolForKey:kNotificationLimit]) {
        if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
                if (!error) {
                    DLog(@"request authorization succeeded!");
                }
            }];
            //        center.delegate = [LocalNotificationManager localNotificationManager];
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            // 标题
            if (title.length) {
                content.title = title;
            }
            if (subTitle.length) {
                content.subtitle = subTitle;
            }
            // 内容
            if (body.length) {
                content.body = body;
            }
            if (userInfo != nil) {
                content.userInfo = userInfo;
            }
            
            NSString *soundStr = [[sound componentsSeparatedByString:@"."] firstObject];
            
            if (kUser.isLogin) {
                if ([userInfo valueForKey:@"ringName"]) {
                    NSString *ringStr = [userInfo valueForKey:@"ringName"];
                    if ([ringStr isEqualToString:@"None"] || [ringStr isEqualToString:@"Silent"]) {
                        
                    }else{
                        // 声音
                        content.sound = [UNNotificationSound soundNamed:[NSString stringWithFormat:@"%@.m4a",soundStr]];
                    }
                }else{
                    // 声音
                    content.sound = [UNNotificationSound soundNamed:[NSString stringWithFormat:@"%@.m4a",soundStr]];
                }
            }else {
                if ([userInfo valueForKey:@"ringName"]) {
                    NSString *ringStr = [userInfo valueForKey:@"ringName"];
                    if ([ringStr isEqualToString:@"None"] || [ringStr isEqualToString:@"Silent"]) {
                    }else{
                        // 声音
                        content.sound = [UNNotificationSound soundNamed:[NSString stringWithFormat:@"%@.mp3",soundStr]];
                    }
                }else{
                    // 声音
                    content.sound = [UNNotificationSound soundNamed:[NSString stringWithFormat:@"%@.mp3",soundStr]];
                }
            }
            
            // 添加自定义声音
            //content.sound = [UNNotificationSound soundNamed:@"Alert_ActivityGoalAttained_Salient_Haptic.caf"];
            // 角标 （我这里测试的角标无效，暂时没找到原因）
            //        content.badge = @1;
            // 多少秒后发送,可以将固定的日期转化为时间
            NSTimeInterval time = [[NSDate dateWithTimeIntervalSinceNow:timeInterval] timeIntervalSinceNow];
            UNNotificationTrigger *trigger = nil;
            // repeats，是否重复，如果重复的话时间必须大于60s，要不会报错
            //        if (repeats > 0 && repeats < 7) {
            //            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
            //            // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
            //            unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitWeekday | NSCalendarUnitMinute | NSCalendarUnitSecond;
            //            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            //            // 获取不同时间字段的信息
            //            NSDateComponents* comp = [gregorian components:unitFlags fromDate:date];
            //            NSDateComponents *components = [[NSDateComponents alloc] init];
            //            components.second = comp.second;
            //            if (repeats == 6) {
            //                //每分钟循环
            //            } else if (repeats == 5) {
            //                //每小时循环
            //                components.minute = comp.minute;
            //            } else if (repeats == 4) {
            //                //每天循环
            //                components.minute = comp.minute;
            //                components.hour = comp.hour;
            //            } else if (repeats == 3) {
            //                //每周循环
            //                components.minute = comp.minute;
            //                components.hour = comp.hour;
            //                components.weekday = comp.weekday;
            //            } else if (repeats == 2) {
            //                //每月循环
            //                components.minute = comp.minute;
            //                components.hour = comp.hour;
            //                components.day = comp.day;
            //                components.month = comp.month;
            //            } else if (repeats == 1) {
            //                //每年循环
            //                components.minute = comp.minute;
            //                components.hour = comp.hour;
            //                components.day = comp.day;
            //                components.month = comp.month;
            //                components.year = comp.year;
            //            }
            //            trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
            //        } else {
            //不循环
            trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:time repeats:NO];
            //        }
            // 添加通知的标识符，可以用于移除，更新等操作 identifier
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
            [center addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
                DLog(@"++++++++++%@++++ECKPushSDK log:添加本地推送成功",identifier);
            }];
        }
    }
}

/// 根据identifer删除
+ (void)dl_cancleLocalNotificationWithIdentifer:(NSString *)identifier {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center removePendingNotificationRequestsWithIdentifiers:@[identifier]];
        [center removeAllDeliveredNotifications];
    }
}

//- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
//    /// 前台展示通知，可添加三种提醒（可自行选择几种实现，不写alert则不会有横幅提醒）
//    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
//}
//#pragma mark --打开通知  回到祈祷界面
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    PrayerViewController *vc = [[PrayerViewController alloc] init];
//    vc.isHideNav = YES;
//    Navigator *nav = [[Navigator alloc] initWithRootViewController:vc];
//    [appDelegate.window setRootViewController:nav];
//    [appDelegate.window makeKeyAndVisible];
//}

//+ (LocalNotificationManager *)localNotificationManager{
//    if (localNotificationManager == nil){
//        localNotificationManager =  [[self alloc]init];
//    }
//    return localNotificationManager;
//}

@end
