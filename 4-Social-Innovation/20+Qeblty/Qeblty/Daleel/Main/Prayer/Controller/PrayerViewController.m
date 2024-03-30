//
//  PrayerViewController.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "PrayerViewController.h"
#import "PrayerView.h"
#import "PrayerLocationTipView.h"
#import "PrayerModel.h"
#import "CompassViewController.h"
#import "LocationManager.h"
#import "ProfileViewControllerV2.h"

@interface PrayerViewController ()

@property (nonatomic,strong)PrayerView *prayerView;
@property (nonatomic,strong)PrayerLocationTipView *locationTipView;
@property (nonatomic,strong)PrayerModel *prayerModel;

@property (nonatomic, strong) UIImageView *headView;


@end

@implementation PrayerViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (kUser.isLogin) {
        // 更新用户信息
        [kUser refreshUserInfoSuccess:nil failure:nil];
    }
}

- (void)initialize {
    @weakify(self);
    [[AccountManager sharedInstance] getAccountSate:^(AccountManagerState state) { // 获取当前登陆状态
        @strongify(self);
        if (state == AccountManagerState_GuestLogined) {
            [self.prayerView dl_getRequestWithLatitude:kLatitude ? kLatitude : @"24.7135517" andWithLongitude:kLongitudeStr ? kLongitudeStr : @"46.6752957" andWithCityName:kCityName ? kCityName : kLocalize(@"riyadh")];
        } else if (state == AccountManagerState_Logined){
            [self.prayerView removeTouristMessage];
        }
    } addListenerWithKey:@"PrayerViewController" listener:^(AccountManagerState state, id  _Nonnull msg) {// 监听当前登陆状态
        if (state == AccountManagerState_GuestLogined) {
            [self.prayerView dl_getRequestWithLatitude:kLatitude ? kLatitude : @"24.7135517" andWithLongitude:kLongitudeStr ? kLongitudeStr : @"46.6752957" andWithCityName:kCityName ? kCityName : kLocalize(@"riyadh")];
        } else if (state == AccountManagerState_Logined){
            [self.prayerView removeTouristMessage];
        } else if (state == AccountManagerState_UpdatedUserInfo) {
            if (kUser.userInfo.touristFlag != 1) {
                [self.headView loadImgUrl:kUser.userInfo.headUrl placeholderImg:@"prayer_left_nav_btn"];
            } else {
                self.headView.image = kImageName(@"avatar_logout_default");
            }
        }

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 导航栏透明
    self.navigationBarBackgroundAlpha = 0;
    // 导航栏tinkcolor
    self.navigationBarContentTinkcolor = [UIColor whiteColor];
    // 导航栏右侧按钮
    @weakify(self);
    [self addNavRightBarButtonWithImgName:@"prayer_qibla" title:nil tapAction:^{
        @strongify(self);
        CompassViewController *vc = [CompassViewController new];
        [self pushViewController:vc];
    }];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.leading.equalTo(self.view.mas_leading).offset(17);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
    }];
    
    UIImageView *headView = [[UIImageView alloc] initWithImage:kImageName(@"avatar_logout_default")];
    self.headView = headView;
    headView.layer.cornerRadius = 18;
    headView.layer.masksToBounds = YES;
    headView.frame = CGRectMake(0, 0, 36, 36);
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:self.headView];
    
    self.navigationItem.leftBarButtonItem = left;
    [headView addTapAction:^{
     @strongify(self)
        if (kUser.userInfo.touristFlag != 1) {
            ProfileViewControllerV2 *vc = [[ProfileViewControllerV2 alloc] init];
            [self pushViewController:vc];
            return;
        }
        [kUser pushLogin];
    }];
    // 导航栏左侧大标题
//    self.navBackTitle = kLocalize(@"feature_prayer");
}

#pragma mark --地理位置获取
- (void)dl_getLocation {
    @weakify(self);
    [[LocationManager sharedInstance] requestAuthorizationAndAddListenerWithKey:@"PrayerViewController" listenerBlock:^(BOOL success, CLAuthorizationStatus status) {
        @strongify(self);
        [kUserDefaults setBool:success forKey:kLocationLimit];
        [kUserDefaults synchronize];
        
        /// 保存设置地理位置信息
        self.prayerModel.isLocation = success;
        self.prayerView.prayerModel = self.prayerModel;
        if(success){
            [self dl_hiddenLocationTipView];
            [self dl_getLocationCity];
        }
    }];
    BOOL success = [kUserDefaults boolForKey:kLocationLimit];
    self.prayerModel.isLocation = success;
    self.prayerView.prayerModel = self.prayerModel;
    if(success){
        [self dl_hiddenLocationTipView];
        [self dl_getLocationCity];
    }
}

#pragma mark --地理位置解析
- (void)dl_getLocationCity {
    @weakify(self);
    [[LocationManager sharedInstance] getLocation:^(CLLocation * _Nonnull location, NSString * _Nonnull latitude, NSString * _Nonnull longitudeStr, NSString * _Nonnull city) {
        @strongify(self);
        if (![city isEqualToString:self.prayerModel.cityName]) {
            self.prayerModel.cityName = city;
            /// 将地理位置保存到本地
            [kUserDefaults setValue:city forKey:kLocationCity];
            [kUserDefaults setValue:latitude forKey:kLocationLatitude];
            [kUserDefaults setValue:longitudeStr forKey:kLocationlongitude];
            [kUserDefaults synchronize];
            
            [self.prayerView dl_getRequestWithLatitude:latitude andWithLongitude:longitudeStr andWithCityName:city];
        }
    } fail:^(NSError * _Nonnull error) {
        @strongify(self);
        //        kToast(error.userInfo[kHttpErrorReason]);
//        [self dl_getLocation];
    }];
}


- (PrayerModel *)prayerModel {
    if(!_prayerModel){
        _prayerModel = [[PrayerModel alloc] init];
    }
    return _prayerModel;
}

#pragma mark -- ================ UI处理 ==================
- (void)setupViews {
    self.navBackTitle = kLocalize(@"feature_prayer");
    [self.view addSubview:self.prayerView];
    [self dl_getLocation];
}

- (PrayerView *)prayerView {
    if(!_prayerView){
        _prayerView = [[PrayerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        @weakify(self);
        _prayerView.prayerNavBlock = ^(PrayerNavType type) {
            @strongify(self);
            [self dl_topNavButyonCLick:type];
        };
        _prayerView.prayerViewJumpLoginBlock = ^{
            [kUser pushLogin];
        };
    }
    return _prayerView;
}

- (PrayerLocationTipView *)locationTipView {
    if(!_locationTipView){
        _locationTipView = [[PrayerLocationTipView alloc] init];
        @weakify(self);
        _locationTipView.locationTipClickBlock = ^(UIButton * _Nonnull sender)  {
            @strongify(self);
            [self dl_locationTipsBtnNextTo:sender];
        };
    }
    return _locationTipView;
}

#pragma mark -- 展示地理位置tips
- (void)dl_showLocationTipView {
    [self.view addSubview:self.locationTipView];
    [self.locationTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark -- 隐藏提示框
- (void)dl_hiddenLocationTipView {
    if (self.locationTipView) {
        [self.locationTipView removeFromSuperview];
        self.locationTipView = nil;
    }
}

#pragma mark -- 点击nav上面按钮的点击事件
- (void)dl_topNavButyonCLick:(PrayerNavType )type {
    if (type == KNavTips) {
        [self dl_showLocationTipView];
    }else if(type == KNavHead) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if(type == KNavCompass){
        BOOL success = [kUserDefaults boolForKey:kLocationLimit];
        if(!success){
            [self dl_showLocationTipView];
        }else{
            CompassViewController *vc = [[CompassViewController alloc] init];
            vc.navBackTitle = kLocalize(@"qibla");
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark -- 点击地理位置放弃按钮和设置按钮
- (void)dl_locationTipsBtnNextTo:(UIButton *)sender {
    if(sender.tag == LocationTipCancle){
        [self.locationTipView removeFromSuperview];
        self.locationTipView = nil;
    }else if(sender.tag == LocationTipToSet){
        /// 判断是不是第一次获取定位权限
        if (![kUserDefaults boolForKey:@"LocationFirstUse"]) {
            @weakify(self);
            [self dl_jumpToServiceSet];
            [[LocationManager sharedInstance] requestAuthorizationAndAddListenerWithKey:@"PrayerViewController1" listenerBlock:^(BOOL success, CLAuthorizationStatus status) {
                @strongify(self);
                [kUserDefaults setBool:success forKey:kLocationLimit];
                [kUserDefaults synchronize];
                [self dl_getLocation];
            }];
            [kUserDefaults setBool:YES forKey:@"LocationFirstUse"];
        }else {
            [self dl_jumpToServiceSet];
        }
    }
}
- (void)dl_jumpToServiceSet {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    };
}

- (void)dealloc {
    [[LocationManager sharedInstance] removeAuthorizationListenerWithKey:@"PrayerViewController"];
    [[LocationManager sharedInstance] removeAuthorizationListenerWithKey:@"PrayerViewController"];
}
@end
