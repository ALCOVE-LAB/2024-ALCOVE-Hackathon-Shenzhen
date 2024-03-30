//
//  UITextField+LimitCount.h
//  BasicFrame
//
//  Created by Jessica on 2018/12/17.
//  Copyright © 2018 Jessica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (LimitCount)

/** 限制字数*/
@property (nonatomic, assign) NSInteger limitCount;
/** 是否限制字符数，英文占1个字符，中文占2个字符，默认是NO*/
@property (nonatomic, assign) BOOL isLimitChar;

/** 限制字符*/
@property (nonatomic, copy) NSString *regexLimitStr;

@end
