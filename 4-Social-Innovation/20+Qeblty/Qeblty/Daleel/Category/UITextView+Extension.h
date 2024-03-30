//
//  UITextView+Extension.h
//  Gamfun
//
//  Created by mac on 2022/7/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (Extension)

- (void)setPlaceholderWithText:(NSString *)text Color:(UIColor *)color;

/** 限制字数*/
@property (nonatomic, assign) NSInteger limitCount;
/** 是否限制字符数，英文占1个字符，中文占2个字符，默认是NO*/
@property (nonatomic, assign) BOOL isLimitChar;
/** lab的右边距(默认10)*/
@property (nonatomic, assign) CGFloat labMargin;
/** lab的高度(默认20)*/
@property (nonatomic, assign) CGFloat labHeight;
/** 是否显示统计限制字数Label*/
@property (nonatomic, assign) BOOL hasLimitLabel;
/** 统计限制字数Label*/
@property (nonatomic, readonly) UILabel *inputLimitLabel;

@end

NS_ASSUME_NONNULL_END
