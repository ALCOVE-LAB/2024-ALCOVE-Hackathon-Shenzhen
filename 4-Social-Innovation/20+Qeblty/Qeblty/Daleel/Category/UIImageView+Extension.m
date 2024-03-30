//
//  UIImageView+Extension.m
//  Gamfun
//
//  Created by mac on 2022/6/10.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)

/// yp - 加载带占位图的头像
- (void)loadImgUrl:(NSString *_Nullable)url {
    [self loadImgUrl:url placeholderImg:@"avatar_default"];
}

/// yp - 加载图片 需要指定占位图
- (void)loadImgUrl:(NSString *_Nullable)url placeholderImg:(NSString *_Nullable)img {
    if (!url || url.length == 0) {
        if (img) {
            self.image = [UIImage imageNamed:img];
        }
        return;
    }
    if (img) {
        [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:img]];
    }else {
        [self sd_setImageWithURL:[NSURL URLWithString:url]];
    }
}

/// 通过图片名称创建UIImageView
+ (instancetype)imgViewWithImg:(NSString *)imgName superView:(UIView *)sView {
    UIImageView * img = [UIImageView new];
    img.userInteractionEnabled = YES;
    if (imgName && imgName!=nil && ![imgName isEqual:@""]) {
        [img setImage:[UIImage imageNamed:imgName]];
    }
    [sView addSubview:img];
    return img;
}

@end
