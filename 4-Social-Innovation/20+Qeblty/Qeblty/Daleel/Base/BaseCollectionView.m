//
//  BaseCollectionView.m
//  Gamfun
//
//  Created by mac on 2022/8/7.
//

#import "BaseCollectionView.h"

@interface BaseCollectionView ()

@property(nonatomic,strong)UIView *coverView;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *btn;

@end

@implementation BaseCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.backgroundColor = kPublicBgColor;
    self.dataSource = self;
    self.delegate = self;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

#pragma mark - UICollectionViewDataSource UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataArr.count > 0) {
        [self removeNodataView];
    }
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.didClickCellSubject sendNext:indexPath];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    ExecBlock(self.scrollOffsetBlock,scrollView.contentOffset);
}

#pragma mark - lazy
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (RACSubject *)didClickCellSubject {
    if (!_didClickCellSubject) {
        _didClickCellSubject = [RACSubject subject];
    }
    return _didClickCellSubject;
}
- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _coverView.backgroundColor = kPublicBgColor;
    }
    return _coverView;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:kImageName(@"icon_nodata")];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTextFont:kFontMedium(16) textColor:RGB(0xE1CEFF)];
    }
    return _titleLabel;
}
- (UIButton *)btn {
    if (!_btn) {
        _btn = [UIButton buttonWithTitleFont:kFontSemibold(17) titleColor:kWhiteColor];
        [_btn setBackgroundImage:kImageName(@"icon_btn_bg") forState:UIControlStateNormal];
        @weakify(self)
        [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            ExecBlock(self.moreBtnBlock);
        }];
    }
    return _btn;
}

- (void)creatNodataViewWithImageName:(NSString *_Nullable)imageName title:(NSString *)title withBtn:(NSString *_Nullable)btnStr {
    [self addSubview:self.coverView];
    [self.coverView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.equalTo(self.mas_centerY).offset(-20);
        make.width.height.mas_equalTo(120);
    }];
    if (title) {
        [self.coverView addSubview:self.titleLabel];
        self.titleLabel.text = title;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.imageView.mas_bottom).offset(15);
        }];
    }
    if (btnStr) {
        [self.coverView addSubview:self.btn];
        [self.btn setTitle:btnStr forState:UIControlStateNormal];
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(170);
            make.height.mas_equalTo(46);
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.imageView.mas_bottom).offset(100);
        }];
    }
    if (imageName) {
        self.imageView.image = kImageName(imageName);
    }
}
- (void)removeNodataView {
    if (_coverView) {
        [_coverView removeFromSuperview];
        _coverView = nil;
    }
}

@end
