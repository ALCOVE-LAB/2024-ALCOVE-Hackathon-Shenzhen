//
//  BaseViewController.m
//  Daleel
//
//  Created by mac on 2022/11/22.
//

#import "BaseViewController.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) NSMutableArray <UIBarButtonItem *> *navRightBarBtnItems;

@end

@implementation BaseViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarBackgroundAlpha = 1; // 默认导航栏不透明
    self.navigationBarContentTinkcolor = [UIColor blackColor];// 默认黑色
    self.view.backgroundColor = kPublicBgColor;
    [self initialize];
    [self setupViews];
    [self bindSignal];
    [self requestData];
    [self fixTitle];
}

/// int
- (void)initialize {}
#pragma mark - UI
- (void)setupViews {}
///Rac 绑定信号
- (void)bindSignal {}
#pragma mark - Data
/// 网络请求
- (void)requestData {}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    if (self.isHideNav) {
        // 点击事件穿透 + 透明
        [self.navigationController setNavigationBarTouchEnabled:NO];
        self.navigationBarBackgroundAlpha = 0;
        self.navigationBarContentTinkcolor = [UIColor clearColor];
    } else {
        [self.navigationController setNavigationBarTouchEnabled:YES];
    }
    // 默认导航栏颜色
    [self.navigationController setNavigationBarBackgroundAlpha:self.navigationBarBackgroundAlpha];
    [self.navigationController setNavigationBarContentTinkColor:self.navigationBarContentTinkcolor];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    if (@available(iOS 13.0, *)) {
        
    } else {
        if(!parent) {
#warning            IOS 11 和 iOS12 bug 设置导航栏的颜色(tinkcolor)不能在viewwillappera里设置tinkcolor （或者说在pop后的动画前设置tinkcolor不会马上生效）此处处理
            NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
            index = index - 1;
            if (index < 0 || index > self.navigationController.viewControllers.count - 1) {index = 0;}
            // 上一个控制器 为了获取上一个控制器的 tinkcolor
            BaseViewController *lastVC = self.navigationController.viewControllers[index];
            [self.navigationController.navigationBar setNavBarContentColor:lastVC.navigationBarContentTinkcolor];
        }
    }
}

/// 设置导航栏返回大标题
- (void)setNavBackTitle:(NSString *)navBackTitle {
    _navBackTitle = navBackTitle;
    UIButton * navBackButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [navBackButton setTitle:navBackTitle forState:UIControlStateNormal];
    [navBackButton.titleLabel setFont:[UIFont boldSystemFontOfSize:22]];
    [navBackButton sizeToFit];
    navBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    navBackButton.userInteractionEnabled = NO;
    UIBarButtonItem *navBackT = [[UIBarButtonItem alloc] initWithCustomView:navBackButton];
    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.navigationItem.leftBarButtonItem =  navBackT;
}

- (UIButton *)setNavigationBackTitle:(NSString *)navBackTitle {
    _navBackTitle = navBackTitle;
    UIButton * navBackButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [navBackButton setTitle:navBackTitle forState:UIControlStateNormal];
    [navBackButton.titleLabel setFont:[UIFont boldSystemFontOfSize:22]];
    [navBackButton sizeToFit];
    navBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    navBackButton.userInteractionEnabled = NO;
    UIBarButtonItem *navBackT = [[UIBarButtonItem alloc] initWithCustomView:navBackButton];
    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.navigationItem.leftBarButtonItem =  navBackT;
    return navBackButton;
}
#pragma mark - 添加右侧按钮
- (UIButton *)addNavRightBarButtonWithImgName:(NSString * _Nullable)imgName title:(NSString *_Nullable)titleStr tapAction:(void (^)(void))clickBlock {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTapAction:clickBlock];
    rightBtn.frame = CGRectMake(0, 0, 24, 24);
    [rightBtn setTitleFont:kFontSemibold(16) titleColor:UIColor.blackColor];
    [rightBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateHighlighted];
    [rightBtn setTitle:titleStr forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navRightBarBtnItems addObject:item];
    self.navigationItem.rightBarButtonItems = self.navRightBarBtnItems;
    return rightBtn;
}

- (UIButton *)replaceNavBackActionWithAction:(void (^)(void))clickBlock {
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addTapAction:clickBlock];
    leftBtn.frame = CGRectMake(0, 0, 48, 40);
    [leftBtn setImage:[UIImage imageNamed:@"icon_back_b"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"icon_back_b"] forState:UIControlStateHighlighted];
    if(kIsAR){
        leftBtn.transform = CGAffineTransformRotate(leftBtn.transform, M_PI);
    }
    [leftBtn sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = item;
    return leftBtn;
}

- (void)closePopSlideGesture {
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
}

/// 添加中间的带点击事件的Title （UIButton）
- (UIButton *)addTitleButtonWithTitle:(NSString *)title tapAction:(void (^)(void))clickBlock {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor yellowColor];
    [button setTitle:title forState:(UIControlStateNormal)];
    [button setTitleFont:kFontSemibold(18) titleColor:UIColor.blackColor];
    [button addTapAction:clickBlock];
    [button sizeToFit];
    self.navigationItem.titleView = button;
    return button;
}

- (NSMutableArray<UIBarButtonItem *> *)navRightBarBtnItems {
    if(!_navRightBarBtnItems){
        _navRightBarBtnItems = [NSMutableArray arrayWithCapacity:0];
    }
    return _navRightBarBtnItems;
}

// 以 window.rootViewController -> nav -> tab -> viewControllers 方式创建tab的title不会自动赋值nav（nav全局一个）
-(void)fixTitle {
    // self.title设置了，不论在哪种控制器里面，都会优先显示self.title
    if (self.title) {
        self.navigationItem.title = self.title;
    }else{
        if (self.navigationItem.title) {
            self.navigationItem.title = self.navigationItem.title;
        }else{
            if (self.tabBarItem.title) {
                self.navigationItem.title = self.tabBarItem.title;
            }
        }
    }
}


@end
