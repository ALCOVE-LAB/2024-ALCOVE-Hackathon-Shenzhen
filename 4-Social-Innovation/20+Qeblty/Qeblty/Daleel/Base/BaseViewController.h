//
//  BaseViewController.h
//  Daleel
//
//  Created by mac on 2022/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

/// yp - init
- (void)initialize;
/// yp-   UI
- (void)setupViews;
/// yp-  Rac 绑定信号
- (void)bindSignal;
/// yp- 网络请求
- (void)requestData;


#pragma mark - 以下Nav相关 nav 隐藏 透明 返回按钮标题
/// 是否隐藏nav
@property (nonatomic,assign) BOOL isHideNav;
/// 导航栏透明度 默认1
@property (nonatomic,assign) float navigationBarBackgroundAlpha;
/// 导航栏文字 返回按钮  颜色  默认黑色
@property (nonatomic,strong) UIColor *navigationBarContentTinkcolor;
/// 返回按钮标题
@property (nonatomic,strong) NSString *navBackTitle;
/// 设置返回按钮大标题 (带返回值的)
- (UIButton *)setNavigationBackTitle:(NSString *)navBackTitle;

#pragma mark - 以下Nav添加按钮
/// 给nav添加右侧按钮
- (UIButton *)addNavRightBarButtonWithImgName:(NSString * _Nullable)imgName title:(NSString *_Nullable)titleStr tapAction:(void (^)(void))clickBlock;

/// 添加中间的带点击事件的Title （UIButton）
- (UIButton *)addTitleButtonWithTitle:(NSString *)title tapAction:(void (^)(void))clickBlock;

/// 给nav添加右侧按钮 会屏蔽掉原有的返回
- (UIButton *)replaceNavBackActionWithAction:(void (^)(void))clickBlock;

/// 关闭侧滑
- (void)closePopSlideGesture;

@end

NS_ASSUME_NONNULL_END
