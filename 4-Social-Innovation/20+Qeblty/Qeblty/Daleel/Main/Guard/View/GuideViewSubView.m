//
//  GuideViewSubView.m
//  Daleel
//
//  Created by mac on 2024/3/31.
//

#import "GuideViewSubView.h"
#import "LocationManager.h"
#import <UserNotifications/UserNotifications.h>

@interface GuideViewSubView ()
/// 第一行label
@property (nonatomic,strong)UILabel *firstLB;
/// 第二行label
@property (nonatomic,strong)UILabel *secondLB;
/// 第三行的switch
@property (nonatomic,strong)UIView *switchView;
/// 前面的限制标识图片
@property (nonatomic,strong)UIImageView *limitImg;
/// 描述的label
@property (nonatomic,strong)UILabel *discribeLB;
/// 限制的switch
@property (nonatomic,strong)UISwitch *limitSwitch;

@property (nonatomic,assign)NSInteger pageNum;

@end

@implementation GuideViewSubView

- (instancetype)initWithTopLabelText:(NSString *)topText andWithSecondText:(NSString *)secondText andWithLimitImg:(NSString *)limitImg andWithLimitDiscribe:(NSString *)limitDiscribe andWithSwitchTag:(NSInteger )pageNum {
    self = [super init];
    if (self) {
        [self dl_setupViews];
        [self dl_setupDatasWithTopLabelText:topText andWithSecondText:secondText andWithLimitImg:limitImg andWithLimitDiscribe:limitDiscribe andWithSwitchTag:pageNum];
        
        /// app从后台进入前台刷新一次界面
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(guideApplicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)dl_setupViews {
    self.backgroundColor = kClearColor;
    
    [self addSubview:self.firstLB];
    [self addSubview:self.secondLB];
//    [self addSubview:self.switchView];
    [self.firstLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_offset(0);
        make.top.mas_offset(0);
    }];
    
    [self.secondLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_offset(0);
        make.top.equalTo(self.firstLB.mas_bottom).offset(7);
    }];
    
//    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.mas_offset(16);
//        make.trailing.mas_offset(-16);
//        make.bottom.mas_offset(0);
//        make.height.mas_offset(50);
//    }];
}

- (UILabel *)firstLB {
    if(!_firstLB){
        _firstLB = [UILabel labelWithTextFont:kFontMedium(18) textColor:kBlackColor text:kLocalize(@"allow_qeblty_to_access_your_location")];
        _firstLB.textAlignment = NSTextAlignmentCenter;
    }
    return _firstLB;
}

- (UILabel *)secondLB {
    if(!_secondLB){
        _secondLB = [UILabel labelWithTextFont:kFontRegular(14) textColor:RGB(0x666666) text:kLocalize(@"in_order_to_provide_precise_prayer_time")];
        _secondLB.textAlignment = NSTextAlignmentCenter;;
    }
    return _secondLB;
}

- (UIView *)switchView {
    if(!_switchView){
        _switchView = [[UIView alloc] init];
        _switchView.backgroundColor = kWhiteColor;
        _switchView.layer.cornerRadius = 10.f;
        _switchView.layer.masksToBounds = YES;
        
        [_switchView addSubview:self.limitImg];
        [_switchView addSubview:self.discribeLB];
        [_switchView addSubview:self.limitSwitch];
        
        [self.limitImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_offset(12);
            make.centerY.mas_offset(0);
            make.size.mas_offset(CGSizeMake(30, 30));
        }];
        [self.discribeLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.limitImg.mas_trailing).offset(10);
            make.centerY.equalTo(self.limitImg);
        }];
        
        [self.limitSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_offset(-14);
            make.centerY.equalTo(self.limitImg);
            make.size.mas_offset(CGSizeMake(51, 31));
        }];
    }
    return _switchView;
}

- (UIImageView *)limitImg {
    if(!_limitImg){
        _limitImg = [[UIImageView alloc] init];
    }
    return _limitImg;
}

- (UILabel *)discribeLB {
    if(!_discribeLB){
        _discribeLB = [UILabel labelWithTextFont:kFontRegular(15) textColor:kBlackColor text:kLocalize(@"allow_location_access")];
    }
    return _discribeLB;
}

- (UISwitch *)limitSwitch {
    if(!_limitSwitch){
        _limitSwitch = [[UISwitch alloc] init];
        [_limitSwitch addTarget:self action:@selector(limitSwitch:) forControlEvents:UIControlEventValueChanged];
    }
    return _limitSwitch;
}

#pragma mark --数据处理区域=============================================================
- (void)dl_setupDatasWithTopLabelText:(NSString *)topText andWithSecondText:(NSString *)secondText andWithLimitImg:(NSString *)limitImg andWithLimitDiscribe:(NSString *)limitDiscribe andWithSwitchTag:(NSInteger )pageNum {
    self.firstLB.text = topText;
    self.secondLB.text = secondText;
    self.limitImg.image = kImageName(limitImg);
    self.discribeLB.text = limitDiscribe;
    self.limitSwitch.tag = pageNum;
    if (pageNum == 1) {
        self.limitSwitch.on = [kUserDefaults boolForKey:kLocationLimit];
    }else {
        self.limitSwitch.on = [kUserDefaults boolForKey:kNotificationLimit];
    }
}

- (void)limitSwitch:(UISwitch *)sender {
    if (sender.tag == 1) {
        if (sender.on) {
            if (![kUserDefaults boolForKey:@"LocationFirstUse"]) {
                [[LocationManager sharedInstance] requestAuthorizationAndAddListenerWithKey:@"GuideViewSubView" listenerBlock:^(BOOL success, CLAuthorizationStatus status) {
                        sender.on = success;
                        [kUserDefaults setBool:success forKey:kLocationLimit];
                        [kUserDefaults synchronize];
                }];
                [kUserDefaults setBool:YES forKey:@"LocationFirstUse"];
                /// 获取地理位置
                [self dl_getLocationCity];
            }else{
                if (![kUserDefaults boolForKey:kLocationLimit]) {
                    [self dl_openSystemSet];
                }
            }
        }else {
            [self dl_openSystemSet];
        }
    }else {
        if (sender.on) {
            if (![kUserDefaults boolForKey:@"NotificationFirstUse"]) {
                if (@available(iOS 10.0, *)) {
                    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
                        dispatch_async(dispatch_get_main_queue(),^ {
                            sender.on = granted;
                        });
                        [kUserDefaults setBool:granted forKey:kNotificationLimit];
                        [kUserDefaults synchronize];
                    }];
                }
                [kUserDefaults setBool:YES forKey:@"NotificationFirstUse"];
            }else {
                if (![kUserDefaults boolForKey:kNotificationLimit]) {
                    [self dl_openSystemSet];
                }
            }
        }else {
            [self dl_openSystemSet];
        }
    }
}

#pragma mark --从设置界面回来的时候  设置一下switch
- (void)guideApplicationBecomeActive {
    if (self.limitSwitch.tag == 1) {
        self.limitSwitch.on = [self isLocationServiceOpen];
        [kUserDefaults setBool:[self isLocationServiceOpen] forKey:kLocationLimit];
        [kUserDefaults synchronize];
    }else {
        [self openMessageNotificationServiceWithBlock:^(BOOL success) {
            @weakify(self);
            dispatch_async(dispatch_get_main_queue(),^ {
                @strongify(self);
                self.limitSwitch.on = success;
            });
            [kUserDefaults setBool:success forKey:kNotificationLimit];
            [kUserDefaults synchronize];
        }];
    }
}

#pragma mark --获取是否开启定位权限
- (BOOL)isLocationServiceOpen {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        return YES;
    } else
        return NO;
}

#pragma mark --获取是否开启通知权限

- (void)openMessageNotificationServiceWithBlock:(void(^)(BOOL success))returnBlock {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {
        if (returnBlock) {
            returnBlock(settings.authorizationStatus == UNAuthorizationStatusAuthorized);
        }
    }];
#elif __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    returnBlock([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]);
#else
    UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (returnBlock) {
        returnBlock(type != UIRemoteNotificationTypeNone);
    }
#endif
}

#pragma mark --打开设置
- (void)dl_openSystemSet{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        };
    }
}

#pragma mark --一般方法抽取=============================================================
#pragma mark --地理位置解析
- (void)dl_getLocationCity {
    @weakify(self);
    [[LocationManager sharedInstance] getLocation:^(CLLocation * _Nonnull location, NSString * _Nonnull latitude, NSString * _Nonnull longitudeStr, NSString * _Nonnull city) {
            /// 将地理位置保存到本地
            [kUserDefaults setValue:city forKey:kLocationCity];
            [kUserDefaults setValue:latitude forKey:kLocationLatitude];
            [kUserDefaults setValue:longitudeStr forKey:kLocationlongitude];
            [kUserDefaults synchronize];
    } fail:^(NSError * _Nonnull error) {
       
    }];
}

- (void)dealloc {
    [[LocationManager sharedInstance] removeAuthorizationListenerWithKey:@"GuideViewSubView"];
}

@end
