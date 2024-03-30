//
//  UILabel+Extension.m
//  Gamfun
//
//  Created by mac on 2022/7/8.
//

#import "UILabel+Extension.h"

@interface UILabel ()

@end

@implementation UILabel (Extension)

+ (void)load {
    Method textMethod = class_getInstanceMethod(self, @selector(setText:));
    Method newTextMethod = class_getInstanceMethod(self, @selector(cjdSetText:));
    method_exchangeImplementations(newTextMethod, textMethod);
}
//
//- (void)rtl_setTextAlignment:(NSTextAlignment)textAlignment{
//    if (kIsAR) {
//        if (textAlignment == NSTextAlignmentNatural || textAlignment == NSTextAlignmentLeft) {
//            textAlignment = NSTextAlignmentRight;
//        } else if (textAlignment == NSTextAlignmentRight) {
//            textAlignment = NSTextAlignmentLeft;
//        }
//    }
//    [self rtl_setTextAlignment:textAlignment];
//}

- (void)cjdSetText:(NSString *)text {
    NSString *useText = text;
    if (kIsAR) {
        if (text.length > 0) {
            NSString *str = text;
            NSArray *chineseNum = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
            NSArray *arabicNum = @[@"١",@"٢",@"٣",@"٤",@"٥",@"٦",@"٧",@"٨",@"٩",@"٠"];
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:arabicNum forKeys:chineseNum];
            NSMutableArray *sums = [NSMutableArray array];
            for (int i = 0; i < str.length; i ++) {
                NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
                NSString *sum = substr;
                if([chineseNum containsObject:substr]){
                    sum = [dictionary objectForKey:substr];
                }
                [sums addObject:sum];
            }
            useText = [sums  componentsJoinedByString:@""];
        }
    }
    [self cjdSetText:useText];
}

/// 创建 Label - 指定 字体 颜色
/// @param font 字体font
/// @param color 颜色
+ (UILabel *)labelWithTextFont:(UIFont *_Nullable)font textColor:(UIColor * _Nullable)color {
    return [UILabel labelWithTextFont:font textColor:color text:nil backgroundColor:nil alignment:NSTextAlignmentNatural];
}

/// 创建Label - 指定 字体 颜色 内容
/// @param font 字体
/// @param color 颜色
/// @param text 内容
+ (UILabel *)labelWithTextFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color text:(NSString *_Nullable)text {
    return [UILabel labelWithTextFont:font textColor:color text:text backgroundColor:nil alignment:NSTextAlignmentNatural];
}

/// 创建Label - 指定 字体 颜色 背景颜色
/// @param font 字体
/// @param color 颜色
/// @param backColor 背景色
+ (UILabel *)labelWithTextFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color backgroundColor:(UIColor *_Nullable)backColor {
    return [UILabel labelWithTextFont:font textColor:color text:nil backgroundColor:backColor alignment:NSTextAlignmentNatural];
}

/// 创建Label - 指定 字体 颜色 内容 背景颜色
/// @param font 字体
/// @param color 颜色
/// @param text 内容
/// @param backColor 背景色
+ (UILabel *)labelWithTextFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color text:(NSString *_Nullable)text backgroundColor:(UIColor *_Nullable)backColor {
    return [UILabel labelWithTextFont:font textColor:color text:text backgroundColor:backColor alignment:NSTextAlignmentNatural];
}

/// 创建Label - 指定 字体 颜色 内容 对齐方式
/// @param font 字体
/// @param color 颜色
/// @param text 内容
/// @param alignment 对齐方式
+ (UILabel *)labelWithTextFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color text:(NSString *_Nullable)text alignment:(NSTextAlignment)alignment {
    return [UILabel labelWithTextFont:font textColor:color text:text backgroundColor:nil alignment:alignment];
}

/// 创建Label - 指定 字体 颜色 内容 背景颜色 对齐方式
/// @param font 字体
/// @param color 颜色
/// @param text 内容
/// @param backColor 背景色
/// @param alignment 对齐方式
+ (UILabel *)labelWithTextFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color text:(NSString *_Nullable)text backgroundColor:(UIColor *_Nullable)backColor alignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    [label setTextFont:font textColor:color text:text backgroundColor:backColor alignment:alignment];
    [label sizeToFit];
    return label;
}

#pragma mark - 指定frame  masonry布局会比较少用
/// 创建Label - 指定 frame
/// @param frame frame
/// @param font 字体大小
/// @param color 字体颜色
+ (UILabel *)labelWithFrame:(CGRect)frame textFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color {
    return [UILabel labelWithFrame:frame textFont:font textColor:color text:nil backgroundColor:nil alignment:NSTextAlignmentNatural];
}

/// 创建Label - 指定 frame
/// @param frame frame
/// @param font 字体大小
/// @param color 字体颜色
/// @param text 内容
+ (UILabel *)labelWithFrame:(CGRect)frame textFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color text:(NSString *_Nullable)text {
    return [UILabel labelWithFrame:frame textFont:font textColor:color text:text backgroundColor:nil alignment:NSTextAlignmentNatural];
}

/// 创建Label - 指定 frame
/// @param frame frame
/// @param font 字体大小
/// @param color 字体颜色
/// @param backColor 背景色
+ (UILabel *)labelWithFrame:(CGRect)frame textFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color backgroundColor:(UIColor *_Nullable)backColor {
    return [UILabel labelWithFrame:frame textFont:font textColor:color text:nil backgroundColor:backColor alignment:NSTextAlignmentNatural];
}

/// 创建Label - 指定 frame
/// @param frame frame
/// @param font 字体大小
/// @param color 字体颜色
/// @param text 内容
/// @param backColor 背景色
+ (UILabel *)labelWithFrame:(CGRect)frame textFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color text:(NSString *_Nullable)text backgroundColor:(UIColor *_Nullable)backColor {
    return [UILabel labelWithFrame:frame textFont:font textColor:color text:text backgroundColor:backColor alignment:NSTextAlignmentNatural];
}

/// 创建Label - 指定 frame
/// @param frame frame
/// @param font 字体大小
/// @param color 字体颜色
/// @param text 内容
/// @param alignment 对齐方式
+ (UILabel *)labelWithFrame:(CGRect)frame textFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color text:(NSString *_Nullable)text alignment:(NSTextAlignment)alignment {
    return [UILabel labelWithFrame:frame textFont:font textColor:color text:text backgroundColor:nil alignment:alignment];
}

/// 创建Label - 指定 frame
/// @param frame frame
/// @param font 字体大小
/// @param color 字体颜色
/// @param text 内容
/// @param backColor 背景色
/// @param alignment 对齐方式
+ (UILabel *)labelWithFrame:(CGRect)frame textFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color text:(NSString *_Nullable)text backgroundColor:(UIColor *_Nullable)backColor alignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setTextFont:font textColor:color text:text backgroundColor:backColor alignment:alignment];
    return label;
}

+ (instancetype)labelWithTextColor:(UIColor *)color font:(CGFloat)font text:(NSString *_Nullable)text superView:(UIView *)sView {
    UILabel *lab = [UILabel new];
    lab.userInteractionEnabled = YES;
    lab.font = [UIFont systemFontOfSize:font];
    lab.textColor = color;
    if (text) {
        lab.text = text;
    }
    if (sView != nil) {
        [sView addSubview:lab];
    }
    [lab sizeToFit];
    return lab;
}

+ (instancetype)labelWithTextColor:(UIColor *)color boldFont:(CGFloat)font text:(NSString * _Nullable)text superView:(UIView * _Nullable)sView {
    UILabel *lab = [UILabel new];
    lab.userInteractionEnabled = YES;
    lab.font = [UIFont boldSystemFontOfSize:font];
    lab.textColor = color;
    if (text) {
        lab.text = text;
    }
    if (sView != nil) {
        [sView addSubview:lab];
    }
    [lab sizeToFit];
    return lab;
}

- (void)setTextFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color {
    [self setTextFont:font textColor:color text:nil backgroundColor:nil alignment:NSTextAlignmentLeft];
}

- (void)setTextFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color text:(NSString *_Nullable)text {
    [self setTextFont:font textColor:color text:text backgroundColor:nil alignment:NSTextAlignmentLeft];
}

- (void)setTextFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color backgroundColor:(UIColor *_Nullable)backColor {
    [self setTextFont:font textColor:color text:nil backgroundColor:backColor alignment:NSTextAlignmentNatural];
}

- (void)setTextFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color text:(NSString *_Nullable)text backgroundColor:(UIColor *_Nullable)backColor {
    [self setTextFont:font textColor:color text:text backgroundColor:backColor alignment:NSTextAlignmentNatural];
}

- (void)setTextFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color text:(NSString *_Nullable)text alignment:(NSTextAlignment)alignment {
    [self setTextFont:font textColor:color text:text backgroundColor:nil alignment:alignment];
}

- (void)setTextFont:(UIFont *_Nullable)font textColor:(UIColor *_Nullable)color text:(NSString *_Nullable)text backgroundColor:(UIColor *_Nullable)backColor alignment:(NSTextAlignment)alignment {
    if (font) {
        self.font = font;
    }
    if (color) {
        self.textColor = color;
    }
    if (text) {
        self.text = text;
    }
    if (backColor) {
        self.backgroundColor = backColor;
    }
    if (alignment) {
        self.textAlignment = alignment;
    }
}

- (void)addDeleteLine:(UIColor *)color {
    NSUInteger length = [self.text length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:color range:NSMakeRange(0, length)];
    [self setAttributedText:attri];
}

@end
