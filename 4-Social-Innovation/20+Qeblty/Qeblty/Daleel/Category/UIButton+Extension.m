//
//  UIButton+Extension.m
//  Gamfun
//
//  Created by mac on 2022/6/10.
//

#import "UIButton+Extension.h"
#import <objc/runtime.h>

#define SS_SINGLELINE_TEXTSIZE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;

UIEdgeInsets RTLEdgeInsetsWithInsets(UIEdgeInsets insets) {
    if (insets.left != insets.right && kIsAR) {
        CGFloat temp = insets.left;
        insets.left = insets.right;
        insets.right = temp;
    }
    return insets;
}

@implementation UIButton (Extension)
//
//
//+ (void)load {
//    Method method = class_getInstanceMethod(self, @selector(setContentEdgeInsets:));
//    Method newMethod = class_getInstanceMethod(self, @selector(rtl_setContentEdgeInsets:));
//    method_exchangeImplementations(newMethod, method);
//    
//    Method image = class_getInstanceMethod(self, @selector(setImageEdgeInsets:));
//    Method newImage = class_getInstanceMethod(self, @selector(rtl_setImageEdgeInsets:));
//    method_exchangeImplementations(newImage, image);
//    
//    Method title = class_getInstanceMethod(self, @selector(setTitleEdgeInsets:));
//    Method newTitle = class_getInstanceMethod(self, @selector(rtl_setTitleEdgeInsets:));
//    method_exchangeImplementations(newTitle, title);
//    
//    Method contentAlign = class_getInstanceMethod(self, @selector(setContentHorizontalAlignment:));
//    Method newcontentAlign = class_getInstanceMethod(self, @selector(rtl_setContentHorizontalAlignment:));
//    method_exchangeImplementations(newcontentAlign, contentAlign);
//}
//
//- (void)rtl_setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
//    [self rtl_setContentEdgeInsets:RTLEdgeInsetsWithInsets(contentEdgeInsets)];
//}
//
//- (void)rtl_setImageEdgeInsets:(UIEdgeInsets)imageEdgeInsets {
//    [self rtl_setImageEdgeInsets:RTLEdgeInsetsWithInsets(imageEdgeInsets)];
//}
//
//- (void)rtl_setTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets {
//    [self rtl_setTitleEdgeInsets:RTLEdgeInsetsWithInsets(titleEdgeInsets)];
//}
//- (void)rtl_setContentHorizontalAlignment:(UIControlContentHorizontalAlignment)alignment {
//    if (kIsAR) {
//        if (alignment == UIControlContentHorizontalAlignmentLeft) {
//            alignment = UIControlContentHorizontalAlignmentRight;
//        } else if (alignment == UIControlContentHorizontalAlignmentRight) {
//            alignment = UIControlContentHorizontalAlignmentLeft;
//        }
//    }
//    [self rtl_setContentHorizontalAlignment:alignment];
//}

/// 创建Button
/// @param font 字体
/// @param color 字体颜色
+ (UIButton *)buttonWithTitleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color {
    return [UIButton buttonWithTitleFont:font titleColor:color title:nil backgroundColor:nil normalImage:nil selectedImage:nil];
}

/// 创建Button
/// @param font 字体
/// @param color 字体颜色
/// @param title normaltitle
+ (UIButton *)buttonWithTitleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color title:(NSString *)title {
    return [UIButton buttonWithTitleFont:font titleColor:color title:title backgroundColor:nil normalImage:nil selectedImage:nil];
}

/// 创建Button
/// @param font 字体
/// @param color 字体颜色
/// @param backColor 背景色
+ (UIButton *)buttonWithTitleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color backgroundColor:(UIColor *_Nullable)backColor {
    return [UIButton buttonWithTitleFont:font titleColor:color title:nil backgroundColor:backColor normalImage:nil selectedImage:nil];
}

/// 创建Button
/// @param font 字体
/// @param color 字体颜色
/// @param title 内容
/// @param image 图片
+ (UIButton *)buttonWithTitleFont:(UIFont *)font titleColor:(UIColor *)color title:(NSString *_Nullable)title image:(UIImage *_Nullable)image {
    return [UIButton buttonWithTitleFont:font titleColor:color title:title backgroundColor:nil normalImage:image selectedImage:nil];
}

/// 创建纯图Button
/// @param normaleImage 默认图
/// @param selectedImage 选中图
+ (UIButton *)buttonWithNormalImage:(UIImage *_Nullable)normaleImage selectedImage:(UIImage *_Nullable)selectedImage {
    return [UIButton buttonWithTitleFont:nil titleColor:nil title:nil backgroundColor:nil normalImage:normaleImage selectedImage:selectedImage];
}

/// 创建Button
/// @param font 字体
/// @param color 字体颜色
/// @param title 内容title
/// @param backColor 背景色
+ (UIButton *)buttonWithTitleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color title:(NSString *_Nullable)title backgroundColor:(UIColor *_Nullable)backColor {
    return [UIButton buttonWithTitleFont:font titleColor:color title:title backgroundColor:backColor normalImage:nil selectedImage:nil];
}

/// 创建Button
/// @param font 字体
/// @param color 字体颜色
/// @param title 内容title
/// @param backColor 背景色
/// @param normaleImage 默认图
/// @param selectedImage 选中图
+ (UIButton *)buttonWithTitleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color title:(NSString *_Nullable)title backgroundColor:(UIColor *_Nullable)backColor normalImage:(UIImage *_Nullable)normaleImage selectedImage:(UIImage *_Nullable)selectedImage {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleFont:font titleColor:color title:title backgroundColor:backColor];
    if (normaleImage) {
        [btn setImage:normaleImage forState:UIControlStateNormal];
    }
    if (selectedImage) {
        [btn setImage:selectedImage forState:UIControlStateSelected];
    }
    return btn;
}

+ (instancetype)buttonWithSuperView:(UIView *)sView {
    UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (sView != nil) {
        [sView addSubview:tmpButton];
    }
    return tmpButton;
}

#pragma mark - 创建 frame button  ,
/// 创建Button
/// @param frame 布局
/// @param font 字体
/// @param color 字体颜色
+ (UIButton *)buttonWithFrame:(CGRect)frame titleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color {
    return [UIButton buttonWithFrame:frame titleFont:font titleColor:color title:nil backgroundColor:nil normalImage:nil selectedImage:nil];
}

/// 创建Button
/// @param frame 布局
/// @param font 字体
/// @param color 字体颜色
/// @param title title
+ (UIButton *)buttonWithFrame:(CGRect)frame titleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color title:(NSString *_Nullable)title {
    return [UIButton buttonWithFrame:frame titleFont:font titleColor:color title:title backgroundColor:nil normalImage:nil selectedImage:nil];
}

/// 创建Button
/// @param frame 布局
/// @param font 字体
/// @param color 字体颜色
/// @param title title
/// @param normaleImage 默认图
+ (UIButton *)buttonWithFrame:(CGRect)frame titleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color title:(NSString *_Nullable)title normalImage:(UIImage *_Nullable)normaleImage {
    return [UIButton buttonWithFrame:frame titleFont:font titleColor:color title:nil backgroundColor:nil normalImage:normaleImage selectedImage:nil];
}

/// 创建纯图Button
/// @param normaleImage 默认图
/// @param selectedImage 选中图
+ (UIButton *)buttonWithFrame:(CGRect)frame normalImage:(UIImage *_Nullable)normaleImage selectedImage:(UIImage *_Nullable)selectedImage; {
    return [UIButton buttonWithFrame:frame titleFont:nil titleColor:nil title:nil backgroundColor:nil normalImage:normaleImage selectedImage:selectedImage];
}


/// 创建Button
/// @param frame 布局
/// @param font 字体
/// @param color 字体颜色
/// @param backColor 背景色
+ (UIButton *)buttonWithFrame:(CGRect)frame titleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color backgroundColor:(UIColor *_Nullable)backColor {
    return [UIButton buttonWithFrame:frame titleFont:font titleColor:nil title:nil backgroundColor:backColor normalImage:nil selectedImage:nil];
}

/// 创建Button
/// @param frame 布局
/// @param font 字体
/// @param color 字体颜色
/// @param title title
/// @param backColor 背景色
/// @param normaleImage 默认图
/// @param selectedImage 选中图
+ (UIButton *)buttonWithFrame:(CGRect)frame titleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color title:(NSString *_Nullable)title backgroundColor:(UIColor *_Nullable)backColor normalImage:(UIImage *_Nullable)normaleImage selectedImage:(UIImage *_Nullable)selectedImage {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitleFont:font titleColor:color title:title backgroundColor:backColor];
    if (normaleImage) {
        [btn setImage:normaleImage forState:UIControlStateNormal];
    }
    if (selectedImage) {
        [btn setImage:selectedImage forState:UIControlStateSelected];
    }
    return btn;
}


- (void)setTitleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color {
    [self setTitleFont:font titleColor:color title:nil backgroundColor:nil];
}

- (void)setTitleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color title:(NSString *_Nullable)title {
    [self setTitleFont:font titleColor:color title:title backgroundColor:nil];
}

- (void)setTitleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color backgroundColor:(UIColor *_Nullable)backColor {
    [self setTitleFont:font titleColor:color title:nil backgroundColor:backColor];
}

- (void)setTitleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color title:(NSString *_Nullable)title backgroundColor:(UIColor *_Nullable)backColor {
    if (font) {
        [self.titleLabel setFont:font];
    }
    if (color) {
        [self setTitleColor:color forState:UIControlStateNormal];
    }
    if (title) {
        [self setTitle:title forState:UIControlStateNormal];
    }
    if (backColor) {
        [self setBackgroundColor:backColor];
    }
}

- (void)setTitleFont:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)color normalTitle:(NSString *_Nullable)normalTitle selectedTitle:(NSString *_Nullable)selectedTitle {
    [self setTitleFont:font titleColor:color title:normalTitle backgroundColor:nil];
    if (selectedTitle) {
        [self setTitle:selectedTitle forState:UIControlStateSelected];
    }
}

- (void)setTouchAreaInsets:(UIEdgeInsets)touchAreaInsets {
    NSValue *value = [NSValue valueWithUIEdgeInsets:touchAreaInsets];
    objc_setAssociatedObject(self, @selector(touchAreaInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)touchAreaInsets {
    return [objc_getAssociatedObject(self, @selector(touchAreaInsets)) UIEdgeInsetsValue];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    UIEdgeInsets touchAreaInsets = self.touchAreaInsets;
    CGRect bounds = self.bounds;
    bounds = CGRectMake(bounds.origin.x - touchAreaInsets.left, bounds.origin.y - touchAreaInsets.top, bounds.size.width + touchAreaInsets.left + touchAreaInsets.right, bounds.size.height + touchAreaInsets.top + touchAreaInsets.bottom);
    return CGRectContainsPoint(bounds, point);
}

- (void)setImagePositionWithType:(ImagePositionType)type spacing:(CGFloat)spacing {
    CGSize imageSize = [self imageForState:UIControlStateNormal].size;
    CGSize titleSize = SS_SINGLELINE_TEXTSIZE([self titleForState:UIControlStateNormal], self.titleLabel.font);
    if (kIsAR) {
        switch (type) {
            case ImagePositionTypeLeft: {
                self.titleEdgeInsets = UIEdgeInsetsMake(0, -spacing, 0, 0);
                self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -spacing);
                break;
            }
            case ImagePositionTypeRight: {
                self.titleEdgeInsets = UIEdgeInsetsMake(0, imageSize.width + spacing, 0,  - imageSize.width);
                self.imageEdgeInsets = UIEdgeInsetsMake(0, - titleSize.width, 0, titleSize.width + spacing);
                break;
            }
            case ImagePositionTypeTop: {
                self.titleEdgeInsets = UIEdgeInsetsMake(0, - (imageSize.height + spacing), - imageSize.width, 0);
                self.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0, 0, - titleSize.width);
                break;
            }
            case ImagePositionTypeBottom: {
                self.titleEdgeInsets = UIEdgeInsetsMake(- (imageSize.height + spacing), 0, 0, - imageSize.width);
                self.imageEdgeInsets = UIEdgeInsetsMake(0, - titleSize.width, - (titleSize.height + spacing), 0);
                break;
            }
        }
    }else {
        switch (type) {
            case ImagePositionTypeLeft: {
                self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -spacing);
                self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing, 0, 0);
                break;
            }
            case ImagePositionTypeRight: {
                self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, 0, imageSize.width + spacing);
                self.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width + spacing, 0, - titleSize.width);
                break;
            }
            case ImagePositionTypeTop: {
                self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (imageSize.height + spacing), 0);
                self.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0, 0, - titleSize.width);
                break;
            }
            case ImagePositionTypeBottom: {
                self.titleEdgeInsets = UIEdgeInsetsMake(- (imageSize.height + spacing), - imageSize.width, 0, 0);
                self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, - (titleSize.height + spacing), - titleSize.width);
                break;
            }
        }
    }
}

- (void)setEdgeInsetsWithType:(EdgeInsetsType)edgeInsetsType marginType:(MarginType)marginType margin:(CGFloat)margin {
    CGSize itemSize = CGSizeZero;
    if (edgeInsetsType == EdgeInsetsTypeTitle) {
        itemSize = SS_SINGLELINE_TEXTSIZE([self titleForState:UIControlStateNormal], self.titleLabel.font);
    } else {
        itemSize = [self imageForState:UIControlStateNormal].size;
    }
    
    CGFloat horizontalDelta = (CGRectGetWidth(self.frame) - itemSize.width) / 2.f - margin;
    CGFloat vertivalDelta = (CGRectGetHeight(self.frame) - itemSize.height) / 2.f - margin;
    NSInteger horizontalSignFlag = 1;
    NSInteger verticalSignFlag = 1;
    
    switch (marginType) {
        case MarginTypeTop: {
            horizontalSignFlag = 0;
            verticalSignFlag = - 1;
            break;
        }
        case MarginTypeBottom: {
            horizontalSignFlag = 0;
            verticalSignFlag = 1;
            break;
        }
        case MarginTypeLeft: {
            horizontalSignFlag = - 1;
            verticalSignFlag = 0;
            break;
        }
        case MarginTypeRight: {
            horizontalSignFlag = 1;
            verticalSignFlag = 0;
            break;
        }
        case MarginTypeTopLeft: {
            horizontalSignFlag = - 1;
            verticalSignFlag = - 1;
            break;
        }
        case MarginTypeTopRight: {
            horizontalSignFlag = 1;
            verticalSignFlag = - 1;
            break;
        }
        case MarginTypeBottomLeft: {
            horizontalSignFlag = - 1;
            verticalSignFlag = 1;
            break;
        }
        case MarginTypeBottomRight: {
            horizontalSignFlag = 1;
            verticalSignFlag = 1;
            break;
        }
    }
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(vertivalDelta * verticalSignFlag, horizontalDelta * horizontalSignFlag, - vertivalDelta * verticalSignFlag, - horizontalDelta * horizontalSignFlag);
    if (edgeInsetsType == EdgeInsetsTypeTitle) {
        self.titleEdgeInsets = edgeInsets;
    } else {
        self.imageEdgeInsets = edgeInsets;
    }
}
@end
