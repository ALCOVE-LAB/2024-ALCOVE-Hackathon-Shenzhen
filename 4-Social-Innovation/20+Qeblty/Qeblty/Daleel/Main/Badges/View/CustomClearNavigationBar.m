//
//  CustomClearNavigationBar.m
//  Daleel
//
//  Created by mac on 2024/3/30.
//

#import "CustomClearNavigationBar.h"


@interface CustomClearNavigationBar ()

@property (nonatomic, strong) UIView *navigationBar;




@end

@implementation CustomClearNavigationBar

- (void)initialize {
    self.backgroundColor = kClearColor;
}
- (void)setupViews {
    [self addSubview:self.navigationBar];
    [self.navigationBar addSubview:self.backButton];
    [self.navigationBar addSubview:self.recordButton];
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.equalTo(self.navigationBar);
        make.width.mas_equalTo(44 + 34);
    }];
    
    CGSize titleSize = [self automaticallyAdaptToHighly:kFontMedium(14) targetString:self.recordButton.titleLabel.text];
    [self.recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backButton);
        make.trailing.mas_equalTo(-16);
        make.width.mas_offset(titleSize.width + 25);
    }];
    
}

- (UIView *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[UIView alloc] init];
        _navigationBar.backgroundColor = kClearColor;
    }
    return _navigationBar;
}
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        UIImage *backOrgImg = [UIImage imageNamed:@"icon_back_b"];
        [_backButton setImage:backOrgImg forState:UIControlStateNormal];
        if ([LanguageTool isArabic]) { /// 阿语处理
            _backButton.imageView.transform = CGAffineTransformRotate(_backButton.imageView.transform, M_PI);
        }
    }
    return _backButton;
}
- (UIButton *)recordButton {
    if (!_recordButton) {
        _recordButton = [UIButton buttonWithTitleFont:kFontSemibold(14) titleColor:RGB(0x1b1b1b) title:kLocalize(@"medal_records") image:kImageName(@"record_btn")];
        _recordButton.imageEdgeInsets = UIEdgeInsetsMake(0, -2.5, 0, 2.5);
        _recordButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2.5, 0, -2.5);
        if (kIsAR) {
            _recordButton.imageEdgeInsets = UIEdgeInsetsMake(0, 3, 0, -3);
            _recordButton.titleEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 3);
        }
        [_recordButton sizeToFit];
        [_recordButton setTitle:kLocalize(@"medal_records") forState:UIControlStateNormal];
    }
    return _recordButton;
}
@end
