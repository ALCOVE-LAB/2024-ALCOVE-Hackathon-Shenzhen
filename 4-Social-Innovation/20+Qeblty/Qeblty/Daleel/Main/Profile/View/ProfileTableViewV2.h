//
//  ProfileTableViewV2.h
//  Daleel
//
//  Created by mac on 2024/3/31.
//

#import "BaseTableView.h"
#import "BadgesModel.h"
#import "ProfileTableViewCellV2.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileTableViewV2 : BaseTableView

+ (ProfileTableViewV2 *)getProfileTableviewWithFrame:(CGRect)frame;

/// 更新header用户信息
- (void)updateTableHeaderUserInfo;
/// 更新points数量
- (void)updatePoints;

/// tableview header 编辑用户信息
@property (nonatomic,copy) void(^editProfileAction)(void);
/// 退出登录
@property (nonatomic, copy) void (^SettingTabSignBlock) (UIButton *sender);
/// 点击积分
@property (nonatomic, copy) void (^ClickPoint) (void);

@end

NS_ASSUME_NONNULL_END
