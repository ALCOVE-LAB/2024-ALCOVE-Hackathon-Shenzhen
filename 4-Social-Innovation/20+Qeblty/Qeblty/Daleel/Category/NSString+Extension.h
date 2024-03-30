//
//  NSString+Extension.h
//  Gamfun
//
//  Created by mac on 2022/6/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension)

/// yp - 将json转化为NSDictionary或者NSArray
+ (id)convertToObject:(NSString *)jsonString;
/// yp - 对象转json
+ (NSString *)convertToJsonStr:(id)object;
+ (NSString *)convertToJsonStr:(id)object hasSpace:(BOOL)hasSpace;
+ (CGSize)sizeForString:(NSString*)content font:(UIFont*)font maxWidth:(CGFloat) maxWidth;

/// yp - 计算单行文本size
- (CGSize)singleLineSizeWithText:(UIFont *)font;
/// 是否有空格
+ (BOOL)isEmpty:(NSString *)str;
+ (BOOL)isFirstEmpty:(NSString *)str;
/// 判断字符串是否全为空格
+ (BOOL)isAllEmpty:(NSString *)str;

/// 金额转换
+ (NSString *)stringChangeMoneyWithStr:(NSString *)str;
/// 获取带单位的 数量k m
+ (NSString *)getUnitStr:(NSString *)str;
/// 获取行间距多属性文本
+ (NSAttributedString *)getAttributeStrWithString:(NSString *)string lineSpace:(CGFloat)lineSpace;
/**
 判断是否有表情
 */
+ (BOOL)isContainsEmoji:(NSString *)string;

/**
 删除emoji表情
 */
+ (NSString *)deleteEmoji:(NSString *)text;

/**
 判断是否有特殊字符
 */
+ (BOOL)isContainsSpecialCharacters:(NSString *)string;

/**
 汉字，数字，英文，括号，下划线，横杠，空格(只能输入这些)
 */
+(NSString *)filterCharactors:(NSString *)string;

/**
 根据正在过滤特殊字符
 */
+ (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr;

/**
 除去特殊字符并限制字数的textFiled
 */
+ (void)restrictionInputTextFieldMaskSpecialCharacter:(UITextField *)textField maxNumber:(NSInteger)maxNumber;

/**
 textFiled限制字数
 */
+ (void)restrictionInputTextField:(UITextField *)textField maxNumber:(NSInteger)maxNumber;

/**
 除去特殊字符并限制字数的TextView
 */
+ (void)restrictionInputTextViewMaskSpecialCharacter:(UITextView *)textView maxNumber:(NSInteger)maxNumber;

/**
 textView限制字数
 */
+ (void)restrictionInputTextView:(UITextView *)textView maxNumber:(NSInteger)maxNumber;

/**
 判断textFiled文本长度是否超出最大限制
 */
+ (NSInteger)isTextField:(UITextField *)textField beyondLimitCount:(NSInteger)limitCount;

/**
 判断textView文本长度是否超出最大限制
 */
+ (NSInteger)isTextView:(UITextView *)textView beyondLimitCount:(NSInteger)limitCount;

/**
 判断文本长度是否超出最大限制，英文占1个字符，中文占2个字符
 */
+ (NSInteger)isText:(NSString *)text lengthBeyondLimitCount:(NSInteger)limitCount;

/**
 防止原生emoji表情被截断
 */
+ (NSString *)subStringWith:(NSString *)string index:(NSInteger)index;
+ (NSString *)subStringWith:(NSString *)string index:(NSInteger)index hasToast:(BOOL)hasToast;
/**
 游戏新老版判断
 */
+ (BOOL)gameNewOldJudge:(NSString *)gameVersion;

/**
 当前日期格式转换  返回格式为  week,month day
 */

+ (NSString *)dataFormatterChangeWithNowOrTRM:(BOOL )isTRM;

/**
 拿到一个时间戳 进行小时转换xx:xx:xx
 */
+ (NSString *)timeFormatted:(NSInteger )totalSeconds;

/**
 当前的时间戳
 */
+ (NSString *)nowTimeInterval;

/**
 当前的时间xxxx-xx-xx格式
 */
+ (NSString *)nowTimeFormatted;

/**
明天的时间xxxx-xx-xx格式
 */
+ (NSString *)tomorrowTimeFormatted;
/**
昨天的时间xxxx-xx-xx格式
 */
+ (NSString *)yesterdayTimeFormatted;

/**
 处理日期格式标准的1999-10-10
 */
+ (NSDateFormatter *)dateFormat;

/// 从字符串中提取出数字
- (NSString *)getNumberWithString;

/// 判断字符串中是否含有数字
- (BOOL)containsDigit;

/**
 阿语转换成阿拉伯数字
 
 arebic  传进来的正常的阿语
 */
+ (NSString *)translatNum:(NSString *)arebic;

@end

NS_ASSUME_NONNULL_END
