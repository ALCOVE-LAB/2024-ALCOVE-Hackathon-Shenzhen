//
//  ProfileSectionHeaderView.m
//  Daleel
//
//  Created by mac on 2024/3/31.
//

#import "ProfileSectionHeaderView.h"

@interface ProfileSectionHeaderView ()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *rightLabel;

@end

@implementation ProfileSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UILabel *titleLabel = [UILabel labelWithTextColor:[UIColor colorWithHexString:@"#1B1B1B"] boldFont:20 text:@"" superView:self.contentView];
    _titleLabel = titleLabel;
    
    UILabel *rightLabel = [UILabel labelWithTextColor:[UIColor colorWithHexString:@"#D9A53E"] font:16 text:@"" superView:self.contentView];
    rightLabel.textAlignment = NSTextAlignmentRight;
    _rightLabel = rightLabel;
    @weakify(self);
    [rightLabel addTapAction:^{
        @strongify(self);
        ExecBlock(self.rightBtnClick);
    }];
    
    UIImageView *rightImgv = [UIImageView imgViewWithImg:@"question_date_arrow" superView:self.contentView];
    if (kIsAR) {
        rightImgv.transform = CGAffineTransformRotate(rightImgv.transform, M_PI);
    }
    
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel);
        make.trailing.equalTo(rightImgv.mas_leading).offset(-8);
//        make.size.mas_equalTo(CGSizeMake(200, 18));
    }];
    
    [rightImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView.mas_trailing).offset(0);
        make.centerY.equalTo(titleLabel);
        make.size.mas_equalTo(CGSizeMake(5, 11));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.leading.equalTo(self.contentView.mas_leading).offset(0);
    }];
}

- (void)setTitle:(NSString *)title rightBtnTitle:(NSString *)btnTitle {
    _titleLabel.text = title;
    _rightLabel.text = btnTitle;
}

@end
