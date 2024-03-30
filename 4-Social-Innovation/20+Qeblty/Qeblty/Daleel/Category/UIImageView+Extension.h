//
//  UIImageView+Extension.h
//  Gamfun
//
//  Created by mac on 2022/6/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Extension)

/// yp - 加载图片 一般是固定占位图
- (void)loadImgUrl:(NSString *_Nullable)url;
/// yp - 加载图片 需要指定占位图
- (void)loadImgUrl:(NSString *_Nullable)url placeholderImg:(NSString *_Nullable)img;
/// 通过图片名称创建UIImageView
+ (instancetype)imgViewWithImg:(NSString *)imgName superView:(UIView *)sView;


@end

NS_ASSUME_NONNULL_END
