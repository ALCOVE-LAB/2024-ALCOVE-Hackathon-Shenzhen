//
//  BadgesCollectionViewCell.m
//  Daleel
//
//  Created by mac on 2024/3/30.
//

#import "BadgesCollectionViewCell.h"
#import "BadgesModel.h"

@interface BadgesCollectionViewCell ()

/// 勋章名称
@property (nonatomic, strong) UILabel *badgeNameLabel;
/// 规则
@property (nonatomic, strong) UILabel *badgeRuleLabel;


@end

@implementation BadgesCollectionViewCell

- (void)setupViews {
    [self.contentView addSubview:self.badgeImageView];
    [self.contentView addSubview:self.badgeNameLabel];
    [self.contentView addSubview:self.badgeRuleLabel];
    
    [self.badgeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.top.centerX.equalTo(self.contentView);
    }];
    
    [self.badgeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.badgeImageView.mas_bottom).offset(16);
        make.leading.trailing.equalTo(self.contentView);
    }];
    
    [self.badgeRuleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.badgeNameLabel.mas_bottom).offset(6);
        make.leading.trailing.equalTo(self.contentView);
    }];
    
}
- (void)updateWithCellData:(id)aData {
    BadgesDetailModel *model = (BadgesDetailModel *)aData;
    self.badgeNameLabel.text = model.awardName;
    [self.badgeImageView loadImgUrl:model.achieveStatus == 0 ? model.awardUnAchievedUrl : model.awardUrl placeholderImg:@"award_holder"];
    self.badgeRuleLabel.text = model.progress;
}
#pragma mark - lazy load
- (UILabel *)badgeNameLabel {
    if (!_badgeNameLabel) {
        _badgeNameLabel = [UILabel labelWithTextFont:kFontRegular(14) textColor:RGB(0x1b1b1b)];
        _badgeNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _badgeNameLabel;
}
- (UILabel *)badgeRuleLabel {
    if (!_badgeRuleLabel) {
        _badgeRuleLabel = [UILabel labelWithTextFont:kFontRegular(11) textColor:RGB(0x999999)];
        _badgeRuleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _badgeRuleLabel;
}
- (UIImageView *)badgeImageView {
    if (!_badgeImageView) {
        _badgeImageView = [[UIImageView alloc] init];
    }
    return _badgeImageView;
}
@end
