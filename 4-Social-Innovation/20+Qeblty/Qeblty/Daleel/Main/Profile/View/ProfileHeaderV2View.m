//
//  ProfileHeaderV2View.m
//  Daleel
//
//  Created by mac on 2024/3/31.
//

#import "ProfileHeaderV2View.h"

@interface ProfileHeaderV2View ()

/// 头像
@property (nonatomic,strong)UIImageView *iconImgView;
/// 昵称
@property (nonatomic,strong)UILabel *nameLB;
/// 用户id
@property (nonatomic,strong)UILabel *IDLB;
/// 简介
@property (nonatomic,strong)UILabel *discribeLB;
/// 游客模式登录按钮
@property (nonatomic,strong)UIButton *signBtn;
/// 勋章图标
@property (nonatomic,strong)UIImageView *badageImgv;
/// ustaz认证标识
@property (nonatomic,strong)UIImageView *ustazAuthImageView;

@property (nonatomic, strong) UIImageView *pointBgView;

@property (nonatomic, strong) UIImageView *pointIconView;

@property (nonatomic, strong) UILabel *pointTitleLabel;

@property (nonatomic, strong) UILabel *pointLabel;

@property (nonatomic, strong) UIImageView *arrowImageView;


@end

@implementation ProfileHeaderV2View

- (void)setupViews {
    [self addSubview:self.iconImgView];
    [self addSubview:self.ustazAuthImageView];
    [self addSubview:self.nameLB];
    [self addSubview:self.IDLB];
    [self addSubview:self.discribeLB];
    [self addSubview:self.signBtn];
    [self addSubview:self.badageImgv];
    [self addSubview:self.pointBgView];
    [self.pointBgView addSubview:self.pointTitleLabel];
    [self.pointBgView addSubview:self.pointIconView];
    [self.pointBgView addSubview:self.pointLabel];
    [self.pointBgView addSubview:self.arrowImageView];
    
    self.model = kUser.userInfo;
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(17);
        make.top.mas_equalTo(25);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.ustazAuthImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.equalTo(self.iconImgView);
    }];
    
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(20);
        make.top.equalTo(self.iconImgView);
    }];
    
    [self.IDLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLB);
        make.top.equalTo(self.nameLB.mas_bottom).offset(12);
    }];
    
    [self.discribeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(17);
        make.trailing.mas_equalTo(17);
        make.top.equalTo(self.iconImgView.mas_bottom).offset(20);
    }];
    
    [self.signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLB);
        make.top.equalTo(self.nameLB.mas_bottom).offset(6);
        make.size.mas_offset(CGSizeMake(85, 24));
    }];
    
    [self.badageImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.leading.equalTo(self.nameLB.mas_trailing).offset(5);
        make.centerY.equalTo(self.nameLB);
    }];
    
    [self.pointBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.discribeLB.mas_bottom).offset(20);
        make.leading.mas_equalTo(17);
        make.trailing.mas_equalTo(-17);
    }];
    
    [self.pointIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pointBgView);
        make.leading.mas_equalTo(14);
    }];
    
    [self.pointTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pointBgView);
        make.leading.equalTo(self.pointIconView.mas_trailing).offset(10);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-20);
        make.centerY.equalTo(self.pointBgView);
    }];
    
    [self.pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pointBgView);
        make.trailing.mas_equalTo(self.arrowImageView.mas_leading).offset(-12);
    }];
    
}



#pragma mark -- lazyLoad
- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImgView.layer.cornerRadius = 30.f;
        _iconImgView.layer.masksToBounds = YES;
        _iconImgView.userInteractionEnabled = YES;
        @weakify(self)
        [_iconImgView addTapAction:^{
         @strongify(self)
            ExecBlock(self.editProfileAction);
        }];
    }
    return _iconImgView;
}

- (UILabel *)nameLB {
    if (!_nameLB) {
        _nameLB = [UILabel labelWithTextFont:kFontMedium(24) textColor:[UIColor colorWithHexString:@"#1b1b1b"] text:kUserModel.nickName];
    }
    return _nameLB;
}

- (UILabel *)IDLB {
    if (!_IDLB) {
        _IDLB = [UILabel labelWithTextFont:kFontRegular(12) textColor:[UIColor colorWithHexString:@"#999999"] text:[NSString stringWithFormat:@"ID: %@",kUserModel.userId]];
    }
    return _IDLB;
}

- (UILabel *)discribeLB {
    if (!_discribeLB) {
        _discribeLB = [UILabel labelWithTextFont:kFontRegular(14) textColor:[UIColor colorWithHexString:@"#666666"] text:kUserModel.introduction];
        _discribeLB.numberOfLines = 0;
    }
    return _discribeLB;
}

- (UIButton *)signBtn {
    if(!_signBtn){
        _signBtn = [[UIButton alloc] init];
        [_signBtn setTitle:kLocalize(@"prayer_sign_in") forState:UIControlStateNormal];
        [_signBtn setTitleColor:RGB(0xD9A53E) forState:UIControlStateNormal];
        _signBtn.titleLabel.font = kFontMedium(11);
        _signBtn.backgroundColor = RGB(0xFDF9F1);
        _signBtn.layer.cornerRadius = 12.f;
        _signBtn.layer.borderWidth = 1.f;
        _signBtn.layer.borderColor = RGB(0xD9A53E).CGColor;
        _signBtn.hidden = YES;
        @weakify(self)
    }
    return _signBtn;
}

- (UIImageView *)badageImgv {
    if (!_badageImgv) {
        _badageImgv = [[UIImageView alloc] init];
        _badageImgv.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _badageImgv;
}
- (UIImageView *)ustazAuthImageView {
    if (!_ustazAuthImageView) {
        _ustazAuthImageView = [[UIImageView alloc] initWithImage:kImageName(@"ustaz_auth_icon_big")];
    }
    return _ustazAuthImageView;
}

- (UIImageView *)pointBgView {
    if (!_pointBgView) {
        _pointBgView = [[UIImageView alloc] initWithImage:kImageName(@"point_bg")];
        _pointBgView.userInteractionEnabled = YES;
        @weakify(self);
        [_pointBgView addTapAction:^{
            @strongify(self);
            ExecBlock(self.ClickedPointsBlock);
        }];
    }
    return _pointBgView;
}

- (UIImageView *)pointIconView {
    if (!_pointIconView) {
        _pointIconView = [[UIImageView alloc] initWithImage:kImageName(@"point_icon")];
    }
    return _pointIconView;
}
- (UILabel *)pointTitleLabel {
    if (!_pointTitleLabel) {
        _pointTitleLabel = [UILabel labelWithTextFont:kFontMedium(16) textColor:RGB(0x724700) text:kLocalize(@"about_points")];
    }
    return _pointTitleLabel;
}
- (UILabel *)pointLabel {
    if (!_pointLabel) {
        _pointLabel = [UILabel labelWithTextFont:kFontRegular(16) textColor:RGB(0x724700)];
    }
    return _pointLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:kImageName(@"profile_setting_arrow")];
    }
    return _arrowImageView;
}


- (void)setModel:(UserModel *)model {
    _model = model;
    [self.iconImgView loadImgUrl:model.headUrl placeholderImg:@"avatar_default"];
    self.nameLB.text = model.nickName;
    self.IDLB.text = [NSString stringWithFormat:@"ID: %@",model.userId];
    self.discribeLB.text = model.introduction.length ? model.introduction : kLocalize(@"writed_nothing");
    [self.badageImgv loadImgUrl:model.awardUrl];
    self.pointLabel.text = [NSString stringWithFormat:@"%ld",model.points];
    
    // 计算并更新self frame大小
    CGSize baseSize = CGSizeMake(kScreenWidth - 34, CGFLOAT_MAX);
    CGSize labelsize  = [model.introduction
                        boundingRectWithSize:baseSize
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}
                        context:nil].size;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.width, 122 + 20 + 56 + labelsize.height);
    
    BOOL isGuest = kUser.userInfo.touristFlag;
    if (isGuest) {
        [self.iconImgView setImage:kImageName(@"profile_tourist_holder")];
        self.nameLB.text = kLocalize(@"welcome_to_qeblty");
        self.discribeLB.hidden = YES;
        self.IDLB.hidden = YES;
        self.signBtn.hidden = NO;
    }else {
        self.discribeLB.hidden = NO;
        self.IDLB.hidden = NO;
        self.signBtn.hidden = YES;
    }

    self.ustazAuthImageView.hidden = model.authInfoList.count == 0;
}


@end
