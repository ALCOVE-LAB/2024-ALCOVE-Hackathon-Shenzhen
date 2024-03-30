//
//  PrayerLocationTipView.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "PrayerLocationTipView.h"
#import "PrayerModel.h"

@interface PrayerLocationTipView ()

@property (nonatomic,strong)UIView  *maskView;
@property (nonatomic,strong)UIView  *tipBgView;

@property (nonatomic,strong)UIImageView *tipsImg;

@property (nonatomic,strong)UILabel *tipLB;
@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic,strong)UIButton *setBtn;

@end

@implementation PrayerLocationTipView

#pragma mark --UI处理=============================================================
- (void)setupViews {
    
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self addSubview:self.tipBgView];
    [self.tipBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(23);
        make.trailing.mas_equalTo(-23);
        make.centerY.mas_equalTo(-40);
        make.height.mas_equalTo(250);
    }];
}

- (UIView *)maskView {
    if(!_maskView){
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.4];
    }
    return _maskView;
}

- (UIView *)tipBgView {
    if(!_tipBgView){
        _tipBgView = [[UIView alloc] init];
        _tipBgView.backgroundColor = UIColor.whiteColor;
        _tipBgView.layer.cornerRadius = 16.f;
        _tipBgView.layer.masksToBounds = YES;
        
        [_tipBgView addSubview:self.tipsImg];
        [_tipBgView addSubview:self.tipLB];
        [_tipBgView addSubview:self.setBtn];
        [_tipBgView addSubview:self.cancelBtn];
        
        [self.tipsImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_offset(0);
            make.top.mas_offset(24);
            make.size.mas_offset(CGSizeMake(46, 46));
        }];
        [self.tipLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(30);
            make.trailing.mas_equalTo(-30);
            make.top.equalTo(self.tipsImg.mas_bottom).offset(17);
        }];
        [self.setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_offset(0);
            make.top.equalTo(self.tipLB.mas_bottom).offset(15);
        }];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.top.equalTo(self.setBtn.mas_bottom).offset(7);
            make.trailing.mas_equalTo(0);
        }];
    }
    return _tipBgView;
}

- (UIImageView *)tipsImg {
    if(!_tipsImg){
        _tipsImg = [[UIImageView alloc] initWithImage:kImageName(@"question_back_tips")];
        [_tipsImg sizeToFit];
    }
    return _tipsImg;
}

- (UILabel *)tipLB {
    if(!_tipLB){
        _tipLB = [UILabel labelWithTextFont:kFont(16) textColor:UIColor.blackColor text:kLocalize(@"set_location_tip")];
        _tipLB.textAlignment = NSTextAlignmentCenter;
        _tipLB.numberOfLines = 0;
    }
    return _tipLB;
}

- (UIButton *)cancelBtn {
    if(!_cancelBtn){
        _cancelBtn = [UIButton buttonWithTitleFont:kFontRegular(18) titleColor:[UIColor colorWithHexString:@"#999999"] title:kLocalize(@"cancel")];
        _cancelBtn.tag = LocationTipCancle;
        [_cancelBtn addTarget:self action:@selector(dl_locationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)setBtn {
    if(!_setBtn){
        _setBtn = [UIButton buttonWithTitleFont:kFontSemibold(18) titleColor:RGB(0xFFF7D6) title:kLocalize(@"to_set")];
        [_setBtn setBackgroundImage:kImageName(@"question_splinter_shareBg") forState:UIControlStateNormal];
        _setBtn.tag = LocationTipToSet;
        [_setBtn addTarget:self action:@selector(dl_locationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setBtn;
}

#pragma mark --点击位置提示按钮
- (void)dl_locationBtnClick:(UIButton *)sender {
    if (self.locationTipClickBlock) {
        self.locationTipClickBlock(sender);
    }
}

@end
