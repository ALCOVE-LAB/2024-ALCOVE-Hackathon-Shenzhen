//
//  PrayerSetViewCell.m
//  Daleel
//
//  Created by mac on 2024/3/30.
//

#import "PrayerSetViewCell.h"
#import "PrayerModel.h"

@interface PrayerSetViewCell ()

@property (nonatomic,strong)UILabel *prayerLB;
@property (nonatomic,strong)UILabel *prayerTimeLB;
@property (nonatomic,strong)UILabel *ringNameLB;
@property (nonatomic,strong)UIImageView *rightArrowImg;

@end

@implementation PrayerSetViewCell

- (void)initialize {
    [self.contentView addSubview:self.prayerLB];
    [self.contentView addSubview:self.prayerTimeLB];
    [self.contentView addSubview:self.ringNameLB];
    [self.contentView addSubview:self.rightArrowImg];
    
    [self.prayerLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(40);
        make.top.mas_equalTo(20);
    }];
    [self.prayerTimeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.prayerLB);
        make.top.equalTo(self.prayerLB.mas_bottom).offset(10);
    }];
    [self.rightArrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-40);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(5, 11));
    }];
    [self.ringNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.rightArrowImg.mas_leading).offset(-10);
        make.centerY.equalTo(self.rightArrowImg);
    }];
}

#pragma mark --UI处理=============================================================
- (UILabel *)prayerLB {
    if(!_prayerLB){
        _prayerLB = [UILabel labelWithTextFont:kFontMedium(16) textColor:RGB(0x1b1b1b) text:@"PrayerType"];
    }
    return _prayerLB;
}

- (UILabel *)prayerTimeLB {
    if(!_prayerTimeLB){
        _prayerTimeLB = [UILabel labelWithTextFont:kFontRegular(14) textColor:RGB(0x999999) text:@"Remind on Time"];
    }
    return _prayerTimeLB;
}

- (UILabel *)ringNameLB {
    if(!_ringNameLB){
        _ringNameLB = [UILabel labelWithTextFont:kFontRegular(16) textColor:RGB(0x666666) text:@"Ring Name"];
    }
    return _ringNameLB;
}

- (UIImageView *)rightArrowImg {
    if(!_rightArrowImg){
        _rightArrowImg = [[UIImageView alloc] initWithImage:kImageName(@"prayer_remindArrow")];
        if ([LanguageTool isArabic]) {
            _rightArrowImg.transform = CGAffineTransformRotate(_rightArrowImg.transform, M_PI);
        }
    }
    return _rightArrowImg;
}

#pragma mark --数据处理区域=============================================================

- (void)setPrayerModel:(PrayerModel *)prayerModel {
    _prayerModel = prayerModel;
    if (prayerModel) {
        self.prayerLB.text = kLocalize(prayerModel.prayType.lowercaseString);
        self.prayerTimeLB.text = [self dl_getModelReturnShowTimeStr:prayerModel];
        self.ringNameLB.text = prayerModel.ringingName;
    }
}

- (NSString *)dl_getModelReturnShowTimeStr:(PrayerModel *)prayerModel {
   NSString *showStr;
    if (prayerModel.remindType.integerValue == 0) {
        showStr = kLocalize(@"remind_on_time");
    }else if (prayerModel.remindType.integerValue > 0) {
        showStr = [NSString stringWithFormat:kLocalize(@"minutes_ahead_remind"),prayerModel.remindType.integerValue];
        if (prayerModel.remindType.integerValue > 11) {
            showStr = [NSString stringWithFormat:kLocalize(@"minutes_ahead_remind_more"),prayerModel.remindType.integerValue];
        }
    }else{
        showStr = [NSString stringWithFormat:kLocalize(@"minutes_delay_remind"),labs(prayerModel.remindType.integerValue)];
        if (labs(prayerModel.remindType.integerValue) > 11) {
            showStr = [NSString stringWithFormat:kLocalize(@"minutes_delay_remind_more"),labs(prayerModel.remindType.integerValue)];
        }
    }
   return showStr;
}

@end
