//
//  UIViewController+Extension.h
//  Gamfun
//
//  Created by mac on 2022/6/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Extension)

/// yp - 获取顶层控制器 或者说root
+ (UIViewController *)rootViewController;
/// yp - 获取当前控制器
+ (UIViewController *)getCurrentViewController;

- (UIViewController *)uacb_topmost;

/// 移除某个控制器
- (void)removeControllerWithController:(NSString *)vc;

/// yp - 对象方法 self直接使用  不用再写self.navigationcontroller 了
/// yp - 返回上一层
- (void)popAnimated;
/// yp - 返回到root
- (void)popRootAnimated;
/// pop 到指定页面
- (void)popToViewController:(NSString *)controller;
- (void)dismissViewController;
- (void)pushViewController:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
