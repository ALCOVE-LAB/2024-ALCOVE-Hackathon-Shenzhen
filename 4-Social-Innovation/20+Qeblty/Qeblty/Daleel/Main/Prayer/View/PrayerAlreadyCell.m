//
//  PrayerCell.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "PrayerAlreadyCell.h"
#import "PrayerModel.h"
#import "LocalNotificationManager.h"
#import "DownloadSoundManager.h"

#define kFix  667 / 812.f / kScale_H

@interface PrayerAlreadyCell ()

@property (nonatomic,strong)UIView *cellBgView;
//@property (nonatomic,strong)UILabel *titleLB;
@property (nonatomic,strong)UILabel *timeLB;
@property (nonatomic,strong)UIView *redPointV;
@property (nonatomic,strong)UIButton *locationBtn;
@property (nonatomic,strong)UIButton *locationMaskBtn;
@property (nonatomic,strong)UILabel *locationLB;
@property (nonatomic,strong)UIImageView *tomorrowImg;
@property (nonatomic,strong)UILabel *tomorrowLB;

@property (nonatomic,strong)UILabel *rightBigLB;
@property (nonatomic,strong)UILabel *clockLB;
@property (nonatomic,strong)UIButton *checkInBtn;

/// 定时器
@property (nonatomic, strong) RACDisposable *disposable;

@end

@implementation PrayerAlreadyCell

- (void)setPrayerModel:(PrayerModel *)prayerModel {
    _prayerModel = prayerModel;
    if (prayerModel) {
        self.rightBigLB.text = kLocalize(prayerModel.prayType.lowercaseString);
        self.locationLB.text = [kUserDefaults valueForKey:kLocationCity];
        
        self.redPointV.hidden = self.locationMaskBtn.hidden = prayerModel.isLocation;
        
        if ([prayerModel.prayDateStr isEqualToString:[NSString nowTimeFormatted]]) {
            self.tomorrowImg.hidden = YES;
            self.timeLB.text = [NSString dataFormatterChangeWithNowOrTRM:NO];
        }else {
            self.tomorrowImg.hidden = NO;
            self.timeLB.text = [NSString dataFormatterChangeWithNowOrTRM:YES];
        }
        
        if (prayerModel.checkInFlag.boolValue) {
            self.checkInBtn.hidden = YES;
            self.clockLB.hidden = YES;
        }else{
            if (prayerModel.isShowCheckBtn) {
                self.checkInBtn.hidden = NO;
                self.clockLB.hidden = YES;
            }else{
                self.checkInBtn.hidden = YES;
                self.clockLB.hidden = NO;
                self.clockLB.text = [NSString timeFormatted:prayerModel.timeSecond];
            }
        }
        
        /// 设置定时器
        [self dl_getTimerFire:prayerModel];
        
        /// 设置背景图片
        if ([prayerModel.prayType isEqualToString:@"Fajr"]) {
            self.cellBgView.backgroundColor = RGB_ALPHA(0x252C40,0.9);
        }else if ([prayerModel.prayType isEqualToString:@"Dhuhr"]) {
            self.cellBgView.backgroundColor = RGB_ALPHA(0x376DAB,0.9);
        }else if ([prayerModel.prayType isEqualToString:@"Asr"]) {
            self.cellBgView.backgroundColor = RGB_ALPHA(0xA88C6B,0.7);
        }else if ([prayerModel.prayType isEqualToString:@"Maghrib"]) {
            self.cellBgView.backgroundColor = RGB_ALPHA(0x8B4C5D,0.7);
        }else if ([prayerModel.prayType isEqualToString:@"Sunrise"]) {
            self.cellBgView.backgroundColor = RGB_ALPHA(0x748A98,0.9);
        }else if ([prayerModel.prayType isEqualToString:@"Isha"]) {
            self.cellBgView.backgroundColor = RGB_ALPHA(0x242D5E,0.9);
        }
    }
}

#pragma mark --UI处理
- (void)setupViews {
    [self.contentView addSubview:self.cellBgView];
    [self.cellBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(18);
        make.trailing.mas_equalTo(-16);
        make.top.bottom.mas_equalTo(0);
    }];
}

- (UIView *)cellBgView {
    if(!_cellBgView){
        _cellBgView = [[UIView alloc] init];
        _cellBgView.backgroundColor = RGB_ALPHA(0x252C40,0.8);
        _cellBgView.layer.cornerRadius = 12.f;
        _cellBgView.layer.masksToBounds = YES;
        
        [_cellBgView addSubview:self.timeLB];
        [_cellBgView addSubview:self.tomorrowImg];
        [_cellBgView addSubview:self.locationBtn];
        [_cellBgView addSubview:self.locationMaskBtn];
        [_cellBgView addSubview:self.redPointV];
        [_cellBgView addSubview:self.locationLB];
        [_cellBgView addSubview:self.rightBigLB];
        [_cellBgView addSubview:self.clockLB];
        [_cellBgView addSubview:self.checkInBtn];
        
        [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(20);
            make.top.mas_equalTo(25);
        }];
        [self.tomorrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.timeLB.mas_trailing).offset(6);
            make.centerY.equalTo(self.timeLB);
            make.size.mas_equalTo(CGSizeMake(36.f, 16.f));
        }];
        [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(20);
            make.bottom.mas_offset(-15 * kFix);
        }];
        [self.locationMaskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.locationBtn);
            make.size.mas_offset(CGSizeMake(30, 30));
        }];
        [self.redPointV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.locationBtn.mas_trailing);
            make.top.equalTo(self.locationBtn).offset(-7);
            make.size.mas_offset(CGSizeMake(7, 7));
        }];
        [self.locationLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.locationBtn.mas_trailing).offset(5);
            make.centerY.equalTo(self.locationBtn);
        }];
        [self.rightBigLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-20);
            make.top.mas_equalTo(10);
        }];
        [self.clockLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.rightBigLB);
            make.centerY.equalTo(self.locationBtn);
        }];
        [self.checkInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-15);
            make.centerY.equalTo(self.locationBtn);
            make.size.mas_equalTo(CGSizeMake(100, 32));
        }];
    }
    return _cellBgView;
}

- (UILabel *)timeLB {
    if(!_timeLB){
        _timeLB = [UILabel labelWithTextFont:kFontBold(16) textColor:RGB(0xffffff) text:[NSString dataFormatterChangeWithNowOrTRM:NO]];
    }
    return _timeLB;
}

- (UIView *)redPointV {
    if(!_redPointV){
        _redPointV = [[UIView alloc] init];
        _redPointV.backgroundColor = RGB(0xF31414);
        _redPointV.layer.cornerRadius = 3.f;
        _redPointV.layer.masksToBounds = YES;
    }
    return _redPointV;
}

- (UIButton *)locationBtn {
    if(!_locationBtn){
        _locationBtn = [[UIButton alloc] init];
        [_locationBtn setImage:kImageName(@"prayer_location") forState:UIControlStateNormal];
    }
    return _locationBtn;
}

- (UIButton *)locationMaskBtn {
    if(!_locationMaskBtn){
        _locationMaskBtn = [[UIButton alloc] init];
        _locationMaskBtn.backgroundColor = kClearColor;
        _locationMaskBtn.tag = 101;
        @weakify(self);
        [_locationMaskBtn addTapAction:^{
            @strongify(self);
            /// block回调
            ExecBlock(self.prayerAlreadyCellBtnBlock,self.locationMaskBtn);
        }];
    }
    return _locationMaskBtn;
}


- (UILabel *)locationLB {
    if(!_locationLB){
        _locationLB = [UILabel labelWithTextFont:kFontRegular(16) textColor:[UIColor colorWithHexString:@"#ffffff"] text:kLocalize(@"riyadh")];
    }
    return _locationLB;
}

- (UIImageView *)tomorrowImg {
    if(!_tomorrowImg){
        _tomorrowImg = [[UIImageView alloc] initWithImage:kImageName(@"prayer_tomorrow_tag")];
        [_tomorrowImg addSubview:self.tomorrowLB];
        _tomorrowImg.hidden = YES;
        
        [self.tomorrowLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _tomorrowImg;
}

- (UILabel *)tomorrowLB {
    if(!_tomorrowLB){
        _tomorrowLB = [UILabel labelWithTextFont:kFontMedium(11) textColor:RGB(0xFFD37A) text:@"TMR"];
        if ([LanguageTool isArabic]) {
            _tomorrowLB.text = @"غداً";
        }
        _tomorrowLB.textAlignment = NSTextAlignmentCenter;
    }
    return _tomorrowLB;
}

- (UILabel *)rightBigLB {
    if(!_rightBigLB){
        _rightBigLB = [UILabel labelWithTextFont:kFont(28) textColor:[UIColor whiteColor] text:@"Asr"];
        _rightBigLB.textAlignment = NSTextAlignmentRight;
    }
    return _rightBigLB;
}

- (UILabel *)clockLB {
    if(!_clockLB){
        _clockLB = [UILabel labelWithTextFont:kFont(20) textColor:UIColor.whiteColor text:@"00:00:00"];
        _clockLB.textAlignment = NSTextAlignmentRight;
        _clockLB.hidden = YES;
    }
    return _clockLB;
}

- (UIButton *)checkInBtn {
    if(!_checkInBtn){
        _checkInBtn = [UIButton buttonWithTitleFont:kFontMedium(14) titleColor:RGB(0xffffff) title:kLocalize(@"check_in")];
        _checkInBtn.backgroundColor = RGB_ALPHA(0xffffff, 0.2);
        _checkInBtn.layer.cornerRadius = 16.f;
        _checkInBtn.layer.masksToBounds = YES;
        _checkInBtn.tag = 100;
        [_checkInBtn addTarget:self action:@selector(dl_checkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkInBtn;
}

#pragma mark --一般方法抽取=============================================================
- (void)dl_checkBtnClick:(UIButton *)sender {
    if (kUser.isLogin) {
        /// 点击签到按钮 处理loading
        [sender setImage:kImageName(@"prayer_checkIn_loadImg") forState:UIControlStateNormal];
        sender.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        if (kIsAR) {
            sender.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        }
        CABasicAnimation* rotationAnimation;
        //绕哪个轴，那么就改成什么：这里是绕z轴 ---> transform.rotation.z
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        //旋转角度
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI];
        //每次旋转的时间（单位秒）
        rotationAnimation.duration = 0.5;
        rotationAnimation.cumulative = YES;
        //重复旋转的次数，如果你想要无数次，那么设置成MAXFLOAT
        rotationAnimation.repeatCount = MAXFLOAT;
        [sender.imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
    /// block回调
    ExecBlock(self.prayerAlreadyCellBtnBlock,sender);
}

#pragma mark --开发定时器
- (void)dl_getTimerFire:(PrayerModel *)prayerModel {
    [self dl_timerStop];
    @weakify(self);
    /// 添加定时器
    self.disposable = [[[RACSignal interval:1 onScheduler:[RACScheduler currentScheduler]]takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self);
        prayerModel.timeSecond --;
        if(prayerModel.timeSecond <= 0){
            self.checkInBtn.hidden = NO;
            self.clockLB.hidden = YES;
        }else {
            self.checkInBtn.hidden = YES;
            self.clockLB.hidden = NO;
            self.clockLB.text = [NSString timeFormatted:prayerModel.timeSecond];
        }
        /// 倒计时结束后  60分之内在刷新一次界面
        if (prayerModel.timeSecond == -3660) {
            if (self.prayerAlreadyCellReloadBlock) {
                self.prayerAlreadyCellReloadBlock();
            }
            [self dl_timerStop];
        }
    }];
}
#pragma mark --定时器关闭
- (void)dl_timerStop {
    if (self.disposable) {
        [self.disposable dispose];
        self.disposable = nil;
    }
}

- (void)dealloc {
    [self dl_timerStop];
}
@end
