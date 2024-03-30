//
//  AlertTool.m
//  Daleel
//
//  Created by mac on 2022/12/16.
//

#import "AlertTool.h"

@interface AlertTool ()

@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *btnTitle;
@property(nonatomic,copy)NSString *imageStr;
@property(nonatomic,assign)BOOL isForce;

@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIButton *closeBtn;
@property(nonatomic,strong)UIButton *confirmBtn;
@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,copy)btnClickBlock btnBlock;

@property(nonatomic,assign)CGFloat height;
@end

@implementation AlertTool

- (void)initialize {
    self.backgroundColor = RGB_ALPHA(0x000000, 0.4);
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (instancetype)initUpdateViewWithTitle:(NSString *)title content:(NSString *)content forceUpdate:(BOOL)isForce btnTitle:(NSString *)btnTitle btnClick:(btnClickBlock)btnClick {
    if (self = [super init]) {
        self.title = title;
        self.content = content;
        self.isForce = isForce;
        self.btnTitle = btnTitle;
        self.btnBlock = btnClick;
        [self creatUpdateUI];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message image:(NSString *_Nullable)imageStr btnTitle:(NSString *_Nullable)btnTitle btnClick:(nullable btnClickBlock)btnClick {
    if (self = [super init]) {
        self.title = title;
        self.content = message;
        self.btnTitle = btnTitle;
        self.btnBlock = btnClick;
        self.imageStr = imageStr;
        [self setupUI];
    }
    return self;
}

/// 视图更新弹窗
- (void)creatUpdateUI {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.confirmBtn];
    [self.contentView addSubview:self.closeBtn];
    if (self.title.length > 0) {
        [self.contentView addSubview:self.titleLabel];
    }
    if (self.content.length > 0) {
        [self.contentView addSubview:self.contentLabel];
    }
    
    self.titleLabel.text = self.title;
    self.contentLabel.text = self.content;
    [self.confirmBtn setTitle:self.btnTitle forState:UIControlStateNormal];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kScreenWidth-150)/2);
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-30);
        make.height.mas_equalTo(50);
    }];
    UIImageView *updateImageV = [[UIImageView alloc] initWithImage:kImageName(@"update")];
    updateImageV.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:updateImageV];
    [updateImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(-24);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenWidth/2.67));
    }];
    
    self.titleLabel.font = kFontSemibold(22);
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    CGSize titleSize = CGSizeZero;
    CGSize messageSize = CGSizeZero;
    if (self.title.length > 0) {
        titleSize = [NSString sizeForString:self.title font:kFontSemibold(22) maxWidth:(kScreenWidth-80)];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.mas_equalTo(30);
            make.trailing.mas_equalTo(-30);
            make.height.mas_equalTo(titleSize.height);
        }];
        
        if (self.content.length > 0) {
            messageSize = [NSString sizeForString:self.content font:kFontRegular(14) maxWidth:(kScreenWidth-160)];
            [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(30);
                make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(30);
                make.trailing.mas_equalTo(-30);
                make.height.mas_equalTo(messageSize.height + 5);
            }];
        }
    }else {
        if (self.content.length > 0) {
            messageSize = [NSString sizeForString:self.content font:kFontRegular(14) maxWidth:(kScreenWidth-160)];
            [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.top.mas_equalTo(30);
                make.trailing.mas_equalTo(-30);
                make.height.mas_equalTo(messageSize.height + 5);
            }];
        }
    }
    
    CGFloat h = 0;
    if (self.title.length > 0 && self.content.length > 0) {
        h = 30 + titleSize.height + 30 + messageSize.height + 30 + 50 + 30 + 24;
    }else {
        h = 30 + titleSize.height + messageSize.height + 30 + 50 + 30 + 24;
    }
    self.height = h;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(h);
        make.top.mas_equalTo(self.mas_bottom);
    }];
}

- (void)setupUI {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.confirmBtn];
    [self.contentView addSubview:self.closeBtn];
    if (self.title.length > 0) {
        [self.contentView addSubview:self.titleLabel];
    }
    if (self.content.length > 0) {
        [self.contentView addSubview:self.contentLabel];
    }
    if (self.imageStr.length > 0) {
        [self.contentView addSubview:self.imageV];
    }
    self.titleLabel.text = self.title;
    self.contentLabel.text = self.content;
    [self.confirmBtn setTitle:self.btnTitle forState:UIControlStateNormal];
    
    __block UIImage *img;
    if ([self.imageStr hasPrefix:@"http"] || [self.imageStr hasPrefix:@"https"]) {
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:self.imageStr] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            img = image;
        }];
    }else {
        img = kImageName(self.imageStr);
        self.imageV.image = img;
    }
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth-150);
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-30);
        make.height.mas_equalTo(50);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-17);
        make.top.mas_equalTo(17);
        make.width.height.mas_equalTo(32);
    }];
    CGSize titleSize = CGSizeZero;
    CGSize messageSize = CGSizeZero;
//    CGFloat imagW = img.size.width <= 0 ? 150 : img.size.width;
//    CGFloat imagH = img.size.height <= 0 ? 150 : img.size.height;
    CGFloat imagW = 150.f;
    CGFloat imagH = 150.f;
    if (self.title.length > 0) {
        titleSize = [NSString sizeForString:self.title font:kFontSemibold(22) maxWidth:(kScreenWidth-120)];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(60);
            make.trailing.mas_equalTo(-60);
            make.top.mas_equalTo(24);
            make.height.mas_equalTo(titleSize.height);
        }];
        if (self.imageStr.length > 0) {
            [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(18);
                make.centerX.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(imagW, imagH));
            }];
            if (self.content.length > 0) {
                messageSize = [NSString sizeForString:self.content font:kFontRegular(14) maxWidth:(kScreenWidth-150)];
                [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.leading.mas_equalTo(30);
                    make.top.mas_equalTo(self.imageV.mas_bottom).offset(20);
                    make.trailing.mas_equalTo(-30);
                    make.height.mas_equalTo(messageSize.height + 5);
                }];
            }
        }else {
            if (self.content.length > 0) {
                messageSize = [NSString sizeForString:self.content font:kFontRegular(14) maxWidth:(kScreenWidth-150)];
                [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.leading.mas_equalTo(30);
                    make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(20);
                    make.trailing.mas_equalTo(-30);
                    make.height.mas_equalTo(messageSize.height + 5);
                }];
            }
        }
    }else {
        if (self.imageStr.length > 0) {
            [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(60);
                make.centerX.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(imagW, imagH));
            }];
            if (self.content.length > 0) {
                messageSize = [NSString sizeForString:self.content font:kFontRegular(14) maxWidth:(kScreenWidth-150)];
                [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.leading.mas_equalTo(30);
                    make.top.mas_equalTo(self.imageV.mas_bottom).offset(20);
                    make.trailing.mas_equalTo(-30);
                    make.height.mas_equalTo(messageSize.height + 5);
                }];
            }
        }else {
            if (self.content.length > 0) {
                messageSize = [NSString sizeForString:self.content font:kFontRegular(14) maxWidth:(kScreenWidth-150)];
                [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.leading.mas_equalTo(30);
                    make.top.mas_equalTo(70);
                    make.trailing.mas_equalTo(-30);
                    make.height.mas_equalTo(messageSize.height + 5);
                }];
            }
        }
    }
    
    CGFloat h = 24 + titleSize.height + 20 + imagH + 20 + messageSize.height + 26 + 50 + 30;
    if (self.content.length <= 0) {
        h -= (messageSize.height + 26);
    }
    if (self.imageStr.length <= 0) {
        h -= (img.size.height + 20);
    }
    if (self.title.length <= 0) {
        h -= (24 + titleSize.height + 20 - 70);
    }
    self.height = h;
    self.contentView.height = h;
    [self.contentView addTopCornerPath:16];
}


#pragma mark - lazyload
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 310)];
        _contentView.backgroundColor = kWhiteColor;
//        [_contentView addTopCornerPath:16];
    }
    return _contentView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFontSemibold(18);
        _titleLabel.textColor = RGB(0x1B1B1B);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel labelWithTextFont:kFontRegular(14) textColor:RGB(0x666666)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLabel;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithTitleFont:kFontSemibold(18) titleColor:RGB(0xFFF7D6)];
        _confirmBtn.backgroundColor = [UIColor gradientFromColor:RGB(0x514F42) toColor:kBlackColor withWidth:kScreenWidth-150];
        _confirmBtn.layer.cornerRadius = 16;
        @weakify(self)
        [[_confirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self hide];
            ExecBlock(self.btnBlock);
        }];
    }
    return _confirmBtn;
}
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithNormalImage:kImageName(@"common_close") selectedImage:kImageName(@"common_close")];
        @weakify(self)
        [[_closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self hide];
        }];
    }
    return _closeBtn;
}

- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
        _imageV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageV;
}

#pragma mark - public
- (void)show {
    self.tag = 9870;
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    self.frame = [UIScreen mainScreen].bounds;
    [self shakeToShow:self.contentView];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        if (!self.isForce) {
            ExecBlock(self.hideBlock);
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - event
- (void)tapAction {
    [self hide];
}

- (void)shakeToShow:(UIView *)aView {
    [UIView animateWithDuration:0.3 animations:^{
        aView.transform = CGAffineTransformMakeTranslation(0, -self.height);
    }];
}

@end
