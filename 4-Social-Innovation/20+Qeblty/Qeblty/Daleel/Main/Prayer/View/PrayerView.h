//
//  PrayerView.h
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "BaseView.h"

typedef enum{
    /// 指南针
    KNavCompass,
    /// 定位提示
    KNavTips,
    /// 头像
    KNavHead,
    KNavCalendar,
}PrayerNavType;


@class PrayerModel;
NS_ASSUME_NONNULL_BEGIN

typedef void(^PrayerNavBlock)(PrayerNavType type);

typedef void(^PrayerViewJumpLoginBlock)(void);
@interface PrayerView : BaseView
/// 点击最上面的按钮的回调
@property (nonatomic,copy)PrayerNavBlock prayerNavBlock;
///  跳转登录界面的回调
@property (nonatomic,copy)PrayerViewJumpLoginBlock prayerViewJumpLoginBlock;
/// 为了传递最上面点击的tips提示中
@property (nonatomic,strong)PrayerModel *prayerModel;

- (void)dl_getRequestWithLatitude:(NSString *)latitude andWithLongitude:(NSString *)longitude andWithCityName:(NSString *)cityName;
/// 正常用户登录成功之后需要把游客登录的信息删除   游客登录之后把正常用户信息删掉
- (void)removeTouristMessage;

- (void)dl_reloadData;
@end

NS_ASSUME_NONNULL_END
