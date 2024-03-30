//
//  PrayerModel.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "PrayerModel.h"

@implementation PrayerModel

@end

@implementation RemindMorePopModel

- (NSArray *)detailDataArr {
    if(!_detailDataArr){
        _detailDataArr = @[@"Fajr",@"Sunrise",@"Dhuhr",@"Asr",@"Maghrib",@"Isha"];
    }
    return _detailDataArr;
}

@end

@implementation RemindModel

- (NSArray *)headerArr {
    if(!_headerArr){
        _headerArr = @[kLocalize(@"pre_adhan_reminder"),kLocalize(@"adhan")];
    }
    return _headerArr;
}

@end

@implementation RemindTimeSetModel

- (NSArray *)timeArr {
    if(!_timeArr){
        _timeArr = @[@"15",@"10",@"5",@"0",@"-5",@"-10",@"-15"];
    }
    return _timeArr;
}

@end

@implementation PrayerAwardModel


@end

@implementation PrayerCheckInModel

//+ (NSDictionary *)mj_objectClassInArray{
//    return @{ @"awardVOS" : @"PrayerAwardModel"};
//}

@end
