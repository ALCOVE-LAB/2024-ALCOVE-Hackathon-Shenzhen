//
//  UILabel+Extension.h
//  Gamfun
//
//  Created by mac on 2022/7/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Extension)


/// 创建 Label - 指定 字体 颜色
/// @param font 字体font
/// @param color 颜色
+ (UILabel *)labelWithTextFont:(UIFont *_Nullable)font textColor:(UIColor * _Nullable)color;

/// 创建Label - 指定 字体 颜色 内容
/// @param font 字体
/// @param color 颜色
/// @param text 内容
+ (UILabel *)labelWithTextFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color text:(NSString *_Nullable)text;

/// 创建Label - 指定 字体 颜色 背景颜色
/// @param font 字体
/// @param color 颜色
/// @param backColor 背景色
+ (UILabel *)labelWithTextFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color backgroundColor:(UIColor *_Nullable)backColor;

/// 创建Label - 指定 字体 颜色 内容 背景颜色
/// @param font 字体
/// @param color 颜色
/// @param text 内容
/// @param backColor 背景色
+ (UILabel *)labelWithTextFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color text:(NSString *_Nullable)text backgroundColor:(UIColor *_Nullable)backColor;

/// 创建Label - 指定 字体 颜色 内容 对齐方式
/// @param font 字体
/// @param color 颜色
/// @param text 内容
/// @param alignment 对齐方式
+ (UILabel *)labelWithTextFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color text:(NSString *_Nullable)text alignment:(NSTextAlignment)alignment;

/// 创建Label - 指定 字体 颜色 内容 背景颜色 对齐方式
/// @param font 字体
/// @param color 颜色
/// @param text 内容
/// @param backColor 背景色
/// @param alignment 对齐方式
+ (UILabel *)labelWithTextFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color text:(NSString *_Nullable)text backgroundColor:(UIColor *_Nullable)backColor alignment:(NSTextAlignment)alignment;

/// 创建Label - 指定 字体 颜色 内容 父视图
/// @param font 字体
/// @param color 颜色
/// @param text 内容
/// @param sView  父试图
+ (instancetype)labelWithTextColor:(UIColor *)color font:(CGFloat)font text:(NSString *_Nullable)text superView:(UIView *)sView;

/// 创建Label - 指定 字体 颜色 内容 父视图
/// @param font 加粗字体
/// @param color 颜色
/// @param text 内容
/// @param sView  父试图
+ (instancetype)labelWithTextColor:(UIColor *)color boldFont:(CGFloat)font text:(NSString * _Nullable)text superView:(UIView * _Nullable)sView;

#pragma mark - 指定frame  masonry布局会比较少用
/// 创建Label - 指定 frame
/// @param frame frame
/// @param font 字体大小
/// @param color 字体颜色
+ (UILabel *)labelWithFrame:(CGRect)frame textFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color;

/// 创建Label - 指定 frame
/// @param frame frame
/// @param font 字体大小
/// @param color 字体颜色
/// @param text 内容
+ (UILabel *)labelWithFrame:(CGRect)frame textFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color text:(NSString *_Nullable)text;

/// 创建Label - 指定 frame
/// @param frame frame
/// @param font 字体大小
/// @param color 字体颜色
/// @param backColor 背景色
+ (UILabel *)labelWithFrame:(CGRect)frame textFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color backgroundColor:(UIColor *_Nullable)backColor;

/// 创建Label - 指定 frame
/// @param frame frame
/// @param font 字体大小
/// @param color 字体颜色
/// @param text 内容
/// @param backColor 背景色
+ (UILabel *)labelWithFrame:(CGRect)frame textFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color text:(NSString *_Nullable)text backgroundColor:(UIColor *_Nullable)backColor;

/// 创建Label - 指定 frame
/// @param frame frame
/// @param font 字体大小
/// @param color 字体颜色
/// @param text 内容
/// @param alignment 对齐方式
+ (UILabel *)labelWithFrame:(CGRect)frame textFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color text:(NSString *_Nullable)text alignment:(NSTextAlignment)alignment;

/// 创建Label - 指定 frame
/// @param frame frame
/// @param font 字体大小
/// @param color 字体颜色
/// @param text 内容
/// @param backColor 背景色
/// @param alignment 对齐方式
+ (UILabel *)labelWithFrame:(CGRect)frame textFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color text:(NSString *_Nullable)text backgroundColor:(UIColor *_Nullable)backColor alignment:(NSTextAlignment)alignment;


/// 设置label 属性
/// @param font 字体
/// @param color 字体颜色
- (void)setTextFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color;

/// 设置Label属性
/// @param font 字体
/// @param color 字体颜色
/// @param text 内容
- (void)setTextFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color text:(NSString *_Nullable)text;

/// 设置Label属性
/// @param font 字体
/// @param color 颜色
/// @param backColor 背景色
- (void)setTextFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color backgroundColor:(UIColor *_Nullable)backColor;

/// 设置Label属性
/// @param font 字体
/// @param color 字体颜色
/// @param text 内容
/// @param backColor 背景色
- (void)setTextFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color text:(NSString *_Nullable)text backgroundColor:(UIColor *_Nullable)backColor;

/// 设置Label属性
/// @param font 字体
/// @param color 颜色
/// @param text 内容
/// @param alignment 对齐方式
- (void)setTextFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color text:(NSString *_Nullable)text alignment:(NSTextAlignment)alignment;

/// 设置Label属性
/// @param font 字体大小
/// @param color 字体颜色
/// @param text 内容
/// @param backColor 背景色
/// @param alignment 对齐方式
- (void)setTextFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color text:(NSString *_Nullable)text backgroundColor:(UIColor *_Nullable)backColor alignment:(NSTextAlignment)alignment;

/// 给UILabel添加删除线 横线
/// @param color 删除线颜色
-(void)addDeleteLine:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
