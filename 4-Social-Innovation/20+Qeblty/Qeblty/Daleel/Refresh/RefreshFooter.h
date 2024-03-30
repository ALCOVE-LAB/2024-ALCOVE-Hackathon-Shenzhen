//
//  RefreshFooter.h
//  Gamfun
//
//  Created by mac on 2022/8/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RefreshFooter : NSObject

/**
 常用上拉控件
 */
+ (MJRefreshFooter *)footerWithRefreshingBlock:(RefreshBlock)refreshBlock;

/**
 正常的自动上拉控件
 */
+ (MJRefreshAutoNormalFooter *)normalFooterWithRefreshingBlock:(RefreshBlock)refreshBlock;

/**
 带动画的自动上拉控件
 */
+ (MJRefreshAutoGifFooter *)gifFooterWithRefreshingBlock:(RefreshBlock)refreshBlock;

/**
 正常的回弹上拉控件
 */
+ (MJRefreshBackNormalFooter *)backNormalFooterWithRefreshingBlock:(RefreshBlock)refreshBlock;

/**
 带动画的回弹上拉控件
 */
+ (MJRefreshBackGifFooter *)backGifFooterWithRefreshingBlock:(RefreshBlock)refreshBlock;

@end

NS_ASSUME_NONNULL_END
