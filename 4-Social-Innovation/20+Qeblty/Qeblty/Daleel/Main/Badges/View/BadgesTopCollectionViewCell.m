//
//  BadgesTopCollectionViewCell.m
//  Daleel
//
//  Created by mac on 2024/3/30.
//

#import "BadgesTopCollectionViewCell.h"

@interface BadgesTopCollectionViewCell ()


@end

@implementation BadgesTopCollectionViewCell

- (void)initialize {
    self.clipsToBounds = YES;
    
    self.backgroundColor = kClearColor;
}
- (void)setModel:(BadgesDetailModel *)model {
    _model = model;
    [self.imageView loadImgUrl:model.awardUrl placeholderImg:@"award_holder"];
}
- (void)updateWithCellData:(id)aData {
    self.imageView.image = kImageName(@"badge_dontHave_placeholder");
}
- (void)setupViews {
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-14);
        make.size.mas_equalTo(CGSizeMake(128, 128));
        make.centerX.equalTo(self.contentView);
    }];
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.alpha = .5;
    }
    return _imageView;
}
@end
