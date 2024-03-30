//
//  UIFont+Extension.m
//  Gamfun
//
//  Created by mac on 2022/6/10.
//

#import "UIFont+Extension.h"

@implementation UIFont (Extension)

+ (void)load {
    Method newMethod = class_getClassMethod([self class], @ selector(adjustFontOfSize:));
    Method method = class_getClassMethod([self class], @selector(systemFontOfSize:));
    method_exchangeImplementations(newMethod, method);
    
    Method newFontNameMethod = class_getClassMethod([self class], @selector(adjustFontWithName:size:));
    Method sysFontNameMethod = class_getClassMethod([self class], @selector(fontWithName:size:));
    method_exchangeImplementations(newFontNameMethod, sysFontNameMethod);
}

+ (UIFont *)adjustFontOfSize:(CGFloat)fontSize {
    return [UIFont adjustFontOfSize:floor(fontSize * kScreenWidth / 375.f)];
}

+ (UIFont *)adjustFontWithName:(NSString *)fontName size:(CGFloat)fontSize {
    return [UIFont adjustFontWithName:fontName size:floor(fontSize * kScreenWidth / 375.f)];
}

@end
