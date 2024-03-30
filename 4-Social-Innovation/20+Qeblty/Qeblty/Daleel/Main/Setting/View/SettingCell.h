//
//  SettingCell.h
//  UISettingView
//
//  Created by mac on 2024/3/30.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingCell : BaseTableViewCell

@property (nonatomic,copy)NSString  *title;
@property (nonatomic,copy)NSString  *imgStr;
@property (nonatomic,assign)NSInteger  isRadiusTeger;
@property (nonatomic,assign)BOOL isShowLanguage;

@end

NS_ASSUME_NONNULL_END
