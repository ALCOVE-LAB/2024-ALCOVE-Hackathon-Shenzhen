//
//  RemindTimeSetCell.h
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "BaseTableViewCell.h"

@class RemindTimeSetModel;
NS_ASSUME_NONNULL_BEGIN

@interface RemindTimeSetCell : BaseTableViewCell

- (void)dl_getModel:(RemindTimeSetModel *)remindTimeSetModel andWithTimeStr:(NSString *)timeStr;
@end

NS_ASSUME_NONNULL_END
