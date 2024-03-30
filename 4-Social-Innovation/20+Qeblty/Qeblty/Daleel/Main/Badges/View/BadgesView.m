//
//  BadgesView.m
//  Daleel
//
//  Created by mac on 2024/3/30.
//

#import "BadgesView.h"

@interface BadgesView ()

@property (nonatomic, strong) UILabel *prayerLabel;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation BadgesView

- (void)initialize {
    [super initialize];
    self.backgroundColor = RGB(0xF8F8F8);
    self.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    self.layer.cornerRadius = 16;
}
- (void)setupViews {
    [self addSubview:self.prayerLabel];
    [self addSubview:self.lineView];
    
    [self.prayerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18, 4));
        make.centerX.equalTo(self.prayerLabel);
        make.top.equalTo(self.prayerLabel.mas_bottom).offset(6);
    }];
}

#pragma mark - lazy load
- (UILabel *)prayerLabel {
    if (!_prayerLabel) {
        _prayerLabel = [UILabel labelWithTextFont:kFontMedium(16) textColor:RGB(0x1b1b1b) text:kLocalize(@"feature_prayer")];
    }
    return _prayerLabel;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGB(0xD4C4A4);
        _lineView.layer.cornerRadius = 2;
    }
    return _lineView;
}
@end
