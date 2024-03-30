//
//  PopViewForBase.h
//  Gamfun
//
//  Created by czh on 2020/12/23.
//  
//

/**
 复杂的UI的弹窗 基类
 此基类实现了 自定义设置弹窗后背景颜色 显示特效 点击空白处关闭弹窗 关闭 添加 关闭回调
 自定义的复杂UI  1.在子类里重写 -(void)setupPopContentView方法  2.在重写方法里写复杂UI  3.复杂UI要统一写在self.contentView上
 */

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PopupViewBgEffectStyle) {
    PopupViewBgEffectStyle_clean = 0, // 透明背景
    PopupViewBgEffectStyle_light, // 白色UIBlurEffectStyleLight背景
    PopupViewBgEffectStyle_dark, // 黑色UIBlurEffectStyleDark
    PopupViewBgEffectStyle_cleanLight, // 半透明白色
    PopupViewBgEffectStyle_cleanDark, // 半透明黑色
};

typedef NS_ENUM(NSUInteger, PopupViewAnimateStyle) {
    PopupViewAnimateStyle_none = 0, // 默认没有特效
    PopupViewAnimateStyle_bottomToTop, // 由下自上特效
    PopupViewAnimateStyle_zoom, // 缩放特效
};

@interface BasePopupView : BaseView

// ----- 自定义花里胡哨弹窗 重写下面
/// popView 所有views放在此View上 大小全屏 （在非全屏控制器内 请放到window上）
@property (nonatomic,strong) UIView *popupContentView;

/// 给子类重写用 UI写在此方法里  在contentView上添加UI
- (void)setupPopupContentView;


/// 关闭回调
@property (nonatomic,copy) void(^closeBlock)(void);

/// 点击空白处关闭弹窗 默认NO 不关闭
@property (nonatomic,assign) BOOL onBlankClose;

/// 设置背景透明效果  默认 PopViewBgEffectStyle_clean 纯透明
@property (nonatomic,assign) PopupViewBgEffectStyle backgroundEffect;

/// 创建全屏弹窗
+ (instancetype)creatPopupView;

/// 移除当前VC所有以PopViewForBase为基类的popview 
+ (void)dismiss;

/// 移除某一类的所有弹窗
+ (void)dismiss:(Class)class;

/// 显示到到父view
- (void)showToSuperView:(UIView *)superView;

/// 显示到到父view 可以设置动画带动画
- (void)showToSuperView:(UIView *)superView animationStyle:(PopupViewAnimateStyle)style;

/// 关闭
- (void)close;

@end

NS_ASSUME_NONNULL_END
