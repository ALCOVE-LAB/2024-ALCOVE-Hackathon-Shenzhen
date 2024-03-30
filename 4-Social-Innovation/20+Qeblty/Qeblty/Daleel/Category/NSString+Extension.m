//
//  NSString+Extension.m
//  Gamfun
//
//  Created by mac on 2022/6/10.
//

#import "NSString+Extension.h"
#import <objc/runtime.h>

@implementation NSString (Extension)

+ (void)load {
    Method substringToIndex = class_getInstanceMethod(self, @selector(substringToIndex:));
    Method substringToIndexNew = class_getInstanceMethod(self, @selector(substringToIndexNew:));
    method_exchangeImplementations(substringToIndex, substringToIndexNew);
}

- (NSString *)substringToIndexNew:(NSInteger)index {
    if (self.length <= index) {
        return self;
    }
    NSRange rangeIndex = [self rangeOfComposedCharacterSequenceAtIndex:index];
    if (rangeIndex.length == 1) {
        NSRange rangeRange = [self rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, index)];
        return [self substringWithRange:rangeRange];
    }else {
        NSRange rangeRange = [self rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, index-1)];
        return [self substringWithRange:rangeRange];
    }
}


/// yp - 将json转化为NSDictionary或者NSArray
+ (id)convertToObject:(NSString *)jsonString {
    if (![jsonString isKindOfClass:[NSString class]] || !jsonString.length) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData  options:NSJSONReadingAllowFragments error:&error];
    if (jsonObject != nil && error == nil) {
        return jsonObject;
    }else {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
}

/// 对象转json字符串方法
+ (NSString *)convertToJsonStr:(id)object {
    return [self convertToJsonStr:object hasSpace:YES];
}

/// 对象转json字符串方法 hasSpace是否保留空格
+ (NSString *)convertToJsonStr:(id)object hasSpace:(BOOL)hasSpace {
    NSString *jsonString = nil;
    if (!object || ![NSJSONSerialization isValidJSONObject:object]) {
        return jsonString;
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else {
        NSLog(@"%@",error);
    }
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (!hasSpace) {
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return jsonString;
}

+ (CGSize)sizeForString:(NSString*)content font:(UIFont*)font maxWidth:(CGFloat) maxWidth{
    if (!content || content.length == 0) {
        return CGSizeMake(0, 0);
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary * attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName: paragraphStyle};
    CGSize textRect = CGSizeMake(maxWidth, MAXFLOAT);
    CGSize textSize = [content boundingRectWithSize:textRect options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    return  textSize;
}

/// yp - 计算单行文本size
- (CGSize)singleLineSizeWithText:(UIFont *)font {
    return [self sizeWithAttributes:@{NSFontAttributeName:font}];
}

/// 是否有空格
+ (BOOL)isEmpty:(NSString *)str {
    NSRange range = [str rangeOfString:@" "];
  if (range.location != NSNotFound) {
    return YES;
  }else {
    return NO;
  }
}

+ (BOOL)isFirstEmpty:(NSString *)str {
    NSString *firstStr = [str substringToIndex:1];
    return [firstStr isEqualToString:@" "];
}

+ (BOOL)isAllEmpty:(NSString *)str {
    if (!str) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
    if ([trimedString length] == 0) {
        return YES;
     }else{
       return false;
     }
}

/// 金额的格式转换
+ (NSString *)stringChangeMoneyWithStr:(NSString *)str {
    // 判断是否null 若是赋值为0 防止崩溃
    if (([str isEqual:[NSNull null]] || str == nil || [str isEqualToString:@"0"])) {
        return @"0";
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSString *money = [formatter stringFromNumber:[NSNumber numberWithDouble:[str doubleValue]]];
    if (@available(iOS 14.0, *)) {
        if ([money containsString:@"."]) {
            money = [money stringByReplacingOccurrencesOfString:@"." withString:@","];
        }
    }
    return money;
}

/// 获取带单位的 数量
+ (NSString *)getUnitStr:(NSString *)str {
    double sumdouble = str.doubleValue;
    if (sumdouble < 0) {
        str = @"0";
    }
    if (sumdouble > 1000) {
        double f = sumdouble/1000;
        str = [NSString stringWithFormat:@"%.1fK",f];
    }
    if (sumdouble >= 1000000 ) {
        double f = sumdouble/1000000;
        str = [NSString stringWithFormat:@"%.1fM",f];
    }
    if (sumdouble >= 1000000000) {
        double f = sumdouble/1000000000;
        str = [NSString stringWithFormat:@"%.1fB",f];
    }
    return str;
}

/// 获取行间距多属性文本
+ (NSAttributedString *)getAttributeStrWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    NSRange range = NSMakeRange(0, string.length);
    [attributeString addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:range];
    return attributeString;
}




/**
 判断NSString中是否有表情
 */
+ (BOOL)isContainsEmoji:(NSString *)string {
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    isEomji = YES;
                }
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                if (!(9312 <= hs && hs <= 9327)) { // 9312代表①   表示①至⑯
                    isEomji = YES;
                }
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                isEomji = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                isEomji = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                isEomji = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                isEomji = YES;
            }
            if (!isEomji && substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                if (ls == 0x20e3) {
                    isEomji = YES;
                }
            }
        }
    }];
    return isEomji;
}
/**
 删除emoji表情
 */
+ (NSString *)deleteEmoji:(NSString *)text {
    return [self filterCharactor:text withRegex:kEmojiRegexp];
}

/**
 判断是否存在特殊字符 只能输入汉字，数字，英文，括号，下划线，横杠，空格
 */
+ (BOOL)isContainsSpecialCharacters:(NSString *)searchText {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kRegularRegexp options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    if (result) {
        return YES;
    }else {
        return NO;
    }
}
/**
 只能输入汉字，数字，英文，括号，下划线，横杠，空格
 */
+ (NSString *)filterCharactors:(NSString *)string {
    return [self filterCharactor:string withRegex:kRegularRegexp];
}

/**
 根据正则过滤特殊字符
 */
+ (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr {
    NSString *searchText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}

/**
 除去特殊字符并限制字数的textFiled
 */
+ (void)restrictionInputTextFieldMaskSpecialCharacter:(UITextField *)textField maxNumber:(NSInteger)maxNumber {
    if ([self isContainsEmoji:textField.text]) {
        textField.text = [self deleteEmoji:textField.text];
        return;
    }
    if ([self isContainsSpecialCharacters:textField.text]) {
        textField.text = [self filterCharactors:textField.text];
        return;
    }
    [self restrictionInputTextField:textField maxNumber:maxNumber];
}
/**
 除去特殊字符并限制字数的TextView
 */
+ (void)restrictionInputTextViewMaskSpecialCharacter:(UITextView *)textView maxNumber:(NSInteger)maxNumber {
    if ([self isContainsEmoji:textView.text]) {
        textView.text = [self deleteEmoji:textView.text];
        return;
    }
    if ([self isContainsSpecialCharacters:textView.text]) {
        textView.text = [self filterCharactors:textView.text];
        return;
    }
    [self restrictionInputTextView:textView maxNumber:maxNumber];
}
/**
 textFiled限制字数
 */
+ (void)restrictionInputTextField:(UITextField *)textField maxNumber:(NSInteger)maxNumber {
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    //没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        textField.text = [self subStringWith:textField.text index:maxNumber];
    }else { //有高亮选择的字符串，则暂不对文字进行统计和限制
    }
}
/**
 textView限制字数
 */
+ (void)restrictionInputTextView:(UITextView *)textView maxNumber:(NSInteger)maxNumber {
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    //没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        textView.text = [self subStringWith:textView.text index:maxNumber];
    }else { //有高亮选择的字符串，则暂不对文字进行统计和限制
    }
}

/**
 判断textFiled文本长度是否超出最大限制
 */
+ (NSInteger)isTextField:(UITextField *)textField beyondLimitCount:(NSInteger)limitCount {
    NSString *lang = textField.textInputMode.primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
//        limitCount *= 2;
    }
    return [self isText:textField.text lengthBeyondLimitCount:limitCount];
}
/**
 判断textView文本长度是否超出最大限制
 */
+ (NSInteger)isTextView:(UITextView *)textView beyondLimitCount:(NSInteger)limitCount {
    NSString *lang = textView.textInputMode.primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
//        limitCount *= 2;
    }
    return [self isText:textView.text lengthBeyondLimitCount:limitCount];
}
/**
 判断文本长度是否超出最大限制，英文占1个字符，中文占2个字符
 */
+ (NSInteger)isText:(NSString *)text lengthBeyondLimitCount:(NSInteger)limitCount {
    //文本的字符长度，中文占两个字符
    NSUInteger charSize = 0;
    //文本的length最大长度
    NSUInteger maxLength = 0;
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex:i];
        charSize += isascii(uc) ? 1 : 2;
        if (limitCount > 0 && charSize <= limitCount) {
            maxLength++;
        }
    }
    if (maxLength > 0 && charSize > limitCount) {
        return maxLength;
    }else {
        return 0;
    }
}

/**
 防止原生emoji表情被截断
 */
+ (NSString *)subStringWith:(NSString *)string index:(NSInteger)index {
    return [self subStringWith:string index:index hasToast:NO];
}
+ (NSString *)subStringWith:(NSString *)string index:(NSInteger)index hasToast:(BOOL)hasToast {
    NSString *result = string;
    if (result.length > index) {
        NSRange rangeIndex = [result rangeOfComposedCharacterSequenceAtIndex:index];
        if (rangeIndex.length == 1) {
            result = [result substringToIndex:index];
        }else {
            NSRange rangeRange = [result rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, index)];
            result = [result substringWithRange:rangeRange];
        }
        
        if (hasToast) {
//            NSString *alert = [NSString stringWithFormat:@"输入字数不能超过%ld个",(long)index];
//            kToast(alert);
        }
    }
    
    return result;
}

/**
 游戏新老版判断
 */
+ (BOOL)gameNewOldJudge:(NSString *)gameVersion {
    gameVersion = [gameVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSInteger versionNum = [gameVersion integerValue];
    
    NSString * app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    app_Version = [app_Version stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSInteger appVersionNum = [app_Version integerValue];
    
    if (appVersionNum < versionNum) {
        return NO;
    } else {
        return YES;
    }
}

+ (NSString *)dataFormatterChangeWithNowOrTRM:(BOOL )isTRM {
    NSDate *date = [NSDate date];
    if (isTRM) {
        NSTimeInterval secondsPerDay = 24 * 60 * 60;
        date = [[NSDate alloc] initWithTimeIntervalSinceNow:secondsPerDay];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"ccc,LLL dd";
    if ([LanguageTool isArabic]) {
        formatter.dateFormat = @"cccc,LLLL dd";
    }
    
    return [formatter stringFromDate:date];
}

+ (NSString *)timeFormatted:(NSInteger )totalSeconds {
    NSInteger day = (totalSeconds/(3600 * 24));
    NSInteger hour = ((totalSeconds - day * 24 * 3600) / 3600);
    NSInteger minute = (totalSeconds - day * 24 * 3600 - hour * 3600) / 60;
    NSInteger second = totalSeconds - day * 24 * 3600 - hour * 3600 - minute * 60;
    
    NSString *hourStr = (day * 24) + hour < 10 ? [NSString stringWithFormat:@"0%ld",(day * 24) + hour] : [NSString stringWithFormat:@"%ld",(day * 24) + hour];
    NSString *minuteStr = minute < 10 ? [NSString stringWithFormat:@"0%ld",minute] : [NSString stringWithFormat:@"%ld",minute];
    NSString *secondStr = second < 10 ? [NSString stringWithFormat:@"0%ld",second] : [NSString stringWithFormat:@"%ld",second];
    return [NSString stringWithFormat:@"%@:%@:%@",hourStr,minuteStr,secondStr];
}

+ (NSString *)nowTimeInterval {
    // 现在的时间戳
    // 获取当前时间0秒后的时间
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    // *1000 是精确到毫秒，不乘就是精确到秒
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;
    NSString *timeStr = [NSString stringWithFormat:@"%.0f",time];
    return timeStr;
}

+ (NSString *)nowTimeFormatted {
    NSDate * date = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateStr = [dateformatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)tomorrowTimeFormatted {
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    //@"YYYY-MM-dd HH:mm"是日期格式，还有@"YYYY-MM-dd“，@"YYYY-MM-dd HH:mm:ss"等；
    //HH表示24小时制，hh表示12小时制
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *tomorrow = [[NSDate alloc] initWithTimeIntervalSinceNow:secondsPerDay];
    NSString *tomorrowStr = [dateformatter stringFromDate:tomorrow];
    
    return tomorrowStr;
}

+ (NSString *)yesterdayTimeFormatted {
    //昨天时间
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    //@"YYYY-MM-dd HH:mm"是日期格式，还有@"YYYY-MM-dd“，@"YYYY-MM-dd HH:mm:ss"等；
    //HH表示24小时制，hh表示12小时制
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *yesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];
    NSString *yesterdayStr = [dateformatter stringFromDate:yesterday];
    
    return yesterdayStr;
}

+ (NSDateFormatter *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    formatter.timeZone = [NSTimeZone systemTimeZone];
    
    return formatter;
}
/// 判断字符串中是否包含数字
- (BOOL)containsDigit {
    for (int i = 0; i < self.length; i++) {
        unichar c = [self characterAtIndex:i];
        if((c > 47)&&(c < 58)) {
            return YES;
        }
    }
    return NO;
}
- (NSString *)getNumberWithString {
    NSMutableArray *characters = [NSMutableArray array];
    NSMutableString *mutStr = [NSMutableString string];
    // 分离出字符串中的所有字符，并存储到数组characters中
    for (int i = 0; i < self.length; i ++) {
        NSString *subString = [self substringToIndex:i + 1];
        subString = [subString substringFromIndex:i];
        [characters addObject:subString];
    }
    // 利用正则表达式，匹配数组中的每个元素，判断是否是数字，将数字拼接在可变字符串mutStr中
    for (NSString *b in characters) {
        NSString *regex = @"^[0-9]*$";
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];// 谓词
        BOOL isShu = [pre evaluateWithObject:b];// 对b进行谓词运算
        if (isShu) {
            [mutStr appendString:b];
        }
    }
    return [NSString stringWithFormat:@"%@",mutStr];
}

///阿语转换成阿拉伯数字
+ (NSString *)translatNum:(NSString *)arebic{
    NSString *str = arebic;

    NSArray *arNum = @[@"١",@"٢",@"٣",@"٤",@"٥",@"٦",@"٧",@"٨",@"٩",@"٠"];
    NSArray *chNum = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];

    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chNum forKeys:arNum];

    NSMutableArray *sums = [NSMutableArray array];

    for (int i = 0; i < str.length; i ++) {
        NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *sum = substr;
        if([arNum containsObject:substr]){
            sum = [dictionary objectForKey:substr];
        }
        [sums addObject:sum];
    }
    NSString *sumStr = [sums  componentsJoinedByString:@""];
    return sumStr;
}
@end
