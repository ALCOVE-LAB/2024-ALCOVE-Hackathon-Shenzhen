//
//  ThemeMacro.h
//  Gamfun
//
//  Created by mac on 2024/3/29.
//

#ifndef ThemeMacro_h
#define ThemeMacro_h

/// yp - 颜色 (0xFFFFFF)
#define RGB(c) [UIColor colorWithRed:((float)((c & 0xFF0000) >> 16))/255.0f green:((float)((c & 0xFF00) >> 8))/255.0f blue:((float)(c & 0xFF))/255.0f alpha:1.0]
/// yp -  带透明度 颜色
#define RGB_ALPHA(c, a) [UIColor colorWithRed:((float)((c & 0xFF0000) >> 16))/255.0f green:((float)((c & 0xFF00) >> 8))/255.0f blue:((float)(c & 0xFF))/255.0f alpha:a]
/// yp - 色值 (255,255,255)
#define RGB_COLOR(_red, _green, _blue) [UIColor colorWithRed:(_red)/255.0f green:(_green)/255.0f blue:(_blue)/255.0f alpha:1]
/// yp - 色值 (255,255,255) 带透明度
#define RGB_COLOR_ALPHA(_red, _green, _blue, a) [UIColor colorWithRed:(_red)/255.0f green:(_green)/255.0f blue:(_blue)/255.0f alpha:a]

/// yp - 减少代码量
#define kWhiteColor [UIColor whiteColor]
#define kClearColor [UIColor clearColor]
#define kBlackColor [UIColor blackColor]
#define kLightGray RGB(0xE7E7E7)

/// yp - 公共背景色
#define kPublicBgColor RGB(0xf8f8f8)
#define k16Color RGB(0x161616)
/// yp - 默认文字颜色
#define kTextMainColor RGB(0xFFFFFF)
#define kRed_Color RGB(0xFB2754)
#define kLightGreen RGB(0x00D4E0)
#define kColor_textViewGray [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]
#define kColor_LightGray [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1.0]
#define kColor_Gray [UIColor colorWithRed:229 / 255.0 green:229 / 255.0 blue:229 / 255.0 alpha:1.0]
#define kColor_Blue [UIColor colorWithRed:45 / 255.0 green:116 / 255.0 blue:215 / 255.0 alpha:1.0]

#define Font(fontName, float) [UIFont fontWithName:fontName size:float] ?: [UIFont systemFontOfSize:float]

#define kFontBold(float) Font(@"SanFranciscoDisplay-Bold", float)
#define kFontSemibold(float) Font(@"SanFranciscoDisplay-Semibold",float)
#define kFontMedium(float) Font(@"SanFranciscoDisplay-Medium", float)
#define kFontRegular(float) Font(@"SanFranciscoDisplay-Regular", float)
#define kFontHeavy(float) Font(@"SanFranciscoDisplay-Heavy", float)
#define kFont(float)       [UIFont systemFontOfSize:float]
/// yp - 设计图高度是以 812 设计的 ,所以控件的y值 为了适配酌情以比例来计算
#define kScale_H (667/kScreenHeight)
#define kScale_W (375/kScreenWidth)

//随机颜色
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1]

#endif /* ThemeMacro_h */
