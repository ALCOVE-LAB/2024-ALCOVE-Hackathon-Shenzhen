//
//  RefreshHeader.h
//  Gamfun
//
//  Created by mac on 2022/8/5.
//

#import <Foundation/Foundation.h>
#import "CustomRefreshHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface RefreshHeader : NSObject

/**
 常用下拉控件
 */
+ (MJRefreshHeader *)headerWithRefreshingBlock:(RefreshBlock)refreshBlock;

/**
 正常的下拉控件
 */
+ (MJRefreshNormalHeader *)normalHeaderWithRefreshingBlock:(RefreshBlock)refreshBlock;

/**
 带动画的下拉控件
 */
+ (MJRefreshGifHeader *)gifHeaderWithRefreshingBlock:(RefreshBlock)refreshBlock;

/**
 带动画的下拉控件
 */
+ (CustomRefreshHeader *)customHeaderWithRefreshingBlock:(RefreshBlock)refreshBlock;

@end

NS_ASSUME_NONNULL_END
