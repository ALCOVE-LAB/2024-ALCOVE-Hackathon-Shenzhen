//
//  CustomCollectionViewLayoutAttributes.h
//  Daleel
//
//  Created by mac on 2022/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic,strong) UIColor *backgroundColor;
@property (nonatomic,assign) float cornerRadius;
@property (nonatomic,assign) float borderWidth;
@property (nonatomic,strong) UIColor * borderColor;

@end

NS_ASSUME_NONNULL_END
