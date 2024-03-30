//
//  TextLimitTool.m
//  TextLimit
//
//  Created by slowdony on 2018/1/21.
//  Copyright © 2018年 slowdony. All rights reserved.
//

#import "TextLimitTool.h"

@implementation TextLimitTool

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
            NSString *alert = [NSString stringWithFormat:@"输入字数不能超过%ld个",(long)index];
            kToast(alert);
        }
    }
    
    return result;
}

@end
