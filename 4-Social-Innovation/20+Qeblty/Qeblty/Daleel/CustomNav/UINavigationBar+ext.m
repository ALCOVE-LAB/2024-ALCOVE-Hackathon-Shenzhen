//
//  UINavigationBar+ext.m
//  Daleel
//
//  Created by mac on 2023/5/23.
//

#import "UINavigationBar+ext.h"
#import <objc/runtime.h>

@implementation UINavigationBar (ext)

static char navBarBgKey;

#pragma mark - property getter setter
- (UIImageView *)effectBackground {
    return objc_getAssociatedObject(self, &navBarBgKey);
}

- (void)setEffectBackground:(UIImageView *)effectBackground {
    objc_setAssociatedObject(self, &navBarBgKey, effectBackground, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - public

- (void)setNavBarBackgroundAlpha:(float)alpha {
    if (!self.effectBackground) {
        [self addNavigationBarEffectBackground];
    }
    self.effectBackground.alpha = alpha;
}

- (void)setNavBarContentColor:(UIColor *)color {
    self.tintColor = color;
    if (@available(iOS 13.0, *)) {
        self.scrollEdgeAppearance.titleTextAttributes = @{NSForegroundColorAttributeName : color};
        self.standardAppearance.titleTextAttributes = @{NSForegroundColorAttributeName : color};
    } else {
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName : color}];
        [self setLargeTitleTextAttributes:@{NSForegroundColorAttributeName : color}];
    }
}

/// 给navbar添加背景图
- (UIVisualEffectView *)addNavigationBarEffectBackground {
    if (!self.effectBackground) {
        if (@available(iOS 13.0, *)) {
            UIView *barBackgroundView = self.subviews.firstObject;
            barBackgroundView.backgroundColor = [UIColor clearColor];
            // 插入背景View
            self.effectBackground = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
            self.effectBackground.frame = barBackgroundView.bounds;
            self.effectBackground.layer.masksToBounds = YES;
            self.effectBackground.transform = CGAffineTransformIdentity;
            self.effectBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [self.effectBackground drawCornerRadius:12 withSize:CGSizeMake(kScreenWidth, kHeight_NavBar) cornerType:UIRectCornerBottomLeft|UIRectCornerBottomRight];
            [barBackgroundView addSubview:self.effectBackground];
            //设置默认导航栏透明
            [self.standardAppearance configureWithOpaqueBackground];
            [self.standardAppearance setBackgroundEffect:nil];
            [self.standardAppearance setBackgroundColor:[UIColor clearColor]];
            [self.standardAppearance setShadowColor:[UIColor clearColor]];
        } else {
            UIView *barBackgroundView = self.subviews.firstObject;
            barBackgroundView.backgroundColor = [UIColor clearColor];
            //设置默认导航栏透明
            [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            [self setShadowImage:[UIImage new]];
            // 插入背景View
            self.effectBackground = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
            self.effectBackground.frame = barBackgroundView.bounds;
            self.effectBackground.layer.masksToBounds = YES;
            self.effectBackground.transform = CGAffineTransformIdentity;
            self.effectBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [self.effectBackground drawCornerRadius:12 withSize:CGSizeMake(kScreenWidth, kHeight_NavBar) cornerType:UIRectCornerBottomLeft|UIRectCornerBottomRight];
            [barBackgroundView insertSubview:self.effectBackground atIndex:0];
        }
    }
    return self.effectBackground;
}



@end
