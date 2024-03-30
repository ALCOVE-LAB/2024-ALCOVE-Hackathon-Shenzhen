//
//  PrayerToDoCell.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "PrayerToDoCell.h"
#import "PrayerModel.h"
#import "LocalNotificationManager.h"
#import "DownloadSoundManager.h"
#import "LocationManager.h"

#define kFix  667 / 812.f / kScale_H

@interface PrayerToDoCell ()

@property (nonatomic,strong)UIView *cellBgView;
@property (nonatomic,strong)UIView *selectView;
@property (nonatomic,strong)UIImageView *checkInImg;
@property (nonatomic,strong)UILabel *behaviorLB;
@property (nonatomic,strong)UILabel *soundLB;
@property (nonatomic,strong)UIImageView *remindImg;
@property (nonatomic,strong)UILabel *timeLB;
@property (nonatomic,strong)UIView *lineV;

@end

@implementation PrayerToDoCell

#pragma mark --UI处理
- (void)setupViews{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.cellBgView];
    [self.cellBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(18);
        make.trailing.mas_equalTo(-16);
        make.top.bottom.mas_equalTo(0);
    }];
}

#pragma mark --是否切圆角  用isRadiusTeger 判断切圆角  0是上面圆角  1是下面圆角  2是全切
-(void)setIsRadiusTeger:(NSInteger)isRadiusTeger{
    _isRadiusTeger = isRadiusTeger;
    [self dl_cellRadius:self.cellBgView andWithRadiusTeger:isRadiusTeger];
}

- (UIView *)cellBgView{
    if(!_cellBgView){
        _cellBgView = [[UIView alloc] init];
        _cellBgView.backgroundColor = [UIColor colorWithHexString:@"#D2DEEA" alpha:0.5];
        
        [_cellBgView addSubview:self.selectView];
        [_cellBgView addSubview:self.checkInImg];
        [_cellBgView addSubview:self.behaviorLB];
        [_cellBgView addSubview:self.soundLB];
        [_cellBgView addSubview:self.remindImg];
        [_cellBgView addSubview:self.timeLB];
        [_cellBgView addSubview:self.lineV];
        
        [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [self.checkInImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(20);
            make.top.mas_equalTo(24);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        [self.behaviorLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.checkInImg.mas_trailing).offset(16);
            make.top.mas_equalTo(15);
        }];
        [self.soundLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.behaviorLB);
            make.top.equalTo(self.behaviorLB.mas_bottom).offset(8);
        }];
        [self.remindImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-20);
            make.top.mas_equalTo(31);
            make.size.mas_equalTo(CGSizeMake(16, 18));
        }];
        [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.remindImg.mas_leading).offset(-10);
            make.centerY.equalTo(self.remindImg);
        }];
        [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(56);
            make.trailing.mas_equalTo(-20);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    }
    return _cellBgView;
}

- (UIView *)selectView {
    if(!_selectView){
        _selectView = [[UIView alloc] init];
        _selectView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:0.15];
        _selectView.hidden = YES;
    }
    return _selectView;
}

- (UIImageView *)checkInImg{
    if(!_checkInImg){
        _checkInImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"prayer_checkInSuccessfully"]];
    }
    return _checkInImg;
}

- (UILabel *)behaviorLB{
    if(!_behaviorLB){
        _behaviorLB = [UILabel labelWithTextFont:kFont(18) textColor:[UIColor whiteColor] text:@""];
    }
    return _behaviorLB;
}

- (UILabel *)soundLB{
    if(!_soundLB){
        _soundLB = [UILabel labelWithTextFont:kFont(14) textColor:[UIColor colorWithHexString:@"#ffffff" alpha:0.6] text:@""];
    }
    return _soundLB;
}

- (UIImageView *)remindImg{
    if(!_remindImg){
        _remindImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"prayer_remind"]];
    }
    return _remindImg;
}

- (UILabel *)timeLB{
    if(!_timeLB){
        _timeLB = [UILabel labelWithTextFont:kFont(16) textColor:[UIColor whiteColor] text:@"00:00"];
    }
    return _timeLB;
}

- (UIView *)lineV{
    if(!_lineV){
        _lineV = [[UIView alloc] init];
        _lineV.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:0.2];
    }
    return _lineV;
}

#pragma mark --数据处理区域=============================================================
- (void)setPrayerModel:(PrayerModel *)prayerModel {
    _prayerModel = prayerModel;
    if(prayerModel) {
        // 缓存数据 铃声
        [kUserDefaults setValue:prayerModel.ringingName forKey:[NSString stringWithFormat:@"%@-%@-ringName",kUser.userInfo.userId,prayerModel.prayType]];
        // 缓存数据 祈祷时间
        [kUserDefaults setValue:prayerModel.remindType forKey:[NSString stringWithFormat:@"%@-%@-remindTime",kUser.userInfo.userId,prayerModel.prayType]];
        // 缓存数据 是否签到
        [kUserDefaults setBool:prayerModel.checkInFlag.boolValue forKey:[NSString stringWithFormat:@"%@-%@-checkInFlag",kUser.userInfo.userId,prayerModel.prayType]];
        
        [kUserDefaults synchronize];
        
        
        self.behaviorLB.text = kLocalize(prayerModel.prayType.lowercaseString);
        self.timeLB.text = prayerModel.prayTime;
        if(prayerModel.ringingName && kUser.isLogin){/// 登录的状态展示铃声名字,未登录状态展示的是默认的
            self.soundLB.text = prayerModel.ringingName;
        }else {
            if ([prayerModel.prayType isEqualToString:@"Sunrise"]) {
                self.soundLB.text = kLocalize(@"none");
            }else {
                self.soundLB.text = kLocalize(@"abdul_basit");
            }
        }
        
        [self.checkInImg setImage:[self getStatusImage]];
        self.selectView.hidden = !prayerModel.isSelect;
        
        // 计算本地推送的时间
        NSInteger countDownValue = (prayerModel.prayDate.integerValue - [NSDate  getCurrentStamp]) / 1000;
        NSInteger tomorrowValue = countDownValue + 86400;
        
        /// 取消今天通知
        [LocalNotificationManager dl_cancleLocalNotificationWithIdentifer:[NSString stringWithFormat:@"%@",kLocalize(prayerModel.prayType.lowercaseString)]];
        /// 取消相应的明天通知
        [LocalNotificationManager dl_cancleLocalNotificationWithIdentifer:[NSString stringWithFormat:@"%@_tomorrow",kLocalize(prayerModel.prayType.lowercaseString)]];
        ///注册今天本地通知
        [self dl_localMessage:prayerModel andWithCountDown:countDownValue andWithIdentifier:kLocalize(prayerModel.prayType.lowercaseString)];
        /// 注册明天通知
        [self dl_localMessage:prayerModel andWithCountDown:tomorrowValue andWithIdentifier:[NSString stringWithFormat:@"%@_tomorrow",kLocalize(prayerModel.prayType.lowercaseString)]];
    }
    
    /// 根据时间不同 展示不同的cell背景
    if ([prayerModel.cellBgColorStr isEqualToString:@"Fajr"]) {
        self.cellBgView.backgroundColor = RGB_ALPHA(0x252C40,0.6);
    }else if ([prayerModel.cellBgColorStr isEqualToString:@"Dhuhr"]) {
        self.cellBgView.backgroundColor = RGB_ALPHA(0x376DAB,0.6);
    }else if ([prayerModel.cellBgColorStr isEqualToString:@"Asr"]) {
        self.cellBgView.backgroundColor = RGB_ALPHA(0xA88C6B,0.6);
    }else if ([prayerModel.cellBgColorStr isEqualToString:@"Maghrib"]) {
        self.cellBgView.backgroundColor = RGB_ALPHA(0xC0816B,0.6);
    }else if ([prayerModel.cellBgColorStr isEqualToString:@"Sunrise"]) {
        self.cellBgView.backgroundColor = RGB_ALPHA(0x748A98,0.6);
    }else if ([prayerModel.cellBgColorStr isEqualToString:@"Isha"]) {
        self.cellBgView.backgroundColor = RGB_ALPHA(0x242D5E, 0.6);
    }
}

#pragma mark --切部分圆角方法
- (void)dl_cellRadius:(UIView *)radiusView andWithRadiusTeger:(NSInteger )radiusTeger {
    CGRect rect = CGRectMake(0, 0, kScreenWidth - 34, 80.f * kFix);
    UIBezierPath *maskPath = [self dl_getRadiusTeger:radiusTeger andWithRect:rect];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = rect;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    radiusView.layer.mask = maskLayer;
}

#pragma mark --UIBezierPath 方法抽取
- (UIBezierPath *)dl_getRadiusTeger:(NSInteger )radiusTeger andWithRect:(CGRect )rect {
    if(radiusTeger == 0){
        self.lineV.hidden = NO;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(16.f, 16.f)];
        return maskPath;
    }else if (radiusTeger == 1){
        self.lineV.hidden = YES;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(16.f, 16.f)];
        return maskPath;
    }else if (radiusTeger == 2){
        self.lineV.hidden = YES;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight  cornerRadii:CGSizeMake(16.f, 16.f)];
        return maskPath;
    }else{
        self.lineV.hidden = NO;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(0.f, 0.f)];
        return maskPath;
    }
}

#pragma mark --通知方法提取
- (void)dl_localMessage:(PrayerModel *)prayerModel andWithCountDown:(NSInteger )timeDown andWithIdentifier:(NSString *)identifier {
    
    if ([self.soundLB.text isEqualToString:kLocalize(@"none")] || [self.soundLB.text isEqualToString:kLocalize(@"silent")]) {
        if (kUser.isLogin) {/// 登录的时候才去展示不同的铃声图片,未登录展示默认的
            [self.remindImg setImage:kImageName(@"prayer_mute")];
        }else {
            if ([prayerModel.prayType isEqualToString:@"Sunrise"]) {
                [self.remindImg setImage:kImageName(@"prayer_mute")];
            }else{
                [self.remindImg setImage:kImageName(@"prayer_remind")];
            }
        }
        if ([self.soundLB.text isEqualToString:kLocalize(@"none")] || [self.soundLB.text isEqualToString:kLocalize(@"none")]) {
            return;
        }
    }else {
        switch (prayerModel.remindType.integerValue) {
            case 0:
                [self.remindImg setImage:kImageName(@"prayer_remind")];
                break;
            case 5:
                timeDown = timeDown - 300;
                [self.remindImg setImage:kImageName(@"prayer_remindAhead")];
                break;
            case 10:
                timeDown = timeDown - 600;
                [self.remindImg setImage:kImageName(@"prayer_remindAhead")];
                break;
            case 15:
                timeDown = timeDown - 900;
                [self.remindImg setImage:kImageName(@"prayer_remindAhead")];
                break;
            case -5:
                timeDown = timeDown + 300;
                [self.remindImg setImage:kImageName(@"prayer_delayRemind")];
                break;
            case -10:
                timeDown = timeDown + 600;
                [self.remindImg setImage:kImageName(@"prayer_delayRemind")];
                break;
            case -15:
                timeDown = timeDown + 900;
                [self.remindImg setImage:kImageName(@"prayer_delayRemind")];
                break;
            default:
                break;
        }
    }
    /// 传递个参数 如果有prayerModel.ringingName 将参数传递
    NSDictionary *userInfo = @{};
    if (self.soundLB.text.length > 0) {
        userInfo = @{@"ringName":self.soundLB.text};
    }
    /// 推送标题
    NSString *cityName = [kUserDefaults valueForKey:kLocationCity];
    NSString *messageTitle = [NSString stringWithFormat:kLocalize(@"location_message_begin"),kLocalize(prayerModel.prayType.lowercaseString),cityName];
    if (![identifier containsString:@"tomorrow"]) {/// 保存祈祷的时间提示  为了埋点处使用
        [kUserDefaults setValue:prayerModel.remindType forKey:messageTitle];
        [kUserDefaults synchronize];
    }
    NSString *bodyStr = @"  اللهُ أكبرْ , اللهُ أكبرْ . اللهُ أكبرْ , اللهُ أكبرْ";
    
    if (timeDown > 0) {
        NSString *ringUrlStr = prayerModel.ringingUrl;// 拿到返回的ringUrl
        NSString *musicTemptr;// 定义一个铃声字符串
        NSString *musictr;
        if (ringUrlStr && [ringUrlStr containsString:@"http"]) {// 判断后台返回的是不是url
            musicTemptr = [[ringUrlStr componentsSeparatedByString:@"/"] lastObject];
            NSString *soundStr = [[musicTemptr componentsSeparatedByString:@"."] firstObject];
            musictr = [NSString stringWithFormat:@"%@.m4a",soundStr];
            if ([[DownloadSoundManager sharedInstance] judgeFileExist:musictr]) {
                [LocalNotificationManager dl_addLocalNotificationWithTitle:messageTitle subTitle:@"" body:bodyStr timeInterval:timeDown identifier:identifier userInfo:userInfo repeats:NO sound:musictr];
            } else {
                [[DownloadSoundManager sharedInstance] dl_beginDownLoadSoundsResourceWithUrl:ringUrlStr andWithProgress:^(NSProgress * _Nonnull downloadProgress) {} andWithCallBack:^(NSString * _Nullable path, BOOL success) {
                    [LocalNotificationManager dl_addLocalNotificationWithTitle:messageTitle subTitle:@"" body:bodyStr timeInterval:timeDown identifier:identifier userInfo:userInfo repeats:NO sound:path];
                }];
            }
        } else {
            NSString *musicStr = kUser.isLogin ? @"" : @"Abdul-basit";
            [LocalNotificationManager dl_addLocalNotificationWithTitle:messageTitle subTitle:@"" body:bodyStr timeInterval:timeDown identifier:identifier userInfo:userInfo repeats:NO sound:musicStr];
        }
    }
}
#pragma mark - 获取应该显示的图片
- (UIImage *)getStatusImage {
    NSString *imageString = @"";
    if (!_prayerModel.checkInFlag.boolValue && _prayerModel.prayDate.integerValue < [NSDate getCurrentStamp]) {
        //错过祈祷
        imageString = [NSString stringWithFormat:@"missed_%@",_prayerModel.prayType];
    } else if (_prayerModel.checkInFlag.boolValue) {
        // 已祈祷
        imageString = [NSString stringWithFormat:@"prayed_%@",_prayerModel.prayType];
    } else if (!_prayerModel.checkInFlag.boolValue && _prayerModel.prayDate.integerValue > [NSDate getCurrentStamp]) {
        // 未到祈祷时间
        imageString = [NSString stringWithFormat:@"unpray_%@",_prayerModel.prayType];
    }
    return kImageName(imageString);
}
@end
