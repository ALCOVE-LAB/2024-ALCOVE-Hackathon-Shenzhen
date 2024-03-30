//
//  CompassView.h
//  Daleel
//
//  Created by mac on 2024/3/31.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompassView : BaseView


/// 初始化
/// - Parameters:
///   - frame: frame
///   - configColorDic: 颜色配置
 /**
@"longScaleColor":长刻度线颜色(30度一个)
@"midScaleColor":中长度刻度线颜色(10度一个)
@"shortScaleColor":短刻度线颜色(2度一个)
@"degreeTextColor":数字刻度文字颜色
@"directionTextColot":东南西北文字颜色
*/
- (instancetype)initWithFrame:(CGRect)frame configColor:(NSDictionary *)configColorDic;

@property (nonatomic,copy) void(^compassBlock)(float angle);

/// 挂起
- (void)setOnPause;

/// 继续
- (void)setOnResume;

@end

NS_ASSUME_NONNULL_END
