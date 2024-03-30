//
//  AwardsCollectionReusableView.m
//  Daleel
//
//  Created by mac on 2022/12/9.
//

#import "CustomCollectionSectionReusableView.h"
#import "CustomCollectionViewLayoutAttributes.h"

@implementation CustomCollectionSectionReusableView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    if ([layoutAttributes isKindOfClass:[CustomCollectionViewLayoutAttributes class]]) {
        CustomCollectionViewLayoutAttributes *attr = (CustomCollectionViewLayoutAttributes *)layoutAttributes;
        self.backgroundColor = attr.backgroundColor;
        self.layer.cornerRadius = attr.cornerRadius;
        self.layer.borderWidth = attr.borderWidth;
        self.layer.borderColor = attr.borderColor.CGColor;
//        self.layer.masksToBounds = YES;
    }
}

@end
