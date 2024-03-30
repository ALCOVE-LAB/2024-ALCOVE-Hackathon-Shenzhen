//
//  BaseCollectionViewCell.m
//  Gamfun
//
//  Created by mac on 2022/8/7.
//

#import "BaseCollectionViewCell.h"

@implementation BaseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
        [self setupViews];
    }
    return self;
}

+ (NSString *)cellIdentifier {
    return NSStringFromClass(self);
}

- (void)updateWithCellData:(id)aData {}

+ (CGSize)sizeForCellData:(id)aData {
    return CGSizeZero;
}

- (void)initialize {}

- (void)setupViews {}

@end
