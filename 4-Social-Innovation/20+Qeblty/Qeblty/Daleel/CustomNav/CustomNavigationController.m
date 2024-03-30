//
//  CustomNavigationController.m
//  NavThings
//
//  Created by mac on 2023/5/24.
//

#import "CustomNavigationController.h"

// nav字体颜色
#define DefaultNavigationBarTinkColor [UIColor blackColor]
// nav title颜色
#define DefaultNavigationBarTitleColor [UIColor blackColor]
// nav title字体大小
#define DefaultNavigationBarTitleFont 18

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

+ (void)initialize {
    [super initialize];
    
//    NSDictionary *dic = @{NSForegroundColorAttributeName : DefaultNavigationBarTitleColor,
//                              NSFontAttributeName : [UIFont systemFontOfSize:DefaultNavigationBarTitleFont weight:UIFontWeightMedium]};
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    //设置透明 布局原点为*屏幕*左上角 手动设置navigationBar颜色
    navigationBar.translucent = YES;
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *barApp = [UINavigationBarAppearance new];
        // 全设置透明
        barApp.backgroundColor = [UIColor clearColor];
        barApp.backgroundEffect = nil;
        barApp.shadowColor = [UIColor clearColor];
        // 在设置默认颜色
//        barApp.backgroundColor = DefaultNavigationBarBgColor;
        // title颜色
//        barApp.titleTextAttributes = dic;
        // 返回按钮调整
        UIImage *backOrgImg = [UIImage imageNamed:@"icon_back_b"];
//        // 调整图标位置
        UIImage *backImg = [[CustomNavigationController redrawImageWithImage:backOrgImg size:CGSizeMake(backOrgImg.size.width + 5, backOrgImg.size.height) imgPoint:CGPointMake(5, 0)] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [barApp setBackIndicatorImage:backImg transitionMaskImage:backImg];
//        // 设置 调整返回按钮 返回title间距
//        UIBarButtonItemAppearance *barButtonAppearance = [[UIBarButtonItemAppearance alloc] initWithStyle:UIBarButtonItemStylePlain];
//        [barButtonAppearance.normal setTitlePositionAdjustment:UIOffsetMake(10, 2)];
//        [barApp setBackButtonAppearance:barButtonAppearance];
        
        navigationBar.scrollEdgeAppearance = barApp;
        navigationBar.standardAppearance = barApp;
    }else{
        //title颜色
//        navigationBar.titleTextAttributes = dic;
        // 在设置默认颜色
//        UIImage *img = [UIImage new];
//        [navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
//        [navigationBar setShadowImage:img];
        // 调整返回按钮 返回title间距
//        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(10, 1)  forBarMetrics:UIBarMetricsDefault];
        // 设置返回按钮
        UIImage *backOrgImg = [UIImage imageNamed:@"icon_back_b"];
        // 调整图标位置
        UIImage *backImg = [[CustomNavigationController redrawImageWithImage:backOrgImg size:CGSizeMake(backOrgImg.size.width + 5, backOrgImg.size.height) imgPoint:CGPointMake(5, 0)] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        navigationBar.backIndicatorImage = [backImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        navigationBar.backIndicatorTransitionMaskImage = [backImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    //navigation控件颜色
    navigationBar.tintColor = DefaultNavigationBarTinkColor;
}

//+ (UIImage *)imageFromColor:(UIColor*)color size:(CGSize)size {
//    CGRect rect=CGRectMake(0.0f, 0.0f, size.width,size.height);
//    UIGraphicsBeginImageContext(size);//创建图片
//    CGContextRef context = UIGraphicsGetCurrentContext();//创建图片上下文
//    CGContextSetFillColorWithColor(context, [color CGColor]);//设置当前填充颜色的图形上下文
//    CGContextFillRect(context, rect);//填充颜色
//    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return theImage;
//}

+ (UIImage *)redrawImageWithImage:(UIImage *)image size:(CGSize)size imgPoint:(CGPoint)imgPoint {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawAtPoint:imgPoint];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}


//- (void)setNavBackTitle:(NSString *)navBackTitle {
//    if(self.viewControllers.count <= 0){return;}
//    NSInteger index = self.viewControllers.count - 2; //想要当前页面显示navBackTitle 则在willappear前设置前一个vc的backtitle显示
//    if(index < 0) {index = 0;}
//    UIViewController *vc = self.viewControllers[index];
//    NSDictionary *dic1 = @{NSForegroundColorAttributeName : DefaultNavigationBarBackItemTitleColor, NSFontAttributeName : [UIFont systemFontOfSize:DefaultNavigationBarBackItemTitleFont weight:UIFontWeightMedium]};
//    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
//    [backButtonItem setTitleTextAttributes:dic1 forState:UIControlStateNormal];
//    [backButtonItem setStyle:UIBarButtonItemStylePlain];
//    backButtonItem.title = navBackTitle;
//    vc.navigationItem.backBarButtonItem = backButtonItem;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
