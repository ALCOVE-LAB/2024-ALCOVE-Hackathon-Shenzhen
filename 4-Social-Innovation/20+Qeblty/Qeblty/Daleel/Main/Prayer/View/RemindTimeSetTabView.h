//
//  RemindTimeSetTabView.h
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "BaseTableView.h"

@class RemindModel,PrayerModel,PrayerViewModel;
NS_ASSUME_NONNULL_BEGIN

typedef void(^RemindTimeSetTabBlock)(NSString *showStr);

@interface RemindTimeSetTabView : BaseTableView

@property (nonatomic,copy)RemindTimeSetTabBlock remindTimeSetTabBlock;
/// 把展示的时间带过来 处理默认选中状态
@property (nonatomic,strong)RemindModel *remindModel;

- (instancetype)initRemindTabViewWithViewModel:(PrayerViewModel *)prayerViewModel andWithFrame:(CGRect )frame andWithPrayerModel:(PrayerModel *)prayerModel andWithStyle:(UITableViewStyle )style;

@end

NS_ASSUME_NONNULL_END
