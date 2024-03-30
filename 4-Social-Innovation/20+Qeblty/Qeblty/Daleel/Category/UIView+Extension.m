//
//  UIView+Extension.m
//  Gamfun
//
//  Created by mac on 2022/6/10.
//

#import "UIView+Extension.h"
#import <objc/runtime.h>


static char ClickBlockKey;

@implementation UIView (Extension)

/// 初始化View
/// @param superView 父视图
+ (instancetype)viewWithSuperView:(UIView *)superView {
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    [superView addSubview:view];
    return view;
}

#pragma mark - 添加tap点击方法
- (void)addTapAction:(void (^)(void))clickBlock {
    self.clickBlock = clickBlock;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)sender{
    if (self.clickBlock != nil) {
        self.clickBlock();
    }
}

- (void)setClickBlock:(void (^)(void))clickBlock {
    objc_setAssociatedObject(self, &ClickBlockKey, clickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))clickBlock {
    return objc_getAssociatedObject(self, &ClickBlockKey);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] || [NSStringFromClass([touch.view class]) isEqualToString:@"UICollectionViewCellContentView"] || [touch.view isKindOfClass:[UICollectionViewCell class]] || [touch.view isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    return YES;
}

/// yp - 缩放动画
- (void)addScaleAnimation {
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 1;
    animation.calculationMode = kCAAnimationCubic;
    [self.layer addAnimation:animation forKey:nil];
}

/// yp - 添加圆角
- (void)addCornerPath:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius,radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

/// yp - 添加上面的圆角
- (void)addTopCornerPath:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(radius,radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

/// yp - 添加下面的圆角
- (void)addBottomCornerPath:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(radius,radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

/// yp - 添加圆形圆角
- (void)addCircleCornerPath {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(CGRectGetWidth(self.bounds)/2,CGRectGetHeight(self.bounds)/2)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

/// yp - 添加右边的圆角
- (void)addLeftCornerPath:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(radius,radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

/// yp - 添加左边的圆角
- (void)addRightCornerPath:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(radius,radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

/// 绘制倒角
/// @param cornerRadius  圆角大小
/// @param size 所设置圆角view的大小
/// @param corner 圆角方向
- (void)drawCornerRadius:(CGFloat)cornerRadius withSize:(CGSize)size cornerType:(UIRectCorner)corner {
    CGSize cornerSize = CGSizeMake(cornerRadius, cornerRadius);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:corner
                                                         cornerRadii:cornerSize];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    [self.layer setMasksToBounds:YES];
}

/// 设置虚线
- (void)drawLineWithlineSpacing:(int)lineSpacing lineLength:(float)lineLength lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    if (isHorizonal) {
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame))];
    }else {
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame)/2)];
    }
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    if (isHorizonal) {
        [shapeLayer setLineWidth:CGRectGetHeight(self.frame)];
    }else {
        [shapeLayer setLineWidth:CGRectGetWidth(self.frame)];
    }
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    
    if (isHorizonal) {
        CGPathAddLineToPoint(path, NULL,CGRectGetWidth(self.frame), 0);
    } else {
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(self.frame));
    }
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [self.layer addSublayer:shapeLayer];
    // 防止设置的虚线超出frame
    self.layer.masksToBounds = YES;
}

- (void)setChangeWidth:(CGFloat)changeWidth {
    CGRect frame = self.frame;
    frame.size.height = changeWidth;
    self.frame = frame;
}

- (CGFloat)changeWidth {
    return self.frame.size.width;
}

- (void)setChangeHeight:(CGFloat)changeHeight {
    CGRect frame = self.frame;
    frame.size.height = changeHeight;
    self.frame = frame;
}

- (CGFloat)changeHeight {
    return self.frame.size.height;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setX:(CGFloat)x {
    CGRect newFrame = self.frame;
    newFrame.origin.x = x;
    self.frame = newFrame;
}

- (void)setY:(CGFloat)y {
    CGRect newFrame = self.frame;
    newFrame.origin.y = y;
    self.frame = newFrame;
}

- (CGSize)size {
    return self.frame.size;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)aPoint {
    CGRect newframe = self.frame;
    newframe.origin = aPoint;
    self.frame = newframe;
}

- (void)setSize:(CGSize)aSize {
    CGRect newframe = self.frame;
    newframe.size = aSize;
    self.frame = newframe;
}

- (CGPoint)bottomRight {
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint)bottomLeft {
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint)topRight {
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}

- (void)setHeight:(CGFloat)newheight {
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)newwidth {
    CGRect newframe = self.frame;
    newframe.size.width = newwidth;
    self.frame = newframe;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)newtop {
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)newleft {
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)newbottom {
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)newright {
    CGRect frame = self.frame;
    frame.origin.x = newright - frame.size.width;
    self.frame = frame;
}

- (CGFloat)centetX {
    return self.center.x;
}

- (void)setCentetX:(CGFloat)centetX {
    CGPoint center = self.center;
    center.x = centetX;
    self.center = center;
}

- (CGFloat)centetY {
    return self.center.y;
}

- (void)setCentetY:(CGFloat)centetY {
    CGPoint center = self.center;
    center.y = centetY;
    self.center = center;
}

- (CGFloat)getMinY {
    return CGRectGetMinY(self.frame);
}

- (CGFloat)getMidY {
    return CGRectGetMidY(self.frame);
}

- (CGFloat)getMaxY {
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)getMinX {
    return CGRectGetMinX(self.frame);
}

- (CGFloat)getMidX {
    return CGRectGetMidX(self.frame);
}

- (CGFloat)getMaxX {
    return CGRectGetMaxX(self.frame);
}

// label宽 高度自适应
-(CGSize )automaticallyAdaptToHighly:(UIFont *)font targetString:(NSString *)targetStr{
    //自适应宽高
    CGSize MaxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    // 表示字体的字典
    NSDictionary *attr = @{NSFontAttributeName : font};
    // 计算后的昵称文字尺寸
    CGSize LabelSize = [targetStr boundingRectWithSize:MaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    return LabelSize;
}

@end
