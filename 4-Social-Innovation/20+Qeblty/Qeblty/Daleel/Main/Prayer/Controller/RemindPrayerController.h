//
//  RemindPrayerController.h
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "BaseViewController.h"

@class PrayerModel,PrayerViewModel,RemindModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^ RemindPrayerVCBlock)(RemindModel *remindModel);

@interface RemindPrayerController : BaseViewController

@property (nonatomic,copy)RemindPrayerVCBlock remindPrayerVCBlock;

- (instancetype)initWithPrayerModel:(PrayerModel *)prayerModel andWithViewModel:(PrayerViewModel *)viewModel andWithModelArr:(NSArray<PrayerModel *> *)modelArr;

@end

NS_ASSUME_NONNULL_END
