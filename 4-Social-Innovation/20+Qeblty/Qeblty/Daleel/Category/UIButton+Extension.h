//
//  UIButton+Extension.h
//  Gamfun
//
//  Created by mac on 2022/6/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ImagePositionType) {
    /// 图片在左，标题在右，默认风格
    ImagePositionTypeLeft,
    /// 图片在右，标题在左
    ImagePositionTypeRight,
    /// 图片在上，标题在下
    ImagePositionTypeTop,
    /// 图片在下，标题在上
    ImagePositionTypeBottom
};

typedef NS_ENUM(NSInteger, EdgeInsetsType) {
    /// 标题
    EdgeInsetsTypeTitle,
    /// 图片
    EdgeInsetsTypeImage
};

typedef NS_ENUM(NSInteger, MarginType) {
    MarginTypeTop         ,
    MarginTypeBottom      ,
    MarginTypeLeft        ,
    MarginTypeRight       ,
    MarginTypeTopLeft     ,
    MarginTypeTopRight    ,
    MarginTypeBottomLeft  ,
    MarginTypeBottomRight
};

@interface UIButton (Extension)

/// 设置按钮额外相应区域
@property (nonatomic, assign) UIEdgeInsets touchAreaInsets;

/// 创建Button
/// @param font 字体
/// @param color 字体颜色
+ (UIButton *)buttonWithTitleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color;

/// 创建Button
/// @param font 字体
/// @param color 字体颜色
/// @param title normaltitle
+ (UIButton *)buttonWithTitleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color title:(NSString *)title;

/// 创建Button
/// @param font 字体
/// @param color 字体颜色
/// @param backColor 背景色
+ (UIButton *)buttonWithTitleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color backgroundColor:(UIColor *_Nullable)backColor;

/// 创建Button
/// @param font 字体
/// @param color 字体颜色
/// @param title 内容
/// @param image 图片
+ (UIButton *)buttonWithTitleFont:(UIFont *)font titleColor:(UIColor *)color title:(NSString *_Nullable)title image:(UIImage *_Nullable)image;

/// 创建纯图Button
/// @param normaleImage 默认图
/// @param selectedImage 选中图
+ (UIButton *)buttonWithNormalImage:(UIImage *_Nullable)normaleImage selectedImage:(UIImage *_Nullable)selectedImage;

/// 创建Button
/// @param font 字体
/// @param color 字体颜色
/// @param title 内容title
/// @param backColor 背景色
+ (UIButton *)buttonWithTitleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color title:(NSString *_Nullable)title backgroundColor:(UIColor *_Nullable)backColor;

/// 创建Button
/// @param font 字体
/// @param color 字体颜色
/// @param title 内容title
/// @param backColor 背景色
/// @param normaleImage 默认图
/// @param selectedImage 选中图
+ (UIButton *)buttonWithTitleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color title:(NSString *_Nullable)title backgroundColor:(UIColor *_Nullable)backColor normalImage:(UIImage *_Nullable)normaleImage selectedImage:(UIImage *_Nullable)selectedImage;

/// 创建button
/// @param sView 父视图
+ (instancetype)buttonWithSuperView:(UIView *)sView;

#pragma mark - 创建 frame button  ,
/// 创建Button
/// @param frame 布局
/// @param font 字体
/// @param color 字体颜色
+ (UIButton *)buttonWithFrame:(CGRect)frame titleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color;

/// 创建Button
/// @param frame 布局
/// @param font 字体
/// @param color 字体颜色
/// @param title title
+ (UIButton *)buttonWithFrame:(CGRect)frame titleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color title:(NSString *_Nullable)title;

/// 创建Button
/// @param frame 布局
/// @param font 字体
/// @param color 字体颜色
/// @param title title
/// @param normaleImage 默认图
+ (UIButton *)buttonWithFrame:(CGRect)frame titleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color title:(NSString *_Nullable)title normalImage:(UIImage *_Nullable)normaleImage;

/// 创建纯图Button
/// @param normaleImage 默认图
/// @param selectedImage 选中图
+ (UIButton *)buttonWithFrame:(CGRect)frame normalImage:(UIImage *_Nullable)normaleImage selectedImage:(UIImage *_Nullable)selectedImage;


/// 创建Button
/// @param frame 布局
/// @param font 字体
/// @param color 字体颜色
/// @param backColor 背景色
+ (UIButton *)buttonWithFrame:(CGRect)frame titleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color backgroundColor:(UIColor *_Nullable)backColor;

/// 创建Button
/// @param frame 布局
/// @param font 字体
/// @param color 字体颜色
/// @param title title
/// @param backColor 背景色
/// @param normaleImage 默认图
/// @param selectedImage 选中图
+ (UIButton *)buttonWithFrame:(CGRect)frame titleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color title:(NSString *_Nullable)title backgroundColor:(UIColor *_Nullable)backColor normalImage:(UIImage *_Nullable)normaleImage selectedImage:(UIImage *_Nullable)selectedImage;;


- (void)setTitleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color;
- (void)setTitleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color title:(NSString *_Nullable)title;
- (void)setTitleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color backgroundColor:(UIColor *_Nullable)backColor;
- (void)setTitleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color title:(NSString *_Nullable)title backgroundColor:(UIColor *_Nullable)backColor;
- (void)setTitleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color normalTitle:(NSString *_Nullable)normalTitle selectedTitle:(NSString *_Nullable)selectedTitle;


/// 利用UIButton的titleEdgeInsets和imageEdgeInsets来实现图片和标题的自由排布
/// 注意：1.该方法需在设置图片和标题之后才调用;
/// 2.图片和标题改变后需再次调用以重新计算titleEdgeInsets和imageEdgeInsets
/// @param type 图片位置类型
/// @param spacing 图片和文字之间的间隙
- (void)setImagePositionWithType:(ImagePositionType)type spacing:(CGFloat)spacing;

/// 按钮只设置了title or image，该方法可以改变它们的位置
/// @param edgeInsetsType description
/// @param marginType marginType description
/// @param margin margin description
- (void)setEdgeInsetsWithType:(EdgeInsetsType)edgeInsetsType marginType:(MarginType)marginType margin:(CGFloat)margin;

@end

NS_ASSUME_NONNULL_END
