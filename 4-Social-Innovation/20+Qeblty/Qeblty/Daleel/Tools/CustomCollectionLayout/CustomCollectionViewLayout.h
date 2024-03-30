//
//  AwardsCollectionIViewLayout.h
//  Daleel
//
//  Created by mac on 2022/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CustomCollectionViewLayoutDelegate <NSObject>

- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundColorForSection:(NSInteger)section;

- (float)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout cornerRadiusForSection:(NSInteger)section;

- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout borderColorForSection:(NSInteger)section;

- (float)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout borderWidthForSection:(NSInteger)section;

@end

@interface CustomCollectionViewLayout : UICollectionViewFlowLayout

@property (nonatomic,weak) id <CustomCollectionViewLayoutDelegate> customCollectionViewLayoutDelegate;

@end

NS_ASSUME_NONNULL_END
