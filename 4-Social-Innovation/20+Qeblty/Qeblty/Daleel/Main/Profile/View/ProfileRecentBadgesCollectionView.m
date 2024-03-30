//
//  AwardsRecentView.m
//  Daleel
//
//  Created by mac on 2024/3/31.
//

#import "ProfileRecentBadgesCollectionView.h"

/**
 最近获得的勋章 列表
 */
@implementation ProfileRecentBadgesCollectionView

+ (ProfileRecentBadgesCollectionView *)getAwardsRecentCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(120, 150);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    ProfileRecentBadgesCollectionView *collectionview = [[self alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    return collectionview;
}

- (void)initialize {
    [super initialize];
    self.backgroundColor = [UIColor clearColor];
    self.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    [self registerClass:[AwardsRecentCollectionViewCell class] forCellWithReuseIdentifier:[AwardsRecentCollectionViewCell cellIdentifier]];
    self.showsVerticalScrollIndicator = NO;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AwardsRecentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[AwardsRecentCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    BadgesDetailModel *model = self.dataArr[indexPath.item];
    [cell updateWithCellData:model];
    return cell;
}

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    if(self.dataArr.count == 0) {
//        return 0;
//    }
//    return 1;
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

@end



/**
 最近获得的勋章 列表Cell
 */
@interface AwardsRecentCollectionViewCell ()

@property (nonatomic,strong) UIImageView *awardImgv;
@property (nonatomic,strong) UILabel *awardNameLabel;
//@property (nonatomic,strong) UILabel *ruleDetailLabel;
//@property (nonatomic,strong) UILabel *awardGettedTimesLabel;

@end

@implementation AwardsRecentCollectionViewCell

- (void)setupViews {
    _awardImgv = [UIImageView imgViewWithImg:@"" superView:self.contentView];
    _awardImgv.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *awardNameLabel = [UILabel labelWithTextColor:[UIColor colorWithHexString:@"#1B1B1B"] font:14 text:@"" superView:self.contentView];
    awardNameLabel.textAlignment = NSTextAlignmentCenter;
    _awardNameLabel = awardNameLabel;
    
//    UILabel *ruleDetailLabel = [UILabel labelWithTextColor:[UIColor colorWithHexString:@"#999999"] font:11 text:@"" superView:self.contentView];
//    ruleDetailLabel.textAlignment = NSTextAlignmentCenter;
//    _ruleDetailLabel = ruleDetailLabel;
//
//    UILabel *awardGettedTimesLabel = [UILabel labelWithTextColor:[UIColor colorWithHexString:@"#D1B378"] font:10 text:@"" superView:self.contentView];
//    awardGettedTimesLabel.textAlignment = NSTextAlignmentCenter;
//    awardGettedTimesLabel.layer.cornerRadius = 7;
//    awardGettedTimesLabel.layer.borderColor = [UIColor colorWithHexString:@"#D1B378"].CGColor;
//    awardGettedTimesLabel.layer.borderWidth = 1;
//    awardGettedTimesLabel.layer.masksToBounds = YES;
//    awardGettedTimesLabel.backgroundColor = [UIColor colorWithHexString:@"#FDF9F1"];
//    _awardGettedTimesLabel = awardGettedTimesLabel;
    
//    [awardGettedTimesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.contentView);
//        make.top.equalTo(ruleDetailLabel.mas_bottom).offset(4);
//        make.size.mas_equalTo(CGSizeMake(34, 14));
//    }];
//    
//    [ruleDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.contentView);
//        make.top.equalTo(awardNameLabel.mas_bottom).offset(6);
//        make.leading.equalTo(self.contentView.mas_leading);
//        make.trailing.equalTo(self.contentView.mas_trailing);
//    }];
    
    [awardNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_awardImgv.mas_bottom).offset(6);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.leading.equalTo(self.contentView.mas_leading);
        make.trailing.equalTo(self.contentView.mas_trailing);
    }];
    
    [_awardImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(105);
        make.leading.trailing.mas_equalTo(0);
        make.top.equalTo(self.contentView.mas_top);
    }];
    
}
- (void)updateWithCellData:(id)aData {
    BadgesDetailModel *model = (BadgesDetailModel *)aData;
    if(model.achieveStatus == 0) {
        [_awardImgv loadImgUrl:model.awardUnAchievedUrl placeholderImg:@"award_holder"];
//        _awardGettedTimesLabel.hidden = YES;
    }else {
        [_awardImgv loadImgUrl:model.awardUrl placeholderImg:@"award_holder"];
//        _awardGettedTimesLabel.hidden = NO;
    }
    _awardNameLabel.text = model.awardName;
//    _ruleDetailLabel.text = model.awardRuleDescribe;
//    _awardGettedTimesLabel.text = [NSString stringWithFormat:@"%ld", model.obtainTimes];
}

@end

