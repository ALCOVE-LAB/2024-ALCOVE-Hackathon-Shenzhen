//
//  UIImage+Extension.h
//  Gamfun
//
//  Created by mac on 2022/9/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extension)

- (UIImage *)yp_imageFlippedForRightToLeftLayoutDirection;

/// 图片裁减
- (UIImage *)croppedImageAtFrame:(CGRect)frame;

// 通过颜色绘制图片
+ (UIImage *)imageFromColor:(UIColor*)color size:(CGSize)size;

/// 重新绘制图片 eg:nav返回按钮图标位置调整
/// - Parameters:
///   - image: 重新绘制的图片
///   - size: 绘制后的图片大小
///   - imgPoint: 绘制image的起始位置
+ (UIImage *)redrawImageWithImage:(UIImage *)image size:(CGSize)size imgPoint:(CGPoint)imgPoint;

/// 根据url生成二维码
/// - Parameter url: url
+ (UIImage *)setupQRCodeImage:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
