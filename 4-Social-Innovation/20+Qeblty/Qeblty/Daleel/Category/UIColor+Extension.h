//
//  UIColor+Extension.h
//  Gamfun
//
//  Created by mac on 2022/6/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Extension)

+ (UIColor *)gradientColorArr:(NSArray *)colors withHeight:(int)height;
+ (UIColor *)gradientColorArr:(NSArray *)colors withWidth:(int)Width;

/**
 *  @brief  渐变颜色 - yp
 *
 *  @param c1     开始颜色
 *  @param c2     结束颜色
 *  @param height 渐变高度
 *
 *  @return 渐变颜色
 */
+ (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height;
+ (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withWidth:(int)Width;
+ (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withPoint:(CGPoint)point;

/**
 *  @brief  hex 字符串创建UIColor  支持@“#123456”、 @“0X123456”、 @“123456”三种格式
 *
 *  @param hexString     hex 字符串
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/**
 *  @brief  hex 字符串创建UIColor  支持@“#123456”、 @“0X123456”、 @“123456”三种格式
 *
 *  @param hexString     hex 字符串
 *
 *  @param alpha     透明度
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;


/// 随机颜色
+ (UIColor *)randomColor;

@end

NS_ASSUME_NONNULL_END
