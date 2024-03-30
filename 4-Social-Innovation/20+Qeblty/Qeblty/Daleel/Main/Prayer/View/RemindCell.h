//
//  RemindCell.h
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "BaseTableViewCell.h"

@class RemindModel;
NS_ASSUME_NONNULL_BEGIN

@interface RemindCell : BaseTableViewCell

@property (nonatomic,strong)RemindModel *remindModel;

@end

NS_ASSUME_NONNULL_END
