//
//  NSDate+Extension.h
//  Gamfun
//
//  Created by mac on 2022/8/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Extension)

/// 国际时间转换成当前时区时间
/// @param utcTimeStamp 国际时间
/// @param formatStr  转换成字符串样式 eg:@"dd MMM,yyyy"  /  @"yyyy-MM-dd HH:mm"
+ (NSString *)convertTimeWithUTCTimeStamp:(NSInteger)utcTimeStamp format:(NSString *)formatStr;

+ (NSInteger)getCurrentStamp;

@end

NS_ASSUME_NONNULL_END
