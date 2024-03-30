//
//  BaseTableView.m
//  Gamfun
//
//  Created by mac on 2022/7/15.
//

#import "BaseTableView.h"

@interface BaseTableView ()

@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIView *coverView;

@end

@implementation BaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.backgroundColor = kPublicBgColor;
    self.delegate = self;
    self.dataSource = self;
    self.estimatedRowHeight = 44;
    self.rowHeight = UITableViewAutomaticDimension;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.didClickCellSubject sendNext:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    ExecBlock(self.scrollOffsetBlock,scrollView.contentOffset);
}

- (void)creatNodataViewWithImageName:(NSString *)imageName title:(NSString *)title {
    [self addSubview:self.coverView];
    [self.coverView addSubview:self.imageView];
    [self.coverView addSubview:self.titleLabel];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_centerY).offset(-20);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(15);
        make.centerX.mas_equalTo(0);
    }];
    
    if (imageName) {
        self.imageView.image = kImageName(imageName);
    }
    self.titleLabel.text = title;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [self.coverView addGestureRecognizer:tap];
    @weakify(self)
    [tap.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
     @strongify(self)
        ExecBlock(self.nodataTapBlock);
    }];
}

- (void)removeCoverView {
    if (_coverView) {
        [_coverView removeFromSuperview];
        _coverView = nil;
    }
}

#pragma mark - lazy
- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _coverView.backgroundColor = kClearColor;
    }
    return _coverView;
}
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
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:kImageName(@"icon_nodata")];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTextFont:kFontMedium(14) textColor:[UIColor colorWithHexString:@"#999999"]];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

@end
