//
//  MultiDelegateManager.h
//  BaseDemoOC
//
//  Created by mac on 2022/5/19.
//

// 多代理管理工具

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MultiDelegateManager<__covariant DelegateType> : NSObject

/// 添加代理
- (void)addDelegate:(DelegateType)delegate;

/// 移除代理（内部weak处理 可以不用执行这方法）
- (void)removeDelegate:(DelegateType)delegate;

/// 移除无效的代理
- (void)removeInvalideDelegate:(DelegateType)delegate;

- (void)enumerateDelegate:(void(^)(DelegateType delegate))block;

@end

@interface MultiDelegateItem : NSObject

@property (nonatomic,weak) id delegate;

@end

NS_ASSUME_NONNULL_END
