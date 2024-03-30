//
//  UINavigationBar+ext.h
//  Daleel
//
//  Created by mac on 2023/5/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (ext)

@property (nonatomic,strong) UIVisualEffectView *effectBackground;

/// 添加自定义的背景
- (UIVisualEffectView *)addNavigationBarEffectBackground;

/// 设置透明度
- (void)setNavBarBackgroundAlpha:(float)alpha;

/// 设置字体 返回按钮颜色
- (void)setNavBarContentColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
