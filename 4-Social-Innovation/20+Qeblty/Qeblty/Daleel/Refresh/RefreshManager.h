//
//  RefreshManager.h
//  Gamfun
//
//  Created by mac on 2022/8/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RefreshManager : NSObject

+ (void)endRefreshingWithState:(RefreshState)state scrollView:(UIScrollView *)scrollView footerRefreshingBlock:(void (^)(void))refreshingBlock;

@end

NS_ASSUME_NONNULL_END
