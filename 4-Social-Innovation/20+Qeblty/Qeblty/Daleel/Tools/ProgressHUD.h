//
//  ProgressHUD.h
//  Gamfun
//
//  Created by mac on 2022/7/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProgressHUD : NSObject

+ (MBProgressHUD *)showHudInView:(UIView *_Nullable)view;
/// 正常带动画隐藏
+ (void)hideHUDForView:(UIView *_Nullable)view;
/// 不带动画的隐藏，主要是因布局问题而导致tableview的上拉加载更多时hud位置会变化
+ (void)hideHUD:(UIView *_Nullable)view;
+ (void)hideHUD;
/// 显示帧动画加载
+ (MBProgressHUD *)showAniHudInView:(UIView * _Nullable)view;

@end

NS_ASSUME_NONNULL_END
