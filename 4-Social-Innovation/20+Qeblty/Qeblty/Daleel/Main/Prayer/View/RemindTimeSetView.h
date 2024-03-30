//
//  RemindTimeSetView.h
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "BaseView.h"

@class remindModel,PrayerViewModel,PrayerModel;
NS_ASSUME_NONNULL_BEGIN

typedef void(^ RemindTimeSetBlock)(NSString *showStr);

@interface RemindTimeSetView : BaseView

@property (nonatomic,copy)RemindTimeSetBlock remindTimeSetBlock;

- (instancetype)initRemindTimeSetViewWithViewModel:(PrayerViewModel *)prayerViewModel andWithFrame:(CGRect )frame andWithPrayerModel:(PrayerModel *)prayerModel;

@end

NS_ASSUME_NONNULL_END
