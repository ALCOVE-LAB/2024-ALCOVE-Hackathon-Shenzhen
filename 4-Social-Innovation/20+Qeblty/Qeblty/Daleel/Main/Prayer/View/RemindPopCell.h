//
//  RemindPopCell.h
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "BaseTableViewCell.h"

@class RemindMorePopModel;
NS_ASSUME_NONNULL_BEGIN

@interface RemindPopCell : BaseTableViewCell


- (void)dl_getModel:(RemindMorePopModel  *)remindMorePopModel andWithIndex:(NSInteger )index;

@end

NS_ASSUME_NONNULL_END
