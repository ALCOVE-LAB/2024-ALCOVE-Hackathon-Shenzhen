//
//  LocalNotificationManager.h
//  Daleel
//
//  Created by mac on 2022/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalNotificationManager : NSObject

+ (void)dl_addLocalNotificationWithTitle:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body timeInterval:(long)timeInterval identifier:(NSString *)identifier userInfo:(NSDictionary *)userInfo repeats:(int)repeats sound:(NSString *)sound;

+ (void)dl_cancleLocalNotificationWithIdentifer:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
