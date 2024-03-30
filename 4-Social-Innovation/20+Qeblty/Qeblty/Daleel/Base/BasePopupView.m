//
//  PopViewForBase.m
//  
//
//  Created by czh on 2020/12/23.
//  
//

#import "BasePopupView.h"

@interface BasePopupView ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIVisualEffectView *bluerView;

@end

@implementation BasePopupView

- (void)setupViews {
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self setupPopupContentView];
}

- (void)setFrame:(CGRect)frame {
    //只有全屏  禁止修改frame
    [super setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
}

+ (instancetype)creatPopupView {
    return [[self alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
}

+ (void)dismiss {
    // 移除最上面的控制上pop
    for (UIView *subview in [self topViewController].view.subviews) {
        if ([subview isKindOfClass:BasePopupView.class]) {
            BasePopupView *temView = (BasePopupView *)subview;
            if (temView.closeBlock) {
                temView.closeBlock();
            }
            [temView removeFromSuperview];
        }
    }
    // 移除keyWindow最上面的控制上pop
    for (UIView *subview in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([subview isKindOfClass:BasePopupView.class]) {
            BasePopupView *temView = (BasePopupView *)subview;
            if (temView.closeBlock) {
                temView.closeBlock();
            }
            [temView removeFromSuperview];
        }
    }
}

+ (void)dismiss:(Class)class {
    // 移除最上面的控制上pop
    for (UIView *subview in [self topViewController].view.subviews) {
        if ([subview isMemberOfClass:class]) {
            BasePopupView *temView = (BasePopupView *)subview;
            if (temView.closeBlock) {
                temView.closeBlock();
            }
            [temView removeFromSuperview];
        }
    }
    // 移除nav 上的pop
    for (UIView *subview in [self topViewController].navigationController.view.subviews) {
        if ([subview isMemberOfClass:class]) {
            BasePopupView *temView = (BasePopupView *)subview;
            if (temView.closeBlock) {
                temView.closeBlock();
            }
            [temView removeFromSuperview];
        }
    }
    // 移除keyWindow最上面的控制上pop
    for (UIView *subview in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([subview isMemberOfClass:class]) {
            BasePopupView *temView = (BasePopupView *)subview;
            if (temView.closeBlock) {
                temView.closeBlock();
            }
            [temView removeFromSuperview];
        }
    }
}

- (void)setBackgroundEffect:(PopupViewBgEffectStyle)style {
    _backgroundEffect = style;
    switch (style) {
        case PopupViewBgEffectStyle_dark:
        {
            UIBlurEffect *bulerEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            UIVisualEffectView *bluerView = [[UIVisualEffectView alloc] initWithEffect:bulerEffect];
            bluerView.frame = self.bounds;
            [self insertSubview:bluerView belowSubview:self.popupContentView];
            _bluerView = bluerView;
        }
            break;
        case PopupViewBgEffectStyle_light:
        {
            UIBlurEffect *bulerEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            UIVisualEffectView *bluerView = [[UIVisualEffectView alloc] initWithEffect:bulerEffect];
            bluerView.frame = self.bounds;
            [self insertSubview:bluerView belowSubview:self.popupContentView];
            _bluerView = bluerView;
        }
            break;
        case PopupViewBgEffectStyle_cleanDark:
        {
            [_bluerView removeFromSuperview];
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        }
            break;
        case PopupViewBgEffectStyle_cleanLight:
        {
            [_bluerView removeFromSuperview];
            self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        }
            break;
        case PopupViewBgEffectStyle_clean:
        {
            [_bluerView removeFromSuperview];
            self.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)showToSuperView:(UIView *)superView {
    [self showToSuperView:superView animationStyle:PopupViewAnimateStyle_none];
}

- (void)showToSuperView:(UIView *)superView animationStyle:(PopupViewAnimateStyle)style {
    //self.contentView 没有在self上 添加没有意义了
    if(!self.popupContentView.superview){
        [self removeFromSuperview];
        DLog(@"弹窗设置出错！！ 请用使用“-(void)setupPopupContentView”");
        return;
    }
    
    if (self.superview == superView) {[self removeFromSuperview];}
    
    [superView addSubview:self];
    
    if (style == PopupViewAnimateStyle_zoom) {
        CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scale.values = @[@0.1 ,@0.6, @1.0];
        scale.duration = 0.2;
        [self.popupContentView.layer addAnimation:scale forKey:nil];
    }else if (style == PopupViewAnimateStyle_bottomToTop){
        self.popupContentView.transform = CGAffineTransformMakeTranslation(0, kScreenHeight);
        [UIView animateWithDuration:0.3 animations:^{
            self.popupContentView.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    }
}

- (void)close {
    [self removeFromSuperview];
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void)closeAction {
    if (self.onBlankClose) {
        [self removeFromSuperview];
        if (self.closeBlock) {
            self.closeBlock();
        }
    }
}

- (void)setupPopupContentView {
    self.backgroundColor = [UIColor clearColor];
    //添加执行动画view
    UIView *contentView = [[UIView alloc] initWithFrame:self.bounds];
    contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:contentView];
    self.popupContentView = contentView;
    
    //添加关闭tap事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

#pragma mark --- UIGestureRecognizerDelegate
//禁止点击到contentView的子视图上响应tap

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self.popupContentView];
    for (UIView *subView in [self.popupContentView subviews]) {
        CGPoint coverPoint = [subView convertPoint:point fromView:self.popupContentView];
        if (CGRectContainsPoint(subView.bounds, coverPoint)) {
            return NO;
        }
    }
    return YES;
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//}

// 不需要调整 hittest
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    // 如果交互未打开，或者透明度小于0.05 或者 视图被隐藏
////    if (self.userInteractionEnabled == NO || self.alpha < 0.05 || self.hidden == YES)
////    {
////        return nil;
////    }
//    if ([self pointInside:point withEvent:event]) {
//        NSInteger count = self.subviews.count;
//        for (int i = 0; i < count; i++) {
//            UIView *subView = self.subviews[count - 1 - i];
//            CGPoint coverPoint = [subView convertPoint:point fromView:self];
//
//            // 判断点击是否在 popupContentView 的子类上 如果在的话要子类响应点击
//            BOOL isTapOnContentViewSubView = NO;
//            for (UIView *subView in [self.popupContentView subviews]) {
//                CGPoint coverPoint = [subView convertPoint:point fromView:self.popupContentView];
//                if (CGRectContainsPoint(subView.bounds, coverPoint)) {
//                    isTapOnContentViewSubView = YES;
//                }
//            }
//            // self的subview如果是contentView，并且点击还不在contentView的子类上则返回 contentview
//            if(subView == self.popupContentView){
//                if(!isTapOnContentViewSubView){
//                    return subView; // contentview
//                }else{
//                    UIView *hitTestView = [subView hitTest:coverPoint withEvent:event];
//                    if (hitTestView) {
//                        if (hitTestView != self.popupContentView) {
//                            return hitTestView;
//                        }
//                    }
//                }
//            }
//
//        }
//        return self.popupContentView;
//    }
//    return nil;
//}

#pragma mark - overwrite

//- (void)willMoveToSuperview:(UIView *)newSuperview {
//    [super willMoveToSuperview:newSuperview];
//    if (self.superview != newSuperview && newSuperview) {
//        // 添加到了父视图上了
//    }
//}

- (void)willRemoveSubview:(UIView *)subview {
    [super willRemoveSubview:subview];
    // 移除contentView 则关闭
    if (subview == self.popupContentView) {
        [self removeFromSuperview];
        if (self.closeBlock) {
            self.closeBlock();
        }
    }
}

#pragma mark ---- tools

+ (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

- (void)dealloc {
    DLog(@"dealloc - BasePopView");
}

@end
