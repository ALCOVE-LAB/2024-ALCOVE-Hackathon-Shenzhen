//
//  PrayerModel.h
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrayerModel : NSObject
/// 时间戳
@property (nonatomic,copy)NSString *prayDate;
@property (nonatomic,copy)NSString *prayDateStr;
/// 祈祷时间
@property (nonatomic,copy)NSString *prayTime;
/// 祈祷类型
@property (nonatomic,copy)NSString *prayType;
/// 是否 签到
@property (nonatomic,copy)NSString *checkInFlag;
/// 铃声类型前  后
@property (nonatomic,copy)NSString *remindType;
/// 铃声名称
@property (nonatomic,copy)NSString *ringingName;
/// 铃声url
@property (nonatomic,copy)NSString *ringingUrl;
/// 是否选中
@property (nonatomic,assign)BOOL isSelect;
/// 是否展示签到按钮
@property (nonatomic,assign)BOOL isShowCheckBtn;
/// 是否开启地理位置
@property (nonatomic,assign)BOOL  isLocation;

/// 定义个变量  防止多次访问网络
@property (nonatomic,copy)NSString *cityName;

/// 倒计时所剩的秒数
@property(nonatomic,assign) NSInteger timeSecond;
/// 一个标识  根据不同时间更换cell背景色
@property (nonatomic,copy)NSString *cellBgColorStr;

@end


@interface RemindMorePopModel : NSObject

@property (nonatomic,assign)BOOL  isSelect;
@property (nonatomic,strong)NSArray  *detailDataArr;

@end

@interface RemindModel : NSObject

/// 铃声名称
@property (nonatomic,copy)NSString *name;
/// 铃声code
@property (nonatomic,copy)NSString *ringingCode;
/// 铃声地址
@property (nonatomic,copy)NSString *url;
/// 铃声id
@property (nonatomic,copy)NSString *ringingId;
/// 解锁需要的积分
@property (nonatomic,copy)NSString *unlockPoints;
/// 是否选中（0否1是）
@property (nonatomic,copy)NSString *checkFlag;
/// 是否解锁（0否1是）
@property (nonatomic,copy)NSString *unlockingFlag;
/// 是否允许解锁（0否1是）
@property (nonatomic,copy)NSString *allowUnlock;
/// 用户积分
@property (nonatomic,copy)NSString *points;
/// 解锁条件
@property (nonatomic,copy)NSString *unlockingConditions;
/// cell切圆角的标识
@property (nonatomic,assign)NSInteger  isRadiusTeger;
/// 分组头部的数据
@property (nonatomic,strong)NSArray *headerArr;
/// 是否展示 最右面的箭头
@property (nonatomic,assign)BOOL isShowArrow;
/// 铃声提醒名称
@property (nonatomic,copy)NSString *remindTimeName;
/// 铃声提醒时间 5 10  0  -5
@property (nonatomic,copy)NSString *remindTimeValue;
/// 铃声类型前  后
@property (nonatomic,copy)NSString *remindType;
/// 祈祷类型
@property (nonatomic,copy)NSString *prayType;
@end

@interface RemindTimeSetModel : NSObject

@property (nonatomic,assign)BOOL isSelect;
@property (nonatomic,strong)NSArray *timeArr;

@end


@interface PrayerAwardModel : NSObject

@property (nonatomic,copy)NSString *awardUrl;
@property (nonatomic,copy)NSString *awardDescribe;
@end

@interface PrayerCheckInModel : NSObject

@property (nonatomic,strong)NSArray *awardVOS;
@property (nonatomic,copy)NSString *differDays;

@end

NS_ASSUME_NONNULL_END
