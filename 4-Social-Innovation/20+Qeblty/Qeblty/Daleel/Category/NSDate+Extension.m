//
//  NSDate+Extension.m
//  Gamfun
//
//  Created by mac on 2022/8/19.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

+ (NSString *)convertTimeWithUTCTimeStamp:(NSInteger)utcTimeStamp format:(NSString *)formatStr {
    NSString *timeStr = [NSString stringWithFormat:@"%ld",utcTimeStamp];
    if (timeStr.length == 13) {
        utcTimeStamp = utcTimeStamp / 1000;
    }
    NSDate *utcDate = [NSDate dateWithTimeIntervalSince1970:utcTimeStamp];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = formatStr;
    format.timeZone = [NSTimeZone localTimeZone];
    NSString *localTime = [format stringFromDate:utcDate];
    return localTime;
}

+ (NSInteger)getCurrentStamp {
    /*矫正时间为本地时间*/
    NSDate *nowDate = [NSDate date];
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//设置源日期时区//或GMT
    NSTimeZone *destinationTimeZone = [NSTimeZone localTimeZone];//设置转换后的目标日期时区
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:nowDate];//得到源日期与世界标准时间的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:nowDate];//目标日期与本地时区的偏移量
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;//得到时间偏移量的差值
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:nowDate];//转为现在时间
    //返回毫秒
    CGFloat timestamp = [destinationDateNow timeIntervalSince1970]*1000;;
    NSString *timeStampString = [NSString stringWithFormat:@"%.f",timestamp];
    return timeStampString.integerValue;
}

@end
