//
//  BadgesTopView.m
//  Daleel
//
//  Created by mac on 2024/3/30.
//

#import "BadgesTopView.h"
#import "BadgesTopCollectionViewFlowLayout.h"
#import "BadgesTopCollectionViewCell.h"
@interface BadgesTopView () <UICollectionViewDelegate, UICollectionViewDataSource>
/// 背景
@property (nonatomic, strong) UIImageView *backgroundView;
/// 勋章名称
@property (nonatomic, strong) UILabel *badgeNameLabel;
/// 当前佩戴
@property (nonatomic, strong) UIButton *currentWearButton;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, assign) CGFloat dragAtIndex;

@property (nonatomic, assign) CGFloat dragStartX;

@property (nonatomic, assign) CGFloat dragEndX;

@property (nonatomic, assign) NSInteger lastSelectedIndex;

@end

@implementation BadgesTopView

- (void)initialize {
    self.backgroundColor = kWhiteColor;
}
- (void)setupViews {
    [self addSubview:self.backgroundView];
    [self addSubview:self.badgeNameLabel];
    [self addSubview:self.currentWearButton];
    [self addSubview:self.collectionView];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.backgroundView);
        make.height.mas_equalTo(158);
    }];
    
    [self.badgeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView.mas_bottom);
        make.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(22);
        make.bottom.mas_equalTo(-20);
    }];
    CGFloat btnWidth = [self.currentWearButton.titleLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.currentWearButton.titleLabel.font} context:nil].size.width + 12;

    [self.currentWearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(108);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(btnWidth);
        make.centerX.equalTo(self);
    }];
    
}

- (void)setDataList:(NSMutableArray *)dataList {
    _dataList = dataList;
    self.selectedIndex = 0;
    for (int i = 0; i < (dataList.count > 5 ? 5 : dataList.count); i ++) {
        BadgesDetailModel *model = dataList[i];
        if (model.wearingFlag) {
            self.selectedIndex = i;
            self.lastSelectedIndex = i;
        }
    }
    [self.collectionView reloadData];
    if (_dataList.count == 0) {
        // 没有获得勋章
        [self.currentWearButton setTitle:kLocalize(@"go_get_badge") forState:UIControlStateNormal];
        CGFloat btnWidth = [self.currentWearButton.titleLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.currentWearButton.titleLabel.font} context:nil].size.width + 12;
        self.currentWearButton.backgroundColor = RGB(0xFDF9F1);
        [self.currentWearButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(btnWidth);
        }];
        self.badgeNameLabel.text = kLocalize(@"havent_badge");
        self.backgroundView.hidden = YES;
        return;
    }
    [self.collectionView performBatchUpdates:^{
        
    } completion:^(BOOL finished) {
        if (finished) {
            
            // 有获得的勋章
            [self scrollToCenterAnimated:YES];
        }
    }];
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count == 0 ? 1 : (self.dataList.count > 5 ? 5 : self.dataList.count);
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BadgesTopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[BadgesTopCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    cell.imageView.alpha = indexPath.item == self.selectedIndex ? 1 : .5;
    if (self.dataList.count == 0) {
        [cell updateWithCellData:nil];
        return cell;
    }
    cell.model = self.dataList[indexPath.item];
    return cell;
}
- (void)updateSelectedIndex:(NSIndexPath *)indexPath {
    if (indexPath.row != self.selectedIndex) {
        self.selectedIndex = indexPath.row;
    }
}
#pragma mark CollectionDelegate
/// 配置cell居中
- (void)fixCellToCenter {
    if (self.selectedIndex != [self dragAtIndex]) {
        [self scrollToCenterAnimated:true];
        return;
    }
    //最小滚动距离
    float dragMiniDistance = kScreenWidth/20.0f;
    self.lastSelectedIndex = self.selectedIndex;
    if (self.dragStartX -  self.dragEndX >= dragMiniDistance) {
        if (kIsAR) {
            self.selectedIndex += 1;//向左
        }else {
            self.selectedIndex -= 1;//向右
        }
    }else if(self.dragEndX -  self.dragStartX >= dragMiniDistance){
        if (kIsAR) {
            self.selectedIndex -= 1;//向右
        }else {
            self.selectedIndex += 1;//向左
        }
    }

    NSInteger maxIndex = [self.collectionView numberOfItemsInSection:0] - 1;
    self.selectedIndex = self.selectedIndex <= 0 ? 0 : self.selectedIndex;
    self.selectedIndex = self.selectedIndex >= maxIndex ? maxIndex : self.selectedIndex;
    [self scrollToCenterAnimated:true];
    self.lastSelectedIndex = self.selectedIndex;
}
/// 滚动到中间
- (void)scrollToCenterAnimated:(BOOL)animated {
    BadgesDetailModel *model = self.dataList[self.selectedIndex];
    [self.currentWearButton setTitle:model.wearingFlag ? kLocalize(@"current_wear") : kLocalize(@"wear_medal") forState:UIControlStateNormal];
    CGFloat btnWidth = [self.currentWearButton.titleLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.currentWearButton.titleLabel.font} context:nil].size.width + 12;
    [self.currentWearButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnWidth);
    }];
    self.badgeNameLabel.text = model.awardName;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    BadgesTopCollectionViewCell *cell = (BadgesTopCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0]];
    cell.imageView.alpha = 1;
    if (self.lastSelectedIndex == self.selectedIndex) {return;}
    BadgesTopCollectionViewCell *lastCell = (BadgesTopCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.lastSelectedIndex inSection:0]];
    lastCell.imageView.alpha = .5;
}
/// 手指拖动开始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.dragStartX = scrollView.contentOffset.x;
    self.dragAtIndex = self.selectedIndex;
}
/// 手指拖动停止
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat width = kScreenWidth;
    NSLog(@"%f",scrollView.contentOffset.x);
    if (scrollView.contentOffset.x <= 0 || scrollView.contentOffset.x >= width * 10) {
        return;
    }
    self.dragEndX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fixCellToCenter];
    });
}
#pragma mark - 点击currentButton
- (void)currentButtonDidClicked {
    // 没有勋章
    if (self.dataList.count == 0) {
        [self goGetBadges];
        return;
    }
    BadgesDetailModel *model =  self.dataList[self.selectedIndex];
    if (model.wearingFlag) {
        // 已佩戴点击无效果
        NSLog(@"已佩戴 点击无效果");
        return;
    }
    // 未佩戴 点击后佩戴勋章
    NSLog(@"去佩戴");
    ExecBlock(self.WearBadgeBlock,model);
}
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return NO;
}
/// 前去获取
- (void)goGetBadges {
    [[UIViewController getCurrentViewController] popToViewController:@"PrayerViewController"];
}
- (UIImageView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithImage:kImageName(@"badges_top_bg")];
    }
    return _backgroundView;
}
- (UILabel *)badgeNameLabel {
    if (!_badgeNameLabel) {
        _badgeNameLabel = [UILabel labelWithTextFont:kFontMedium(14) textColor:RGB(0xD9A53E)];
        _badgeNameLabel.text = @" ";
        _badgeNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _badgeNameLabel;
}
- (UIButton *)currentWearButton {
    if (!_currentWearButton) {
        _currentWearButton = [UIButton buttonWithTitleFont:kFontMedium(10) titleColor:RGB(0xD9A53E)];
        _currentWearButton.layer.cornerRadius = 10;
        _currentWearButton.backgroundColor = RGB(0xFDF9F1);
        _currentWearButton.layer.borderWidth = 1;
        _currentWearButton.layer.borderColor = RGB(0xD9A53E).CGColor;
        [_currentWearButton setTitle:kLocalize(@"current_wear") forState:UIControlStateNormal];
        @weakify(self)
        [[_currentWearButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self currentButtonDidClicked];
        }];
    }
    return _currentWearButton;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        BadgesTopCollectionViewFlowLayout *layout = [[BadgesTopCollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(128, 158);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = kClearColor;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_collectionView registerClass:[BadgesTopCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([BadgesTopCollectionViewCell class])];
        _collectionView.clipsToBounds = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;

}
@end
