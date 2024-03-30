//
//  ProgressHUD.m
//  Gamfun
//
//  Created by mac on 2022/7/14.
//

#import "ProgressHUD.h"

@implementation ProgressHUD

+ (MBProgressHUD *)showHudInView:(UIView *_Nullable)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    return hud;
}

+ (void)hideHUDForView:(UIView *_Nullable)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD hideHUDForView:view animated:YES];
}

+ (void)hideHUD:(UIView *_Nullable)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD hideHUDForView:view animated:NO];
}

+ (void)hideHUD {
    [self hideHUDForView:nil];
}

#pragma mark 显示帧动画加载
+ (MBProgressHUD *)showAniHudInView:(UIView * _Nullable)view {
    if (view == nil) view = [UIApplication sharedApplication].delegate.window;
    UIImageView *imageVIew =  [[UIImageView alloc] init];
    NSMutableArray *imageArr = [NSMutableArray array];
    for (int i = 0;i < 19;i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%d.png",i]];
        [imageArr addObject:image];
    }
    imageVIew.animationImages = imageArr;
    imageVIew.animationDuration = 1.f;
    imageVIew.animationRepeatCount = 0;
    [imageVIew startAnimating];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = imageVIew;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor clearColor];
    hud.margin = 0.f;
    return hud;
}

@end
