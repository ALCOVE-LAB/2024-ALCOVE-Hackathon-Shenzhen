//
//  RefreshFooter.m
//  Gamfun
//
//  Created by mac on 2022/8/5.
//

#import "RefreshFooter.h"

@implementation RefreshFooter

+ (MJRefreshFooter *)footerWithRefreshingBlock:(RefreshBlock)refreshBlock {
    return [self backNormalFooterWithRefreshingBlock:refreshBlock];
}

+ (MJRefreshAutoNormalFooter *)normalFooterWithRefreshingBlock:(RefreshBlock)refreshBlock {
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (refreshBlock) {
            refreshBlock();
        }
    }];
    [self setStateLabelWithFooter:refreshFooter];
    
    return refreshFooter;
}

+ (MJRefreshAutoGifFooter *)gifFooterWithRefreshingBlock:(RefreshBlock)refreshBlock {
    MJRefreshAutoGifFooter *refreshFooter = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        if (refreshBlock) {
            refreshBlock();
        }
    }];
    [self setStateLabelWithFooter:refreshFooter];
    refreshFooter.refreshingTitleHidden = YES;
    NSMutableArray *refreshing = [NSMutableArray array];
    for (int i = 8; i < 17; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"aa_000%02d", i]];
        [refreshing addObject:image];
    }
    [refreshFooter setImages:refreshing duration:1 forState:MJRefreshStateRefreshing];
    
    return refreshFooter;
}

+ (MJRefreshBackNormalFooter *)backNormalFooterWithRefreshingBlock:(RefreshBlock)refreshBlock {
    MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (refreshBlock) {
            refreshBlock();
        }
    }];
    [self setStateLabelWithFooter:refreshFooter];
    
    return refreshFooter;
}

+ (MJRefreshBackGifFooter *)backGifFooterWithRefreshingBlock:(RefreshBlock)refreshBlock {
    MJRefreshBackGifFooter *refreshFooter = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        if (refreshBlock) {
            refreshBlock();
        }
    }];
    [self setStateLabelWithFooter:refreshFooter];
    NSMutableArray *refreshing = [NSMutableArray array];
    for (int i = 8; i < 17; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"aa_000%02d", i]];
        [refreshing addObject:image];
    }
    [refreshFooter setImages:refreshing duration:1 forState:MJRefreshStateRefreshing];
    
    return refreshFooter;
}

+ (void)setStateLabelWithFooter:(MJRefreshFooter *)footer {
    MJRefreshBackStateFooter *refreshFooter = (MJRefreshBackStateFooter *)footer;
    [refreshFooter setTitle:kLocalize(@"srl_footer_pulling") forState:MJRefreshStateIdle];
    [refreshFooter setTitle:kLocalize(@"srl_footer_release") forState:MJRefreshStatePulling];
    [refreshFooter setTitle:kLocalize(@"srl_footer_loading") forState:MJRefreshStateRefreshing];
    [refreshFooter setTitle:kLocalize(@"srl_footer_nothing") forState:MJRefreshStateNoMoreData];
    refreshFooter.stateLabel.font = [UIFont systemFontOfSize:14];
    refreshFooter.stateLabel.textColor = RGB(0xC2C7CE);
}

@end
