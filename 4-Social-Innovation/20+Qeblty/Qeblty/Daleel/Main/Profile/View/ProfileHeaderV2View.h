//
//  ProfileHeaderV2View.h
//  Daleel
//
//  Created by mac on 2024/3/31.
//

#import "BaseView.h"
#import "BadgesModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileHeaderV2View : BaseView

@property(nonatomic,strong)UserModel *model;
@property(nonatomic,copy)void (^editProfileAction) (void);

@property (nonatomic, copy) void (^ClickedPointsBlock) (void);
@end

NS_ASSUME_NONNULL_END
