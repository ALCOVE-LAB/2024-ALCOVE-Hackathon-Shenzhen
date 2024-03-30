//
//  AwardsRecentView.h
//  Daleel
//
//  Created by mac on 2024/3/31.
//

/**
 最近获得勋章view （用户信息 用户points  最近获得的勋章）
 */

#import "BaseView.h"
#import "BaseCollectionView.h"
#import "BaseCollectionViewCell.h"
#import "BadgesModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 最近获得的勋章 列表
 */
@interface ProfileRecentBadgesCollectionView : BaseCollectionView

+ (ProfileRecentBadgesCollectionView *)getAwardsRecentCollectionView;

@end

/**
 最近获得的勋章 列表Cell
 */
@interface AwardsRecentCollectionViewCell : BaseCollectionViewCell

@end

NS_ASSUME_NONNULL_END
