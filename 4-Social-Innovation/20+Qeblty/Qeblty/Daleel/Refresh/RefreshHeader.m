//
//  RefreshHeader.m
//  Gamfun
//
//  Created by mac on 2022/8/5.
//

#import "RefreshHeader.h"

@implementation RefreshHeader

+ (MJRefreshHeader *)headerWithRefreshingBlock:(RefreshBlock)refreshBlock {
    return [self normalHeaderWithRefreshingBlock:refreshBlock];
}

+ (MJRefreshNormalHeader *)normalHeaderWithRefreshingBlock:(RefreshBlock)refreshBlock {
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (refreshBlock) {
            refreshBlock();
        }
    }];
    refreshHeader.ignoredScrollViewContentInsetTop = -10;
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    [refreshHeader setTitle:kLocalize(@"srl_header_pulling") forState:MJRefreshStateIdle];
    [refreshHeader setTitle:kLocalize(@"srl_header_refreshing") forState:MJRefreshStateRefreshing];
    [refreshHeader setTitle:kLocalize(@"srl_header_release") forState:MJRefreshStatePulling];
    
    return refreshHeader;
}

+ (MJRefreshGifHeader *)gifHeaderWithRefreshingBlock:(RefreshBlock)refreshBlock {
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        if (refreshBlock) {
            refreshBlock();
        }
    }];
    NSMutableArray *idles = [NSMutableArray array];
    for (int i = 0; i < 8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"aa_000%02d", i]];
        [idles addObject:image];
    }
    [idles insertObject:[UIImage imageNamed:@"aa_00023"] atIndex:0];
    NSMutableArray *pulling = [NSMutableArray array];
    for (int i = 0; i < 24; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"aa_000%02d", i]];
        [pulling addObject:image];
    }
    NSMutableArray *refreshing = [NSMutableArray array];
    for (int i = 8; i < 17; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"aa_000%02d", i]];
        [refreshing addObject:image];
    }
    [header setImages:idles forState:MJRefreshStateIdle];
    [header setImages:pulling duration:1 forState:MJRefreshStatePulling];
    [header setImages:refreshing duration:1 forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    
    return header;
}

+ (CustomRefreshHeader *)customHeaderWithRefreshingBlock:(RefreshBlock)refreshBlock {
    CustomRefreshHeader *header = [[CustomRefreshHeader alloc] init];
    [header setRefreshingBlock:^{
        if (refreshBlock) {
            refreshBlock();
        }
    }];
    return header;
}


@end
