//
//  UITextField+LimitCount.m
//  BasicFrame
//
//  Created by Jessica on 2018/12/17.
//  Copyright © 2018 Jessica. All rights reserved.
//

#import "UITextField+LimitCount.h"
#import "TextLimitTool.h"

static char limitCountKey;
static char isLimitCharKey;
static char regexLimitStrKey;

@implementation UITextField (LimitCount)

#pragma mark - associated
- (NSInteger)limitCount {
    return [objc_getAssociatedObject(self, &limitCountKey) integerValue];
}
- (void)setLimitCount:(NSInteger)limitCount {
    objc_setAssociatedObject(self, &limitCountKey, @(limitCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addTarget:self action:@selector(textFieldTextDidChangeWithLimitCount) forControlEvents:UIControlEventEditingChanged];
}
- (BOOL)isLimitChar {
    return [objc_getAssociatedObject(self, &isLimitCharKey) integerValue];
}
- (void)setIsLimitChar:(BOOL)isLimitChar {
    objc_setAssociatedObject(self, &isLimitCharKey, @(isLimitChar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)regexLimitStr {
    return objc_getAssociatedObject(self, &regexLimitStrKey);
}
- (void)setRegexLimitStr:(NSString *)regexLimitStr {
    objc_setAssociatedObject(self, &regexLimitStrKey, regexLimitStr, OBJC_ASSOCIATION_COPY);
    
    if (!regexLimitStr) {
        [self removeTarget:self action:@selector(textFieldTextDidChangeWithRegexLimit) forControlEvents:UIControlEventEditingChanged];
    }else {
        [self addTarget:self action:@selector(textFieldTextDidChangeWithRegexLimit) forControlEvents:UIControlEventEditingChanged];
    }
}

#pragma mark - 响应方法
- (void)textFieldTextDidChangeWithLimitCount {
    //获取高亮部分
    UITextRange *selectedRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    
    //没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position ||!selectedRange) {
        NSInteger maxLength = self.isLimitChar ? [TextLimitTool isTextField:self beyondLimitCount:self.limitCount] : self.limitCount;
        if (maxLength) {
            self.text = [TextLimitTool subStringWith:self.text index:maxLength];
            [self.undoManager removeAllActions];
        }
    }
}

- (void)textFieldTextDidChangeWithRegexLimit {
    NSString *toBeString = self.text;
    
    UITextRange *selectedRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    
    if ((!position ||!selectedRange)) {
        __block NSString *newStr = @"";
        [toBeString enumerateSubstringsInRange:NSMakeRange(0, toBeString.length)
                                       options:NSStringEnumerationByComposedCharacterSequences
                                    usingBlock: ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                        if ([self predicateWithString:substring pattern:self.regexLimitStr]) {
                                            newStr = [newStr stringByAppendingString:substring];
                                        }
                                    }];
        self.text = newStr;
    }
}
- (BOOL)predicateWithString:(NSString *)string pattern:(NSString *)pattern {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [predicate evaluateWithObject:string];
}

@end
