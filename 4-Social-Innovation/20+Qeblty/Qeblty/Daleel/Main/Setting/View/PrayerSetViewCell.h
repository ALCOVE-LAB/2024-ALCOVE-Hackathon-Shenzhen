//
//  PrayerSetViewCell.h
//  Daleel
//
//  Created by mac on 2024/3/30.
//

#import "BaseTableViewCell.h"

@class PrayerModel;
NS_ASSUME_NONNULL_BEGIN

@interface PrayerSetViewCell : BaseTableViewCell

@property (nonatomic,strong)PrayerModel *prayerModel;

@end

NS_ASSUME_NONNULL_END
