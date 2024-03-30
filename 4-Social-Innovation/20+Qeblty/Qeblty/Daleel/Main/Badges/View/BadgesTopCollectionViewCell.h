//
//  BadgesTopCollectionViewCell.h
//  Daleel
//
//  Created by mac on 2024/3/30.
//

#import "BaseCollectionViewCell.h"
#import "BadgesModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BadgesTopCollectionViewCell : BaseCollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) BadgesDetailModel *model;

@end

NS_ASSUME_NONNULL_END
