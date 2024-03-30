//
//  PrayerCell.h
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "BaseTableViewCell.h"

@class PrayerModel;
typedef void(^PrayerAlreadyCellBtnBlock)(UIButton * _Nonnull sender);
typedef void(^PrayerAlreadyCellReloadBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface PrayerAlreadyCell : BaseTableViewCell

@property (nonatomic,strong)PrayerModel *prayerModel;

@property (nonatomic,copy)PrayerAlreadyCellBtnBlock prayerAlreadyCellBtnBlock;
@property (nonatomic,copy)PrayerAlreadyCellReloadBlock prayerAlreadyCellReloadBlock;

@end

NS_ASSUME_NONNULL_END
