//
//  UITextView+Extension.m
//  Gamfun
//
//  Created by mac on 2022/7/20.
//

#import "UITextView+Extension.h"

static char limitCountKey;
static char isLimitCharKey;
static char labMarginKey;
static char labHeightKey;
static char hasLimitLabelKey;

@implementation UITextView (Extension)

+ (void)load {
    
    // 获取类方法 class_getClassMethod
    // 获取对象方法 class_getInstanceMethod
    
    Method setFontMethod = class_getInstanceMethod(self, @selector(setFont:));
    Method was_setFontMethod = class_getInstanceMethod(self, @selector(was_setFont:));
    
    // 交换方法的实现
    method_exchangeImplementations(setFontMethod, was_setFontMethod);
}

- (void)setPlaceholderWithText:(NSString *)text Color:(UIColor *)color{
    //多余 强指针换了指向以后label自动销毁
    //防止重复设置 cell复用等问题
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    //设置占位label
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = self.font;
    label.textColor = color;
    label.numberOfLines = 0;
    [label sizeToFit];
    
    [self addSubview:label];
    [self setValue:label forKey:@"_placeholderLabel"];
}

- (void)was_setFont:(UIFont *)font{
    //调用原方法 setFont:
    [self was_setFont:font];
    //设置占位字符串的font
    UILabel *label = [self valueForKey:@"_placeholderLabel"];
    label.font = font;
//    NSLog(@"%s", __func__);
}


#pragma mark - associated
- (NSInteger)limitCount {
    return [objc_getAssociatedObject(self, &limitCountKey) integerValue];
}
- (void)setLimitCount:(NSInteger)limitCount {
    objc_setAssociatedObject(self, &limitCountKey, @(limitCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (limitCount > 0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChangeNotification:) name:UITextViewTextDidChangeNotification object:self];
    }else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}
- (BOOL)isLimitChar {
    return [objc_getAssociatedObject(self, &isLimitCharKey) integerValue];
}
- (void)setIsLimitChar:(BOOL)isLimitChar {
    objc_setAssociatedObject(self, &isLimitCharKey, @(isLimitChar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)labMargin {
    return [objc_getAssociatedObject(self, &labMarginKey) floatValue];
}
- (void)setLabMargin:(CGFloat)labMargin {
    objc_setAssociatedObject(self, &labMarginKey, @(labMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)labHeight {
    return [objc_getAssociatedObject(self, &labHeightKey) floatValue];
}
- (void)setLabHeight:(CGFloat)labHeight {
    objc_setAssociatedObject(self, &labHeightKey, @(labHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hasLimitLabel {
    return [objc_getAssociatedObject(self, &hasLimitLabelKey) boolValue];
}
- (void)setHasLimitLabel:(BOOL)hasLimitLabel {
    objc_setAssociatedObject(self, &hasLimitLabelKey, @(hasLimitLabel), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (hasLimitLabel) {
        if (self.limitCount > 0) {
            if ([self.superview.subviews containsObject:self.inputLimitLabel]) {
                return;
            }
            [self.superview insertSubview:self.inputLimitLabel aboveSubview:self];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NSNotification
- (void)textViewTextDidChangeNotification:(NSNotification *)notification {
    if (self != notification.object) return;
    
    //获取高亮部分
    UITextRange *selectedRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    
    //没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (position) {
        return;
    }
    
    [self handleTextChangeWithLimitCount:self.limitCount];
}
- (void)handleTextChangeWithLimitCount:(NSInteger)limitCount {
    NSInteger maxLength = self.isLimitChar ? [NSString isTextView:self beyondLimitCount:limitCount] : limitCount;
    if (maxLength) {
        self.text = [NSString subStringWith:self.text index:maxLength];
        [self.undoManager removeAllActions];
    }
    
    if (self.hasLimitLabel && limitCount > 0) {
        [self updateLimitCount];
    }
}

#pragma mark - update
- (void)updateLimitCount {
    if (self.text.length > self.limitCount) {
        return;
    }
    
    NSString *showText = [NSString stringWithFormat:@"%lu/%ld",(unsigned long)self.text.length,(long)self.limitCount];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:showText];
    NSUInteger length = [showText length];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.tailIndent = -self.labMargin;
    style.alignment = NSTextAlignmentRight;
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, length)];
    self.inputLimitLabel.attributedText = attrString;
}

#pragma mark - lazzing
- (UILabel *)inputLimitLabel {
    UILabel *label = objc_getAssociatedObject(self, @selector(inputLimitLabel));
    if (!label) {
        self.labHeight = 20;
        self.labMargin = 10;
        
        UIEdgeInsets textContainerInset = self.textContainerInset;
        textContainerInset.bottom = self.labHeight;
        self.contentInset = textContainerInset;
        CGFloat x = CGRectGetMinX(self.frame)+self.layer.borderWidth;
        CGFloat y = CGRectGetMaxY(self.frame)-self.contentInset.bottom-self.layer.borderWidth;
        CGFloat width = CGRectGetWidth(self.bounds)-self.layer.borderWidth*2;
        CGFloat height = self.labHeight;
        label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        label.backgroundColor = kRed_Color;
        label.textColor = RGB_ALPHA(0xE1CEFF, 0.3);
        label.textAlignment = NSTextAlignmentRight;
        objc_setAssociatedObject(self, @selector(inputLimitLabel), label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return label;
}

@end
