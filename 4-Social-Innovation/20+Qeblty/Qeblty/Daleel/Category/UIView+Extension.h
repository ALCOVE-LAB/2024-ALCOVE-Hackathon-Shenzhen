//
//  UIView+Extension.h
//  Gamfun
//
//  Created by mac on 2022/6/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Extension)<UIGestureRecognizerDelegate>

@property (nonatomic,copy) void (^clickBlock)(void);

/// 初始化View
/// @param superView 父视图
+ (instancetype)viewWithSuperView:(UIView *)superView;

/// yp - 视图添加手势，block点击方法
- (void)addTapAction:(void (^)(void))clickBlock;

/// yp - 缩放动画
- (void)addScaleAnimation;

/// yp - 添加圆角
- (void)addCornerPath:(CGFloat)radius;

/// yp - 添加上面的圆角 - 其实就是圆形
- (void)addTopCornerPath:(CGFloat)radius;

/// yp - 添加下面的圆角
- (void)addBottomCornerPath:(CGFloat)radius;

/// yp - 添加圆形圆角
- (void)addCircleCornerPath;

/// yp - 添加右边的圆角
- (void)addLeftCornerPath:(CGFloat)radius;

/// yp - 添加左边的圆角
- (void)addRightCornerPath:(CGFloat)radius;

/// 绘制倒角 （自由设置角角）
/// @param cornerRadius  圆角大小
/// @param size 所设置圆角view的大小
/// @param corner 圆角方向
- (void)drawCornerRadius:(CGFloat)cornerRadius withSize:(CGSize)size cornerType:(UIRectCorner)corner;

///  通过 CAShapeLayer 方式绘制虚线 提前设置好frame
///  不确定width height 可以设置成屏幕宽or高 再次masonry布局会切割成masonry的大小
/// @param lineSpacing  间隔长度
/// @param lineLength 单个线长
/// @param lineColor 颜色
/// @param isHorizonal 是否横向
- (void)drawLineWithlineSpacing:(int)lineSpacing lineLength:(float)lineLength lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal;

- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)width;
- (CGFloat)height;

- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;

@property (nonatomic, assign) CGFloat changeWidth;
@property (nonatomic, assign) CGFloat changeHeight;

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property CGSize size;
@property CGPoint origin;
@property CGFloat height;
@property CGFloat width;
@property CGFloat top;
@property CGFloat left;
@property CGFloat bottom;
@property CGFloat right;

@property (nonatomic, assign, readonly, getter=getMinY) CGFloat minY;

@property (nonatomic, assign, readonly, getter=getMidY) CGFloat midY;

@property (nonatomic, assign, readonly, getter=getMaxY) CGFloat maxY;

@property (nonatomic, assign, readonly, getter=getMinX) CGFloat minX;

@property (nonatomic, assign, readonly, getter=getMidX) CGFloat midX;

@property (nonatomic, assign, readonly, getter=getMaxX) CGFloat maxX;


// label宽 高度自适应
-(CGSize )automaticallyAdaptToHighly:(UIFont *)font targetString:(NSString *)targetStr;

@end

NS_ASSUME_NONNULL_END
