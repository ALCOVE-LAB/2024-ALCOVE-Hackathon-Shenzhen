//
//  UINavigationController+NavExt.h
//  NavThings
//
//  Created by mac on 2023/5/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (NavExt)

/// 修改导航栏的背景透明度  (前提是有背景色) （不会立即生效）
- (void)setNavigationBarBackgroundAlpha:(float)alpha;

/// 修改导航栏上的字体 返回图标的颜色 （不会立即生效）
- (void)setNavigationBarContentTinkColor:(UIColor *)color;

/// 设置导航栏是否可以点击 (点击穿透到下面)  (不会立即生效 ）
- (void)setNavigationBarTouchEnabled:(BOOL)enable;

/// 更新导航栏外观(透明度 tinkColor)  立即生效
- (void)updateNavigationBarAppearance;

@end

NS_ASSUME_NONNULL_END
