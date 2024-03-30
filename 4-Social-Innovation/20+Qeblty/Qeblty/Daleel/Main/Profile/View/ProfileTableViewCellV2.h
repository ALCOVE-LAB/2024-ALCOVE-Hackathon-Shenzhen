//
//  ProfileTableViewCellV2.h
//  Daleel
//
//  Created by mac on 2024/3/31.
//

/**
 profile 页面的cell类  的集合
 */

#import "BaseTableViewCell.h"
#import "BadgesModel.h"


NS_ASSUME_NONNULL_BEGIN

/** 勋章 */
@interface ProfileBadgeTableViewCell : BaseTableViewCell

/// 设置 更新勋章数据
- (void)setRecentBadgesData:(NSArray <BadgesDetailModel *> *)data;
/// 点击勋章回调
@property(nonatomic,copy) void (^badgeClick) (NSIndexPath *indexPath, CGPoint point,BadgesDetailModel *model);

@end



NS_ASSUME_NONNULL_END
