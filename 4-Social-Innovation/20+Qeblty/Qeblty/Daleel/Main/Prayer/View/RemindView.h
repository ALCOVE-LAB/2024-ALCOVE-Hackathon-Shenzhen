//
//  RemindView.h
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "BaseView.h"

@class PrayerViewModel,PrayerModel,RemindModel;
NS_ASSUME_NONNULL_BEGIN

typedef void(^RemindViewBlock)(RemindModel *remindModel);

@interface RemindView : BaseView

@property (nonatomic,copy)RemindViewBlock remindViewBlock;

@property (nonatomic,strong)PrayerModel *prayerModel;

- (instancetype)initRemindViewWithModel:(PrayerModel *)prayerModel andWithViewModel:(PrayerViewModel *)prayerViewModel;

/// 请求接口 暴漏出去在点击navTitle的时候调用
- (void)dl_getCommondWithType:(NSString *)prayerType;

@end

NS_ASSUME_NONNULL_END
