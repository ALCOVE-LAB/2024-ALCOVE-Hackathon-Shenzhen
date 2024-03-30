//
//  EditProfileCell.m
//  Daleel
//
//  Created by mac on 2024/3/31.
//

#import "EditProfileCell.h"

@interface EditProfileCell ()

@end

@implementation EditProfileCell

#pragma mark -- UI处理
- (void)setupViews {
    [self.contentView addSubview:self.leftLB];
    [self.contentView addSubview:self.rightArrowImg];
    [self.contentView addSubview:self.discrbLB];
    [self.contentView addSubview:self.lineV];
    
    [self.leftLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.rightArrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-20);
        make.centerY.equalTo(self.leftLB);
        make.size.mas_equalTo(CGSizeMake(5, 11));
    }];
    
    [self.discrbLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.rightArrowImg.mas_leading).offset(-12);
        make.centerY.equalTo(self.rightArrowImg);
        make.width.mas_equalTo(150);
    }];
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.leftLB);
        make.trailing.equalTo(self.rightArrowImg.mas_trailing);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setIsHiddenLineV:(BOOL)isHiddenLineV {
    _isHiddenLineV = isHiddenLineV;
    self.lineV.hidden = isHiddenLineV;
}

- (UILabel *)leftLB {
    if(!_leftLB){
        _leftLB = [UILabel labelWithTextFont:kFont(16) textColor:[UIColor colorWithHexString:@"1b1b1b"]];
    }
    return _leftLB;
}

- (UILabel *)discrbLB {
    if(!_discrbLB){
        _discrbLB = [UILabel labelWithTextFont:kFont(16) textColor:RGB(0x666666)];
        _discrbLB.textAlignment = NSTextAlignmentRight;
    }
    return _discrbLB;
}

- (UIImageView *)rightArrowImg {
    if(!_rightArrowImg){
        _rightArrowImg = [[UIImageView alloc] initWithImage:kImageName(@"profile_setting_arrow")];
        if ([LanguageTool isArabic]) {
            _rightArrowImg.transform = CGAffineTransformRotate(_rightArrowImg.transform, M_PI);
        }
        
    }
    return _rightArrowImg;
}

- (UIView *)lineV {
    if(!_lineV){
        _lineV = [[UIView alloc] init];
        _lineV.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _lineV;
}

@end
