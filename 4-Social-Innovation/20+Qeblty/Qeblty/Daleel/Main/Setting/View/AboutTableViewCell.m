//
//  AboutTableViewCell.m
//  Daleel
//
//  Created by mac on 2024/3/30.
//

#import "AboutTableViewCell.h"

@implementation AboutTableViewCell

- (void)setupViews {
    [self.contentView addSubview:self.leftLB];
    [self.contentView addSubview:self.rightArrowImg];
    
    [self.leftLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(37);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.rightArrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-37);
        make.centerY.equalTo(self.leftLB);
        make.size.mas_equalTo(CGSizeMake(5, 11));
    }];
}

- (UILabel *)leftLB {
    if(!_leftLB){
        _leftLB = [UILabel labelWithTextFont:kFont(16) textColor:[UIColor colorWithHexString:@"1b1b1b"] text:kLocalize(@"about_service")];
    }
    return _leftLB;
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

@end
