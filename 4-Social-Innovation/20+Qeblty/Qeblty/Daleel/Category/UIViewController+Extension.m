//
//  UIViewController+Extension.m
//  Gamfun
//
//  Created by mac on 2022/6/10.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)


/// yp - 获取顶层控制器
+ (UIViewController *)rootViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

+ (UIViewController *)getCurrentViewController {
    UIViewController* currentViewController = [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else {
            if ([currentViewController isKindOfClass:[UINavigationController class]]) {
                currentViewController = ((UINavigationController *)currentViewController).visibleViewController;
            } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
                currentViewController = ((UITabBarController* )currentViewController).selectedViewController;
            } else {
                break;
            }
        }
    }
    return currentViewController;
}

- (UIViewController *)uacb_topmost {
    UIViewController *topmost = self;
    UIViewController *above;
    while ((above = topmost.presentedViewController)) {
        topmost = above;
    }
    return topmost;
}

- (void)removeControllerWithController:(NSString *)vc {
    if (!self.navigationController) {
        return;
    }
    NSMutableArray *vcArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *tempvc in vcArr) {
        if ([tempvc isKindOfClass:NSClassFromString(vc)]) {
            [vcArr removeObject:tempvc];
            break;
        }
    }
    [self.navigationController setViewControllers:vcArr];
}

- (void)popRootAnimated {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)popAnimated {
    [self.navigationController popViewControllerAnimated:YES];
}
/// pop 到指定页面
- (void)popToViewController:(NSString *)controller {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(controller)]) {
            [[UIViewController getCurrentViewController].navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}

- (void)dismissViewController {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)pushViewController:(UIViewController *)vc {
    [[UIViewController getCurrentViewController].navigationController pushViewController:vc animated:YES];
}



@end
