//
//  SettingCell.m
//  UISettingView
//
//  Created by mac on 2024/3/30.
//

#import "SettingCell.h"

#define SettingCell_ID @"SettingCell_ID"

@interface SettingCell ()

@property (nonatomic,strong)UIView  *backView;
@property (nonatomic,strong)UIView  *lineV;

@property (nonatomic,strong)UIImageView  *imgView;
@property (nonatomic,strong)UILabel  *titleLB;;
@property (nonatomic,strong)UIImageView  *rightArrow;
@property (nonatomic,strong)UILabel *languageLB;

@end

@implementation SettingCell


#pragma mark -- UI处理
- (void)setupViews {
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.imgView];
    [self.backView addSubview:self.titleLB];
    [self.backView addSubview:self.rightArrow];
    [self.backView addSubview:self.languageLB];
    [self.backView addSubview:self.lineV];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(17);
        make.trailing.mas_equalTo(-17);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(14);
        make.top.mas_equalTo(14);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.imgView.mas_trailing).offset(10);
        make.centerY.equalTo(self.imgView);
    }];
    
    [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-20);
        make.centerY.equalTo(self.titleLB);
        make.size.mas_equalTo(CGSizeMake(5, 11));
    }];
    
    [self.languageLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.rightArrow.mas_leading).offset(-12);
        make.centerY.equalTo(self.rightArrow);
    }];
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(52);
        make.trailing.mas_equalTo(-20);
        make.bottom.mas_equalTo(-1);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark --是否切圆角  用isRadiusTeger 判断切圆角  0是上面圆角  1是下面圆角  2是全切
- (void)setIsRadiusTeger:(NSInteger)isRadiusTeger {
    _isRadiusTeger = isRadiusTeger;
    [self dl_cellRadius:self.backView andWithRadiusTeger:isRadiusTeger];
}

#pragma mark -- 图片展示
- (void)setImgStr:(NSString *)imgStr {
    _imgStr = imgStr;
    [self.imgView setImage:[UIImage imageNamed:imgStr]];
}

#pragma mark -- title名称
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLB.text = title;
}

#pragma mark --展示语言后面
-(void)setIsShowLanguage:(BOOL)isShowLanguage {
    _isShowLanguage = isShowLanguage;
    self.languageLB.hidden = !isShowLanguage;
}

- (UIView *)backView {
    if(!_backView){
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = kWhiteColor;
    }
    return _backView;
}

- (UIImageView *)imgView {
    if(!_imgView){
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

- (UILabel *)titleLB {
    if(!_titleLB){
        _titleLB = [UILabel labelWithTextFont:kFontRegular(16) textColor:RGB(0x1b1b1b)];
    }
    return _titleLB;
}

- (UIImageView *)rightArrow {
    if(!_rightArrow){
        _rightArrow = [[UIImageView alloc] init];
        [_rightArrow setImage:kImageName(@"profile_setting_arrow")];
        if ([LanguageTool isArabic]) {
            _rightArrow.transform = CGAffineTransformRotate(_rightArrow.transform, M_PI);
        }
    }
    return _rightArrow;
}

- (UILabel *)languageLB {
    if(!_languageLB){
        _languageLB = [UILabel labelWithTextFont:kFontRegular(16) textColor:RGB(0x666666) text:[self currentLanguageTitle]];
    }
    return _languageLB;
}

- (UIView *)lineV {
    if(!_lineV){
        _lineV = [[UIView alloc] init];
        _lineV.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    }
    return _lineV;
}

#pragma mark -- 切部分圆角方法
- (void)dl_cellRadius:(UIView *)radiusView andWithRadiusTeger:(NSInteger )radiusTeger {
    CGRect rect = CGRectMake(0, 0, kScreenWidth - 34, 56.f);
    UIBezierPath *maskPath = [self dl_getRadiusTeger:radiusTeger andWithRect:rect];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = rect;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    radiusView.layer.mask = maskLayer;
}

#pragma mark -- UIBezierPath 方法抽取
- (UIBezierPath *)dl_getRadiusTeger:(NSInteger )radiusTeger andWithRect:(CGRect )rect{
    if(radiusTeger == 0){
        self.lineV.hidden = NO;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12.f, 12.f)];
        return maskPath;
    }else if (radiusTeger == 1){
        self.lineV.hidden = YES;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(12.f, 12.f)];
        return maskPath;
    }else if (radiusTeger == 2){
        self.lineV.hidden = YES;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight  cornerRadii:CGSizeMake(12.f, 12.f)];
        return maskPath;
    }else{
        self.lineV.hidden = NO;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(0.f, 0.f)];
        return maskPath;
    }
}

- (NSString *)currentLanguageTitle {
  if ([[LanguageTool currentLanguageName] containsString:@"ar"]) {
    return @"عربي";
  }else {
    return @"English";
  }
}

@end
