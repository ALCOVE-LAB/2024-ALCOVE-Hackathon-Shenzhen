//
//  ProfileSectionHeaderView.h
//  Daleel
//
//  Created by mac on 2024/3/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic,copy) void(^rightBtnClick)(void);

- (void)setTitle:(NSString *)title rightBtnTitle:(NSString *)btnTitle;

@end

NS_ASSUME_NONNULL_END
