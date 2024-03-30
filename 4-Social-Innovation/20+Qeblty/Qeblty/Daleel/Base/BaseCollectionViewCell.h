//
//  BaseCollectionViewCell.h
//  Gamfun
//
//  Created by mac on 2022/8/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseCollectionViewCell : UICollectionViewCell

/**
 *  创建Cell时候设置的cellIdentifier
 */
+ (NSString *)cellIdentifier;

/**
 *  获取cell的大小
 *  子类去实现
 */
+ (CGSize)sizeForCellData:(id)aData;

/**
 * 根据数据更新cell的UI
 */
- (void)updateWithCellData:(id)aData;

- (void)initialize;
- (void)setupViews;

@end

NS_ASSUME_NONNULL_END
