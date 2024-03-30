//
//  BadgesTopView.h
//  Daleel
//
//  Created by mac on 2024/3/30.
//

#import "BaseView.h"

@class BadgesDetailModel;

/**
 勋章墙顶部view
 */

NS_ASSUME_NONNULL_BEGIN

@interface BadgesTopView : BaseView

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, copy) void (^WearBadgeBlock) (BadgesDetailModel * _Nonnull model);

@end

NS_ASSUME_NONNULL_END
