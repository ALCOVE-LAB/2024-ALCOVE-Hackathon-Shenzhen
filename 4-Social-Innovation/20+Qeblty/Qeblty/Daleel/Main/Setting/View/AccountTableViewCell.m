//
//  AccountTableViewCell.m
//  Daleel
//
//  Created by mac on 2024/3/30.
//

#import "AccountTableViewCell.h"

@interface AccountTableViewCell ()

@property(nonatomic,strong)UIImageView *arrowImageV;

@end

@implementation AccountTableViewCell

- (void)setupViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.imageV];
    [self.contentView addSubview:self.arrowImageV];
    [self.contentView addSubview:self.bindLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(37);
        make.centerY.mas_equalTo(0);
    }];
    [self.arrowImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-37);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(5, 11));
    }];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.arrowImageV.mas_leading).offset(-12);
        make.width.height.mas_equalTo(28);
        make.centerY.mas_equalTo(0);
    }];
    [self.bindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.arrowImageV.mas_leading).offset(-12);
        make.centerY.equalTo(self.imageV.mas_centerY);
    }];
}

#pragma mark - lazy load
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTextFont:kFontRegular(16) textColor:RGB(0x1B1B1B)];
    }
    return _titleLabel;
}

- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
    }
    return _imageV;
}
- (UIImageView *)arrowImageV {
    if (!_arrowImageV) {
        _arrowImageV = [[UIImageView alloc] initWithImage:kImageName(@"profile_setting_arrow")];
        if ([LanguageTool isArabic]) {
            _arrowImageV.transform = CGAffineTransformRotate(_arrowImageV.transform, M_PI);
        }
    }
    return _arrowImageV;
}

- (UILabel *)bindLabel {
    if (!_bindLabel) {
        _bindLabel = [UILabel labelWithTextFont:kFontRegular(16) textColor:[UIColor colorWithHexString:@"#666666"]];
        _bindLabel.text = kLocalize(@"account_binding");
        _bindLabel.hidden = YES;
    }
    return _bindLabel;
}

@end
