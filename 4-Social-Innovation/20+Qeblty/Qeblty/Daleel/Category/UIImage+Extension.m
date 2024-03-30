//
//  UIImage+Extension.m
//  Gamfun
//
//  Created by mac on 2022/9/30.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

- (UIImage *)yp_imageFlippedForRightToLeftLayoutDirection {
    if (kIsAR) {
        return [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationUpMirrored];
    }
    return self;
}

/// 图片裁减
- (UIImage *)croppedImageAtFrame:(CGRect)frame {
    frame = CGRectMake(frame.origin.x * self.scale, frame.origin.y * self.scale, frame.size.width * self.scale, frame.size.height * self.scale);
    CGImageRef sourceImageRef = [self CGImage];
    CGImageRef newImageRef    = CGImageCreateWithImageInRect(sourceImageRef, frame);
    UIImage   *newImage       = [UIImage imageWithCGImage:newImageRef scale:[self scale] orientation:[self imageOrientation]];
    CGImageRelease(newImageRef);
    return newImage;
}

+ (UIImage *)imageFromColor:(UIColor*)color size:(CGSize)size {
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width,size.height);
    UIGraphicsBeginImageContext(size);//创建图片
    CGContextRef context = UIGraphicsGetCurrentContext();//创建图片上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);//设置当前填充颜色的图形上下文
    CGContextFillRect(context, rect);//填充颜色
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)redrawImageWithImage:(UIImage *)image size:(CGSize)size imgPoint:(CGPoint)imgPoint {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawAtPoint:imgPoint];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}

/// 根据url生成二维码
/// - Parameter url: url
+ (UIImage *)setupQRCodeImage:(NSString *)url
{
    NSData *data = [url dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *image = filter.outputImage;
    
    // 直接赋值生成 UIImage，会模糊
    //_QRCodeImageView.image = [UIImage imageWithCIImage:image];
    
    // 重新绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:image fromRect:image.extent];
    UIGraphicsBeginImageContext(CGSizeMake(kScreenWidth, kScreenWidth));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    
    //
    UIImage *QRCodeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return QRCodeImage;
}

@end
