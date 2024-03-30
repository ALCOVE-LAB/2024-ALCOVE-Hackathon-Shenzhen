//
//  UINavigationController+NavExt.m
//  NavThings
//
//  Created by mac on 2023/5/30.
//

#import "UINavigationController+NavExt.h"
#import "UINavigationBar+ext.h"
#import <objc/runtime.h>


void swizzleMethod (SEL originalSelector, SEL currentSelector, Class class)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, currentSelector);
    
    BOOL didAddMethod = class_addMethod(class,originalSelector,method_getImplementation(swizzledMethod),method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,currentSelector,method_getImplementation(originalMethod),method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

static char * const transitionCoordinatorAnimationEffectiveKey = "transitionCoordinatorAnimationEffectiveKey";
static char * const animatedKey = "animatedKey";
static char * const isPushKey   = "isPushKey";
static char * const navigationBarAlphaKey = "navigationBarAlphaKey";
static char * const navigationBarContentTinkcolorKey = "navigationBarContentTinkcolorKey";
static char * const navigationBarUserInteractionEnabledKey = "navigationBarUserInteractionEnabledKey";

@interface UINavigationController ()<UINavigationBarDelegate,UINavigationControllerDelegate>

/// 转场动画协调器`transitionCoordinator`设置的动画是否已经生效
@property (nonatomic, assign) BOOL transitionCoordinatorAnimationEffective;
/// 是否动画跳转页面
@property (nonatomic, assign) BOOL animated;
/// 当前呈现视图控制器是否是push
@property (nonatomic, assign) BOOL isPush;
/// 导航栏透明度
@property (nonatomic, assign) CGFloat navigationBarAlpha;
/// 导航栏文字 返回按钮颜色
@property (nonatomic, strong) UIColor *navigationBarContentTinkcolor;
/// 导航栏是否可以点击
@property (nonatomic, assign) BOOL navigationBarUserInteractionEnabled;

@end

@implementation UINavigationController (NavExt)

+(void)load {
    SEL initWithRootViewController    = @selector(initWithRootViewController:);
    SEL hk_initWithRootViewController  = @selector(hk_initWithRootViewController:);
    swizzleMethod(initWithRootViewController, hk_initWithRootViewController, [self class]);
    
    SEL popToViewController    = @selector(popToViewController:animated:);
    SEL hk_popToViewController  = @selector(hk_popToViewController:animated:);
    swizzleMethod(popToViewController, hk_popToViewController, [self class]);
    
    SEL popViewControllerAnimated    = @selector(popViewControllerAnimated:);
    SEL hk_popViewControllerAnimated  = @selector(hk_popViewControllerAnimated:);
    swizzleMethod(popViewControllerAnimated, hk_popViewControllerAnimated, [self class]);
    
    SEL popToRootViewControllerAnimated    = @selector(popToRootViewControllerAnimated:);
    SEL hk_popToRootViewControllerAnimated  = @selector(hk_popToRootViewControllerAnimated:);
    swizzleMethod(popToRootViewControllerAnimated, hk_popToRootViewControllerAnimated, [self class]);
    
    SEL pushViewController    = @selector(pushViewController:animated:);
    SEL hk_pushViewController  = @selector(hk_pushViewController:animated:);
    swizzleMethod(pushViewController, hk_pushViewController, [self class]);
}

#pragma mark - hook
- (instancetype)hk_initWithRootViewController:(UIViewController *)rootViewController {
    UINavigationController *nav = [self hk_initWithRootViewController:rootViewController];
    nav.delegate = nav;
    return nav;
}

- (UIViewController *)hk_popViewControllerAnimated:(BOOL)animated {
    self.animated = animated;
    self.isPush = NO;
    return [self hk_popViewControllerAnimated:animated];
}


- (NSArray<UIViewController *> *)hk_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.animated = animated;
    self.isPush = NO;
    return [self hk_popToViewController:viewController animated:animated];
}


- (NSArray<UIViewController *> *)hk_popToRootViewControllerAnimated:(BOOL)animated {
    self.animated = animated;
    self.isPush = NO;
    return [self hk_popToRootViewControllerAnimated:animated];
}


- (void)hk_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.animated = animated;
    self.isPush = YES;
    [self hk_pushViewController:viewController animated:animated];
}


#pragma mark - property setter getter

- (void)setTransitionCoordinatorAnimationEffective:(BOOL)transitionCoordinatorAnimationEffective {
    objc_setAssociatedObject(self, transitionCoordinatorAnimationEffectiveKey, @(transitionCoordinatorAnimationEffective), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)transitionCoordinatorAnimationEffective {
    id transitionCoordinatorAnimationEffective = objc_getAssociatedObject(self, transitionCoordinatorAnimationEffectiveKey);
    
    return [transitionCoordinatorAnimationEffective boolValue];
}

- (void)setAnimated:(BOOL)animated {
    objc_setAssociatedObject(self, animatedKey, @(animated), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)animated {
    id animated = objc_getAssociatedObject(self, animatedKey);
    
    return [animated boolValue];
}

- (void)setIsPush:(BOOL)isPush {
    objc_setAssociatedObject(self, isPushKey, @(isPush), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isPush {
    id isPush = objc_getAssociatedObject(self, isPushKey);
    return [isPush boolValue];
}

- (void)setNavigationBarAlpha:(CGFloat)navigationBarAlpha {
    objc_setAssociatedObject(self, navigationBarAlphaKey, @(navigationBarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)navigationBarAlpha {
    id alpha = objc_getAssociatedObject(self, navigationBarAlphaKey);
    if (alpha == NULL) {
        return 1.0;
    }else {
        return [alpha floatValue];
    }
}

- (void)setNavigationBarContentTinkcolor:(UIColor *)navigationBarContentTinkcolor {
    objc_setAssociatedObject(self, navigationBarContentTinkcolorKey, navigationBarContentTinkcolor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)navigationBarContentTinkcolor {
    UIColor *color = objc_getAssociatedObject(self, navigationBarContentTinkcolorKey);
    if (color == NULL) {
        return [UIColor whiteColor];
    }else {
        return color;
    }
}

- (BOOL)navigationBarUserInteractionEnabled {
    id navigationBarUserInteractionEnabled = objc_getAssociatedObject(self, navigationBarUserInteractionEnabledKey);
    return [navigationBarUserInteractionEnabled boolValue];
}

- (void)setNavigationBarUserInteractionEnabled:(BOOL)enable {
    objc_setAssociatedObject(self, navigationBarUserInteractionEnabledKey, @(enable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!navigationController.navigationBar.effectBackground) { // 还没有创建导航栏的自定义背景
        // 添加背景并设置默认颜色为白色
        [self.navigationBar addNavigationBarEffectBackground];
        [self updateNavigationBarAppearance];
    } else {
        if (self.navigationBar.transform.ty != 0.0) {
            self.navigationBar.transform = CGAffineTransformIdentity;
        }
        if (!self.transitionCoordinatorAnimationEffective) {
            if (animated) {
                [self addFakeNavigationBarToViewController];
                self.transitionCoordinatorAnimationEffective = YES;
            } else {
                [self updateNavigationBarAppearance];
            }
        } else {
            if (animated) {
                [self setNavigationBarAnimation];
            } else {
                [self updateNavigationBarAppearance];
            }
        }
    }
    // 更新导航栏是否可以点击
    dispatch_async(dispatch_get_main_queue(), ^{
        self.navigationBar.userInteractionEnabled = self.navigationBarUserInteractionEnabled;
    });
}

#pragma mark - public

- (void)setNavigationBarBackgroundAlpha:(float)alpha {
    self.navigationBarAlpha = alpha; // 调用updateNavigationBarAppearance后才回生效
}

- (void)setNavigationBarContentTinkColor:(UIColor *)color {
    self.navigationBarContentTinkcolor = color; // 调用updateNavigationBarAppearance后才回生效
}

- (void)setNavigationBarTouchEnabled:(BOOL)enable {
    self.navigationBarUserInteractionEnabled = enable;
}

/// 更新导航栏外观
- (void)updateNavigationBarAppearance {
    [self.navigationBar setNavBarContentColor:self.navigationBarContentTinkcolor];
    [self.navigationBar setNavBarBackgroundAlpha:self.navigationBarAlpha];
}

#pragma mark - private
/// 分别在 fromVC 和 toVC 中添加假的导航栏背景来伪造导航栏转场动画
- (void)addFakeNavigationBarToViewController {
    UIView *barBackgroundView = self.navigationBar.subviews.firstObject;
    
    UIViewController *fromVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIVisualEffectView *fromEffectBar = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    fromEffectBar.frame = CGRectMake(0.0, fromVC.view.frame.size.height - [UIScreen mainScreen].bounds.size.height, barBackgroundView.bounds.size.width, barBackgroundView.bounds.size.height);
    [fromEffectBar addBottomCornerPath:12];
    fromEffectBar.layer.masksToBounds = YES;
    fromEffectBar.alpha = self.navigationBar.effectBackground.alpha;
    [fromVC.view addSubview:fromEffectBar];
    [fromVC.view bringSubviewToFront:fromEffectBar];
    
    UIVisualEffectView *toEffectBar = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    toEffectBar.frame = fromEffectBar.frame;
    [toEffectBar addBottomCornerPath:12];
    toEffectBar.layer.masksToBounds = YES;
    toEffectBar.alpha = self.navigationBarAlpha;
    [toVC.view addSubview:toEffectBar];
    [toVC.view bringSubviewToFront:toEffectBar];
    
    self.navigationBar.effectBackground.hidden = YES;
    
    [self.topViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {

    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self updateNavigationBarAppearance];
        self.navigationBar.effectBackground.hidden = NO;
        [fromEffectBar removeFromSuperview];
        [toEffectBar removeFromSuperview];
        // 导航栏是否可以点击
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationBar.userInteractionEnabled = self.navigationBarUserInteractionEnabled;
        });
    }];
}

/// 使用视图控制器的转场动画协调器`transitionCoordinator`来设置导航栏转场动画
- (void)setNavigationBarAnimation {
    
    UIView *barBackgroundView = self.navigationBar.subviews.firstObject;
    
    UIVisualEffectView *tmpEffectBar = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    tmpEffectBar.frame = self.navigationBar.effectBackground.bounds;
    tmpEffectBar.alpha = self.navigationBarAlpha;
    [tmpEffectBar addBottomCornerPath:12];
    tmpEffectBar.layer.masksToBounds = YES;
    CGAffineTransform transformA = CGAffineTransformMakeTranslation(tmpEffectBar.frame.size.width, 0.0);
    CGAffineTransform transformB = CGAffineTransformMakeTranslation(-tmpEffectBar.frame.size.width , 0.0);
    
    if (self.isPush){
        tmpEffectBar.transform = transformA;
        [barBackgroundView insertSubview:tmpEffectBar aboveSubview:self.navigationBar.effectBackground];
    }else{
        tmpEffectBar.transform = transformB;
        [barBackgroundView insertSubview:tmpEffectBar belowSubview:self.navigationBar.effectBackground];
    }
    // 先更navbar tinkcolor
    [self.navigationBar setNavBarContentColor:self.navigationBarContentTinkcolor];
    [self.topViewController.transitionCoordinator animateAlongsideTransitionInView:barBackgroundView animation:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        tmpEffectBar.transform = CGAffineTransformIdentity;
        self.navigationBar.effectBackground.transform = self.isPush ? transformB : transformA;
//        // 先更navbar tinkcolor
//        [self.navigationBar setNavBarContentColor:self.navigationBarContentTinkcolor];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self updateNavigationBarAppearance];
        self.navigationBar.effectBackground.transform = CGAffineTransformIdentity;
        [tmpEffectBar removeFromSuperview];
        // 导航栏是否可以点击
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationBar.userInteractionEnabled = self.navigationBarUserInteractionEnabled;
        });
    }];
}

@end
