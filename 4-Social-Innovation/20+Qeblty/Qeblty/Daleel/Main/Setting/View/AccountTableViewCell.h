//
//  AccountTableViewCell.h
//  Daleel
//
//  Created by mac on 2024/3/30.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccountTableViewCell : BaseTableViewCell

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *imageV;
/// bindlabel 默认隐藏
@property (nonatomic,strong) UILabel *bindLabel;

@end

NS_ASSUME_NONNULL_END
