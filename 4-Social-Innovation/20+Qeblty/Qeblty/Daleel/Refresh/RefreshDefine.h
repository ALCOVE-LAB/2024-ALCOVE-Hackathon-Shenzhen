//
//  RefreshDefine.h
//  Gamfun
//
//  Created by mac on 2022/8/5.
//

typedef void(^RefreshBlock)(void);

// 刷新结果
typedef NS_ENUM(NSUInteger, RefreshState) {
    HeaderRefresh_HasMoreData = 1,
    HeaderRefresh_HasNoMoreData,
    HeaderRefresh_HasNoData,
    FooterRefresh_HasMoreData,
    FooterRefresh_HasNoMoreData,
    RefreshError
};

#import "RefreshHeader.h"
#import "RefreshFooter.h"
#import "RefreshManager.h"
