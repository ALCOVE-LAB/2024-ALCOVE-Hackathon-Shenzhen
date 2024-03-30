//
//  BaseView.m
//  Gamfun
//
//  Created by mac on 2022/7/3.
//

#import "BaseView.h"

@interface BaseView ()

@property(nonatomic,strong)UIImageView *bgImageV;
@end

@implementation BaseView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
        [self setupViews];
        [self requestData];
    }
    
    return self;
}
- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
        [self setupViews];
        [self requestData];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
        [self setupViews];
        [self requestData];
    }
    return self;
}

- (void)initialize {
    self.backgroundColor = kPublicBgColor;
}

- (void)setupViews {}

- (void)requestData {}

- (void)showImageBg {
    [self addSubview:self.bgImageV];
    [self.bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (UIImageView *)bgImageV {
    if (!_bgImageV) {
        _bgImageV = [[UIImageView alloc] initWithImage:kImageName(@"login_bg")];
        _bgImageV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageV;
}


@end
