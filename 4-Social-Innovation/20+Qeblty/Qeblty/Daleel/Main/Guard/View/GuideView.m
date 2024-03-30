//
//  GuideView.m
//  Daleel
//
//  Created by mac on 2024/3/31.
//

#import "GuideView.h"
#import "PrayerViewController.h"
#import "GuideViewSubView.h"
#import "LocationManager.h"
#import <UserNotifications/UserNotifications.h>

@interface GuideView ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIButton *skipBtn;
@property (nonatomic,strong)UIScrollView *mainScrollow;
/// 圆点图片
@property (nonatomic,strong)UIImageView *pointImg;

@property (nonatomic,assign)NSInteger currentPage;

@end

@implementation GuideView

- (void)initialize {
    /// 保存默认城市
    [kUserDefaults setValue:kLocalize(@"riyadh") forKey:kLocationCity];
    [kUserDefaults setValue:@"24.7135517" forKey:kLocationLatitude];
    [kUserDefaults setValue:@"46.6752957" forKey:kLocationlongitude];
    [kUserDefaults synchronize];
    /// 进入获取地理位置权限
    [[LocationManager sharedInstance] requestAuthorizationAndAddListenerWithKey:@"GuideView" listenerBlock:^(BOOL success, CLAuthorizationStatus status) {
        [kUserDefaults setBool:success forKey:kLocationLimit];
        [kUserDefaults synchronize];
        [[LocationManager sharedInstance] getLocation:^(CLLocation * _Nonnull location, NSString * _Nonnull latitude, NSString * _Nonnull longitudeStr, NSString * _Nonnull city) {
            // 获取到了位置则修改为当前位置
            [kUserDefaults setValue:city forKey:kLocationCity];
            [kUserDefaults setValue:latitude forKey:kLocationLatitude];
            [kUserDefaults setValue:longitudeStr forKey:kLocationlongitude];
            [kUserDefaults synchronize];
        } fail:^(NSError * _Nonnull error) {
            
        }];
    }];
}

#pragma mark --UI处理=============================================================
- (void)setupViews {
    
    self.currentPage = 0;
    
    [self addSubview:self.mainScrollow];
    [self addSubview:self.skipBtn];
    [self addSubview:self.pointImg];
    
    [self.skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_offset(-16);
        make.top.mas_offset(kHeight_StatusBar + 25);
    }];
    
    [self.pointImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.bottom.mas_offset(-kHeight_Bottom_Extra - 50 * 667 / 812.f * kScale_H);
        make.size.mas_offset(CGSizeMake(48, 8));
    }];
}


#pragma mark -- 每一页添加控件
- (void)subPageWithView:(UIImageView *)imgView andWithTopLabelText:(NSString *)topText andWithSecondText:(NSString *)secondText andWithLimitImg:(NSString *)limitImg andWithLimitDiscribe:(NSString *)limitDiscribe andWithSwitchTag:(NSInteger )pageNum {
    imgView.userInteractionEnabled = YES;
    GuideViewSubView *guideViewSubView = [[GuideViewSubView alloc] initWithTopLabelText:topText andWithSecondText:secondText andWithLimitImg:limitImg andWithLimitDiscribe:limitDiscribe andWithSwitchTag:pageNum];
    [imgView addSubview:guideViewSubView];
    [guideViewSubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.mas_offset(0);
        make.bottom.mas_offset(-110-kHeight_Bottom_Extra);
        make.height.mas_offset(154);
    }];
}

#pragma mark --添加进入按钮
- (void)setupLastPageWithView:(UIImageView *)imageView {
    
    imageView.userInteractionEnabled = YES;
    UIButton* nextBtn = [[UIButton alloc] init];
    [nextBtn setBackgroundImage:kImageName(@"new_feature_nextBtn") forState:UIControlStateNormal];
    [nextBtn setTitle:kLocalize(@"start_qeblty") forState:UIControlStateNormal];
    [nextBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(starBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:nextBtn];
    
    UILabel *firstLB = [UILabel labelWithTextFont:kFontMedium(18) textColor:kBlackColor text:kLocalize(@"proceed_to_qeblty")];
    firstLB.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:firstLB];
    
    UILabel *secondLB = [UILabel labelWithTextFont:kFontRegular(14) textColor:RGB(0x666666) text:kLocalize(@"allow_qeblty_to_send_you_notifications")];
    secondLB.textAlignment = NSTextAlignmentCenter;;
    [imageView addSubview:secondLB];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.bottom.mas_offset(- 111 - kHeight_Bottom_Extra);
        make.size.mas_offset(CGSizeMake(230, 48));
    }];
    
    [secondLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_offset(0);
        make.bottom.equalTo(nextBtn.mas_top).offset(-46 * 667 / 812 * kScale_H);
    }];
    
    [firstLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_offset(0);
        make.bottom.equalTo(secondLB.mas_top).offset(-7 * 667 / 812 * kScale_H);
    }];
}

#pragma mark -- 开始按钮点击
- (void)starBtnClick:(UIButton*)button{
    /// 保存安装信息
    [kUserDefaults setBool:YES forKey:kFirstInstall];
    
    PrayerViewController *vc = [[PrayerViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    // 切换window的根控制器
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
}

#pragma mark --UI处理=============================================================
- (UIScrollView *)mainScrollow {
    if(!_mainScrollow){
        //初始化一个ScrollView
        _mainScrollow = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        //隐藏水平方向的滚动条
        _mainScrollow.showsHorizontalScrollIndicator = NO;
        //开启分页
        _mainScrollow.pagingEnabled = YES;
        //监听滑动-->成为代理
        _mainScrollow.delegate = self;
        NSInteger count = 3;
        for (int i = 0; i < count; i++) {
            //循环添加imageView
            UIImageView* imageView = [[UIImageView alloc] init];
            NSString *imgName = [NSString stringWithFormat:@"new_feature_%d", i + 1];
            if ([LanguageTool isArabic]) {
                imgName = [NSString stringWithFormat:@"new_feature_%d_ar", i + 1];
            }
            imageView.image = kImageName(imgName);
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            //设置大小与位置
            imageView.size = _mainScrollow.size;
            imageView.x = i * _mainScrollow.width;
            if ([LanguageTool isArabic]) {
                imageView.transform = CGAffineTransformMakeRotation(M_PI);
            }
            [_mainScrollow addSubview:imageView];
            switch (i) {
                case 0:{
                    [kUserDefaults setValue:kLocalize(@"riyadh") forKey:kLocationCity];
                    [kUserDefaults setValue:@"24.7135517" forKey:kLocationLatitude];
                    [kUserDefaults setValue:@"46.6752957" forKey:kLocationlongitude];
                    [kUserDefaults synchronize];
                    
                    [self subPageWithView:imageView andWithTopLabelText:kLocalize(@"allow_qeblty_to_access_your_location") andWithSecondText:kLocalize(@"in_order_to_provide_precise_prayer_time") andWithLimitImg:@"new_feature_location" andWithLimitDiscribe:kLocalize(@"allow_location_access") andWithSwitchTag:1];
                }
                    break;
                case 1:
                    [self subPageWithView:imageView andWithTopLabelText:kLocalize(@"allow_qeblty_to_send_you_notifications") andWithSecondText:kLocalize(@"in_order_to_remind_you_to_prayer") andWithLimitImg:@"new_feature_notification" andWithLimitDiscribe:kLocalize(@"allow_notifications") andWithSwitchTag:2];
                    break;
                case 2://最后一页
                    [self setupLastPageWithView:imageView];
                    break;
                default:
                    break;
            }
        }
        //设置scrollView的内容大小
        [_mainScrollow setContentSize:CGSizeMake(count * _mainScrollow.width, 0)];
        if ([LanguageTool isArabic]) {
            _mainScrollow.transform = CGAffineTransformMakeRotation(M_PI);
        }
    }
    return _mainScrollow;
}


- (UIButton *)skipBtn {
    if(!_skipBtn){
        _skipBtn = [UIButton buttonWithTitleFont:kFontRegular(16) titleColor:RGB(0x2f430d)];
        [_skipBtn setTitle:kLocalize(@"btn_skip") forState:UIControlStateNormal];
        @weakify(self);
        [_skipBtn addTapAction:^{
            @strongify(self);
            [self dl_scrollowToView];
        }];
    }
    return _skipBtn;
}

- (UIImageView *)pointImg {
    if(!_pointImg){
        _pointImg = [[UIImageView alloc] init];
        _pointImg.contentMode = UIViewContentModeScaleAspectFit;
        NSString *pointImgName = @"new_feature_point_1";
        if ([LanguageTool isArabic]) {
            pointImgName = @"new_feature_point_3";
        }
        [_pointImg setImage:kImageName(pointImgName)];
        [_pointImg sizeToFit];
    }
    return _pointImg;
}

#pragma mark --代理处理区域=============================================================
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //1.需要将我们的channelScrollow里面对应的ChannelLable显示在中间
    [self scrollViewDidEndScrollingAnimation:scrollView];
}
/**
 这个方法,可能做为一个公共的方法来调用,当然,我们也可以自己来创建一个公共的方法
 该方法,可以在两个地方调用,一个是当我点击了channelScrollow的channelLabel的时候
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{

    //计算滑动到第几页
    self.currentPage = (NSInteger)scrollView.contentOffset.x / scrollView.bounds.size.width;
    switch (self.currentPage) {
        case 0:{
            self.skipBtn.hidden = NO;
            /// 进入获取地理位置权限
            [[LocationManager sharedInstance] requestAuthorizationAndAddListenerWithKey:@"GuideView1" listenerBlock:^(BOOL success, CLAuthorizationStatus status) {
                [kUserDefaults setBool:success forKey:kLocationLimit];
                [kUserDefaults synchronize];
            }];
            NSString *pointImgName = @"new_feature_point_1";
            if ([LanguageTool isArabic]) {
                pointImgName = @"new_feature_point_3";
            }
            [self.pointImg setImage:kImageName(pointImgName)];
        }
            break;
        case 1:{
            self.skipBtn.hidden = NO;
            if (![kUserDefaults boolForKey:kNotificationLimit]) {
                if (@available(iOS 10.0, *)) {
                    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
                        [kUserDefaults setBool:granted forKey:kNotificationLimit];
                        [kUserDefaults synchronize];
                    }];
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                }
            }
            [self.pointImg setImage:kImageName(@"new_feature_point_2")];
        }
            break;
        case 2:{
            self.skipBtn.hidden = YES;
            NSString *pointImgName = @"new_feature_point_3";
            if ([LanguageTool isArabic]) {
                pointImgName = @"new_feature_point_1";
            }
            [self.pointImg setImage:kImageName(pointImgName)];
        }
            break;
        default:
            self.skipBtn.hidden = NO;
            break;
    }
}

#pragma mark --一般方法抽取=============================================================
- (void)dl_scrollowToView {
    [self.mainScrollow setContentOffset:CGPointMake((self.currentPage + 1) * self.mainScrollow.bounds.size.width, 0) animated:YES];
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

- (void)dealloc {
    [[LocationManager sharedInstance] removeAuthorizationListenerWithKey:@"GuideView1"];
    [[LocationManager sharedInstance] removeAuthorizationListenerWithKey:@"GuideView"];
}
@end
