//
//  PrayerToDoCell.h
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "BaseTableViewCell.h"

@class PrayerModel;
NS_ASSUME_NONNULL_BEGIN

@interface PrayerToDoCell : BaseTableViewCell
///  用isRadiusTeger 判断切圆角  0是上面圆角  1是下面圆角  2是全切
@property (nonatomic,assign)NSInteger  isRadiusTeger;

@property (nonatomic,strong)PrayerModel *prayerModel;

@end

NS_ASSUME_NONNULL_END
