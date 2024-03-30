//
//  RemindPopMoreView.h
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "BaseView.h"

@class PrayerModel;
NS_ASSUME_NONNULL_BEGIN

typedef void(^RemindPopMoreBlock)(NSString *topStr);

@interface RemindPopMoreView : BaseView

@property (nonatomic,strong)PrayerModel *prayerModel;// 用于传递到remind视图中最上面的选项

@property (nonatomic,copy)RemindPopMoreBlock remindPopMoreBlock;

@end

NS_ASSUME_NONNULL_END
