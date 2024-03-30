//
//  PrayerLocationTipView.h
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "BaseView.h"
typedef enum {
    LocationTipCancle = 10,
    LocationTipToSet
}LocationTipType;

@class PrayerModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^LocationTipClickBlock)(UIButton *sender);

@interface PrayerLocationTipView : BaseView

@property (nonatomic,copy)LocationTipClickBlock locationTipClickBlock;

@end

NS_ASSUME_NONNULL_END
