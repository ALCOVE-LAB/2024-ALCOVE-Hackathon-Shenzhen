//
//  CompassView.m
//  Daleel
//
//  Created by mac on 2024/3/31.
//

#import "CompassView.h"
#import "LocationManager.h"
#import <AudioToolbox/AudioToolbox.h>
#include <math.h>

@interface CompassView ()<LocationManagerDelegate>
// 刻度 根据方向旋转
@property (nonatomic,strong) UIView *markedScaleView;
// 中间渐变色layer
@property (nonatomic,strong) CAGradientLayer *centerCircleGradientLayer;
// 指针图标
@property (nonatomic,strong) UIImageView *compassPointer;
// 天房图标
@property (nonatomic,strong) UIImageView *qiblaImgv;
// 天房位置
@property (nonatomic,assign) int kabaAngle;

@property (nonatomic,strong) NSDictionary *configColorDic;

@property (nonatomic,assign) BOOL isOnPause;

@end

@implementation CompassView

- (void)initialize {
    [super initialize];
    // 开始指北 权限外面设置的
    [[LocationManager sharedInstance] addDelegate:self];
    [[LocationManager sharedInstance] startUpdateHeading];
}

- (instancetype)initWithFrame:(CGRect)frame configColor:(NSDictionary *)configColorDic
{
    self = [super initWithFrame:frame];
    if (self) {
        self.configColorDic = configColorDic;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    //颜色配置处理
//    @"longScaleColor":长刻度线颜色(30度一个)
//    @"midScaleColor":中长度刻度线颜色(10度一个)
//    @"shortScaleColor":短刻度线颜色(2度一个)
//    @"degreeTextColor":数字刻度文字颜色
//    @"directionTextColor":东南西北文字颜色
    UIColor *longScaleColor = [self.configColorDic valueForKey:@"longScaleColor"] ? [self.configColorDic valueForKey:@"longScaleColor"] : [UIColor colorWithHexString:@"#1B1B1B"];
    UIColor *midScaleColor = [self.configColorDic valueForKey:@"midScaleColor"] ? [self.configColorDic valueForKey:@"midScaleColor"] : [UIColor colorWithHexString:@"#1B1B1B"];
    UIColor *shortScaleColor = [self.configColorDic valueForKey:@"shortScaleColor"] ? [self.configColorDic valueForKey:@"shortScaleColor"] : [UIColor colorWithHexString:@"#8A8A8A"];
    UIColor *degreeTextColor = [self.configColorDic valueForKey:@"degreeTextColor"] ? [self.configColorDic valueForKey:@"degreeTextColor"] : [UIColor colorWithHexString:@"#1B1B1B"];
    UIColor *directionTextColor = [self.configColorDic valueForKey:@"directionTextColor"] ? [self.configColorDic valueForKey:@"directionTextColor"] : [UIColor colorWithHexString:@"#1B1B1B"];
    
    // 缩放系数 (当前指南针 在首页和指南针页面CompassViewController 共用一个 以400为基数 根据当前view的大小去放大缩小)
    CGFloat viewScale = self.bounds.size.width / 400;
    /// 此角度存在正负
    float kabaAngle = (float)[self qiblaDirection];
    /// 处理角度  四舍五入 精度1     0 <= >self.kabaAngle < 360
    self.kabaAngle = [self fixAngle:(int)roundf(kabaAngle)];
    /// 东南西北文字数组
    NSArray *textArray = @[kLocalize(@"compass_n"),kLocalize(@"compass_e"),kLocalize(@"compass_s"),kLocalize(@"compass_w")];
    // 绘制刻度
    UIView *markedScaleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    _markedScaleView = markedScaleView;
    markedScaleView.backgroundColor = [UIColor clearColor];
    // 设置表盘中心
    markedScaleView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    [self addSubview:markedScaleView];
    // 1度
    CGFloat perAngle = M_PI * 2 / 360 ;
    // 小刻度线的宽度的一半 (实际是每个刻度是perWidthAngle * 2 角度的扇形)
    // 大刻度是小刻度的2倍
    CGFloat perWidthAngle = M_PI * 2 / 360 / 8;
    // 每2度一个刻线
    for (int i = 0; i < 360; i++) {
        // NSLog(@"%d",i);
       if(i % 30 == 0) {
           // 每30度 粗深色刻度线
            UIBezierPath *bPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(markedScaleView.bounds.size.width/2, markedScaleView.bounds.size.height/2) radius:135 * viewScale startAngle:perAngle * i - (perWidthAngle * 4) endAngle:perAngle * i + (perWidthAngle * 4) clockwise:YES];
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.strokeColor = longScaleColor.CGColor;
            shapeLayer.lineWidth = 25 * viewScale;
            shapeLayer.path = bPath.CGPath;
            shapeLayer.fillColor = [UIColor clearColor].CGColor;
            [markedScaleView.layer addSublayer:shapeLayer];
        }else if(i % 10 == 0) {
            // 每10度 深色刻度线
            UIBezierPath *bPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(markedScaleView.bounds.size.width/2, markedScaleView.bounds.size.height/2) radius:131 * viewScale startAngle:perAngle * i - (perWidthAngle * 2) endAngle:perAngle * i + (perWidthAngle * 2) clockwise:YES];
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.strokeColor = midScaleColor.CGColor;
            shapeLayer.lineWidth = 12 * viewScale;
            shapeLayer.path = bPath.CGPath;
            shapeLayer.fillColor = [UIColor clearColor].CGColor;
            [markedScaleView.layer addSublayer:shapeLayer];
        }else if (i % 2 == 0){
            // 每2度 刻度线
            UIBezierPath *bPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(markedScaleView.bounds.size.width/2, markedScaleView.bounds.size.height/2) radius:131 * viewScale startAngle:perAngle * i - (perWidthAngle * 2) endAngle:perAngle * i + (perWidthAngle * 2) clockwise:YES];
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.strokeColor = shortScaleColor.CGColor;
            shapeLayer.lineWidth = 12 * viewScale;
            shapeLayer.path = bPath.CGPath;
            shapeLayer.fillColor = [UIColor clearColor].CGColor;
            [markedScaleView.layer addSublayer:shapeLayer];
        }
       
        // 东西南北label 和 每90度一个度数label
        if(i % 90 == 0) {
            // 计算位置
            CGPoint markedScaleViewCenterPoint = CGPointMake(markedScaleView.bounds.size.width / 2, markedScaleView.bounds.size.height / 2);
            float tempAngle = perAngle *i;
            // 东南西北label
            CGFloat x = markedScaleViewCenterPoint.x + (kIsAR ? 82 * viewScale : 95 * viewScale) * cos(tempAngle);
            CGFloat y = markedScaleViewCenterPoint.x + (kIsAR ? 82 * viewScale : 95 * viewScale) * sin(tempAngle);
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x, y, 68 * viewScale, 20 * viewScale)];
            label.center = CGPointMake(x, y);
            label.text = textArray[i / 90];
            label.textColor = directionTextColor;
            label.font = [UIFont boldSystemFontOfSize:kIsAR ? 17 * viewScale : 21 *viewScale];
            label.textAlignment = NSTextAlignmentCenter;
            [markedScaleView addSubview:label];
            // 每90度 外部 label
            CGFloat x1 = markedScaleViewCenterPoint.x + 160 * viewScale * cos(tempAngle);
            CGFloat y1 = markedScaleViewCenterPoint.x + 160 * viewScale * sin(tempAngle);
            NSString *angleNumText = [NSString stringWithFormat:@"%d",[self fixAngle:i]];
            UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(x1, y1, 30 * viewScale, 20 * viewScale)];
            label2.center = CGPointMake(x1, y1);
            label2.text = angleNumText;
            label2.textColor = degreeTextColor;
            label2.font = [UIFont boldSystemFontOfSize:10 * viewScale];
            label2.textAlignment = NSTextAlignmentCenter;
            [markedScaleView addSubview:label2];
        }
        
        // 计算天房位置 绘制天房图标
        if (i % self.kabaAngle == 0 && !_qiblaImgv) {
            // 0 % x = 0
            if(i == 0 && self.kabaAngle > 0) {continue;}
            // prayer kabaAngle天房方向 小图标
            CGPoint markedScaleViewCenterPoint = CGPointMake(markedScaleView.bounds.size.width / 2, markedScaleView.bounds.size.height / 2);
            float tempAngle = perAngle *i;
            CGFloat x = markedScaleViewCenterPoint.x + 150 * viewScale * cos(tempAngle);
            CGFloat y = markedScaleViewCenterPoint.x + 150 * viewScale * sin(tempAngle);
            UIImageView *qiblaImgv = [UIImageView imgViewWithImg:@"prayer_qibla_icon" superView:markedScaleView];
            qiblaImgv.layer.zPosition = 999;
            qiblaImgv.frame = CGRectMake(0, 0, 81 * viewScale, 81 * viewScale);
            qiblaImgv.center = CGPointMake(x, y);
            qiblaImgv.layer.shadowColor = [UIColor colorWithRed:159/255.0 green:69/255.0 blue:69/255.0 alpha:0.2000].CGColor;
            qiblaImgv.layer.shadowOffset = CGSizeMake(0,0);
            qiblaImgv.layer.shadowOpacity = 1;
            qiblaImgv.layer.shadowRadius = 10;
            _qiblaImgv = qiblaImgv;
        }
    }
    
    // 绘制中间部分渐变色 圆形
    UIView *centerCircleGradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220 * viewScale, 220 * viewScale)];
    centerCircleGradientView.center = markedScaleView.center;
    centerCircleGradientView.backgroundColor = [UIColor whiteColor];
    [self insertSubview:centerCircleGradientView belowSubview:markedScaleView];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.type = kCAGradientLayerRadial;
    gradientLayer.frame = centerCircleGradientView.bounds;
    gradientLayer.startPoint = CGPointMake(0.5, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.colors = @[(id)[UIColor colorWithHexString:@"#FFFFFF" alpha:0].CGColor,(id)[UIColor colorWithHexString:@"#FFFFFF" alpha:0].CGColor,(id)[UIColor colorWithRed:159/255.0 green:69/255.0 blue:69/255.0 alpha:0.3000].CGColor];
    gradientLayer.cornerRadius = 110 * viewScale;
    [centerCircleGradientView.layer addSublayer:gradientLayer];
    centerCircleGradientView.layer.cornerRadius = 110 * viewScale;;
    centerCircleGradientView.layer.masksToBounds = YES;
    _centerCircleGradientLayer = gradientLayer;
    
    // 指南针指针图标
    UIImageView *compassPointer = [UIImageView imgViewWithImg:@"prayer_compass_pointer_other" superView:centerCircleGradientView];
    compassPointer.frame = CGRectMake(0, 0, 82 * viewScale, 123 * viewScale);
    compassPointer.center = CGPointMake(centerCircleGradientView.bounds.size.width / 2, centerCircleGradientView.bounds.size.height / 2 - (82 * viewScale / 2 / 2));
    _compassPointer = compassPointer;
}


#pragma mark - LocationManagerDelegate
- (void)locationManagerDidUpdateHeading:(CLHeading *)newHeading {
    if (self.isOnPause) {return;}
    if (newHeading.headingAccuracy > 0) {
        //(newHeading.magneticHeading + 90) 之所以+90 是因为 页面绘制是以手机水平右侧为0点 而magneticHeading 是以手机垂直上侧为0点
        CGFloat angle = -1 * floorf((newHeading.magneticHeading + 90) * M_PI / 180 * 100) / 100;
        ExecBlock(self.compassBlock,floorf(newHeading.magneticHeading));
        // 一下 调整角度 震动 变色 相关
        if(newHeading.magneticHeading > [self fixAngle:self.kabaAngle - 3] && newHeading.magneticHeading < [self fixAngle:self.kabaAngle + 3]) { // 正负3
            _centerCircleGradientLayer.colors = @[(id)[UIColor colorWithHexString:@"#FFFFFF" alpha:0].CGColor,(id)[UIColor colorWithHexString:@"#FFFFFF" alpha:0].CGColor,(id)[UIColor colorWithHexString:@"#65AD44" alpha:0.3000].CGColor];
            _compassPointer.image = [UIImage imageNamed:@"prayer_compass_pointer_60"];
            _qiblaImgv.layer.shadowColor = [UIColor colorWithHexString:@"#65AD44" alpha:0.2000].CGColor;
            // 震动
            if(newHeading.magneticHeading >= self.kabaAngle && newHeading.magneticHeading < self.kabaAngle + 0.9){
//                DLog(@"newHeading.magneticHeading - %f", newHeading.magneticHeading);
                AudioServicesPlaySystemSound(1520);
            }
        }else if (newHeading.magneticHeading > [self fixAngle:self.kabaAngle - 60] && newHeading.magneticHeading < [self fixAngle:self.kabaAngle + 60]){ //正负 60°
            _centerCircleGradientLayer.colors = @[(id)[UIColor colorWithHexString:@"#FFFFFF" alpha:0].CGColor,(id)[UIColor colorWithHexString:@"#FFFFFF" alpha:0].CGColor,(id)[UIColor colorWithRed:188/255.0 green:160/255.0 blue:37/255.0 alpha:0.3000].CGColor];
            _compassPointer.image = [UIImage imageNamed:@"prayer_compass_pointer_0"];
            _qiblaImgv.layer.shadowColor = [UIColor colorWithRed:188/255.0 green:160/255.0 blue:37/255.0 alpha:0.2000].CGColor;
        }else { //其他情况
            _centerCircleGradientLayer.colors = @[(id)[UIColor colorWithHexString:@"#FFFFFF" alpha:0].CGColor,(id)[UIColor colorWithHexString:@"#FFFFFF" alpha:0].CGColor,(id)[UIColor colorWithRed:159/255.0 green:69/255.0 blue:69/255.0 alpha:0.3000].CGColor];
            _compassPointer.image = [UIImage imageNamed:@"prayer_compass_pointer_other"];
            _qiblaImgv.layer.shadowColor = [UIColor colorWithRed:159/255.0 green:69/255.0 blue:69/255.0 alpha:0.2000].CGColor;
        }
        [self resetDirection:angle];
    }
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration {
    return YES;
}

#pragma mark - private
- (void)resetDirection:(CGFloat)headingAngle{
    [UIView animateWithDuration:0.1 animations:^{
        self.markedScaleView.transform = CGAffineTransformMakeRotation(headingAngle);
        for (UIView * v in self.markedScaleView.subviews) {
            v.transform = CGAffineTransformMakeRotation(-headingAngle);
        }
    }];
}

/// 修正角度(正负角度 修正为0～360度的角度) 精度1度
- (int)fixAngle:(int)angle {
    return (angle + 360) % 360;
}

/// 计算天房位置
- (double)qiblaDirection {
    // kaba 经纬度 固定的
    NSDictionary *kaba = @{@"lat":@"21.422522",@"lng":@"39.826181"};
    NSString *lat = [kUserDefaults valueForKey:kLocationLatitude];
    NSString *lng = [kUserDefaults valueForKey:kLocationlongitude];
    // 手机定位到的经纬度
    NSDictionary *location = @{@"lat":lat == nil ? @"21.422522" : lat,@"lng":lng == nil ? @"39.826181" : lng};
    
    double locationlLat1 = ([location[@"lat"] doubleValue] / 180) * M_PI;
    double kabaLat2      = ([kaba[@"lat"] doubleValue] / 180) * M_PI;
    double dlng          = ([kaba[@"lng"] doubleValue] - [location[@"lng"] doubleValue]) / 180 * M_PI;
    double angle         = atan2(sin(dlng),cos(locationlLat1) * tan(kabaLat2) - (sin(locationlLat1) * cos(dlng)));
    
    return (angle * 180) / M_PI;
}

- (void)setOnPause {
    self.isOnPause = YES;
}

- (void)setOnResume {
    self.isOnPause = NO;
}

// 以下计算偏角 目前用不上

//- (double)baseDirection:(double)angle {
//    return floor(((angle + 45) / 90)) * 90;
//}
//
//- (void)testCalculateAnge {
//    double angle = [self qiblaDirection];
//    double base = [self baseDirection:angle];
//    double diff = round(angle - base);
//
//    DLog(@"测试计算angle:%lf - base:%lf - diff:%lf", angle,base,diff);
//
//    NSArray *temStrArr = @[@"North",@"East",@"South",@"West"];
//
//    NSString *tempStr = temStrArr[(int)((base / 90 + 4) / 4)];
//
//    DLog(@"Qibla: %f degrees from %@ %@",diff,tempStr,diff >= 0 ? @"(clockwise)" : @"(counterclockwise)")
//}

@end
