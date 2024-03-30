//
//  AwardsCollectionIViewLayout.m
//  Daleel
//
//  Created by mac on 2022/12/9.
//

#import "CustomCollectionViewLayout.h"
#import "CustomCollectionViewLayoutAttributes.h"
#import "CustomCollectionSectionReusableView.h"

NSString *const AwardsCollectionViewSectionBackground = @"AwardsCollectionViewSectionBackground";

@interface CustomCollectionViewLayout ()

@property (nonatomic,strong) NSMutableArray *attrs;

@end

@implementation CustomCollectionViewLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registerClass:CustomCollectionSectionReusableView.class forDecorationViewOfKind:AwardsCollectionViewSectionBackground];
        _attrs = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    [_attrs removeAllObjects];
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    id delegate = self.collectionView.delegate;
    if(!numberOfSections || ![delegate conformsToProtocol:@protocol(CustomCollectionViewLayoutDelegate)]) {return;}
    for (NSInteger section = 0; section < numberOfSections; section ++) {
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        if(numberOfItems <= 0) {continue;}
        UICollectionViewLayoutAttributes *firstItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        UICollectionViewLayoutAttributes *lastItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:numberOfItems - 1 inSection:section]];
        if (!firstItem || !lastItem) {continue;}
        UIEdgeInsets sectionInset = [self sectionInset];
        if([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
            UIEdgeInsets inset = [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
            sectionInset = inset;
        }
        CGRect sectionFrame = CGRectUnion(firstItem.frame, lastItem.frame);
        if(kIsAR) {
            sectionFrame.origin.x = 0;
        }else {
            sectionFrame.origin.x -= sectionInset.left;
        }
        sectionFrame.origin.y -= sectionInset.top;
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            sectionFrame.size.width += sectionInset.left + sectionInset.right;
            sectionFrame.size.height = self.collectionView.frame.size.height;
        } else {
            sectionFrame.size.width = self.collectionView.frame.size.width;
            sectionFrame.size.height += sectionInset.top + sectionInset.bottom;
        }
        CustomCollectionViewLayoutAttributes *attr = [CustomCollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:AwardsCollectionViewSectionBackground withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        attr.frame = sectionFrame;
        attr.zIndex = -1;
        if ([delegate respondsToSelector:@selector(collectionView:layout:backgroundColorForSection:)]) {
            attr.backgroundColor = [delegate collectionView:self.collectionView layout:self backgroundColorForSection:section];
        }
        if ([delegate respondsToSelector:@selector(collectionView:layout:cornerRadiusForSection:)]) {
            attr.cornerRadius = [delegate collectionView:self.collectionView layout:self cornerRadiusForSection:section];
        }
        if ([delegate respondsToSelector:@selector(collectionView:layout:borderColorForSection:)]) {
            attr.borderColor = [delegate collectionView:self.collectionView layout:self borderColorForSection:section];
        }
        if ([delegate respondsToSelector:@selector(collectionView:layout:borderWidthForSection:)]) {
            attr.borderWidth = [delegate collectionView:self.collectionView layout:self borderWidthForSection:section];
        }
        [self.attrs addObject:attr];
    }
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attrs = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    for (UICollectionViewLayoutAttributes *attr in self.attrs) {
        if (CGRectIntersectsRect(rect, attr.frame)) {
            [attrs addObject:attr];
        }
    }
    return attrs;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:AwardsCollectionViewSectionBackground]) {
        return [self.attrs objectAtIndex:indexPath.section];
    }
    return [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
