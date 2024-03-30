//
//  BaseVM.h
//  BaseDemoOC
//
//  Created by mac on 2022/5/19.
//

#import <Foundation/Foundation.h>

@protocol VMMessageDelegate <NSObject>

- (void)vmMessage:(NSString *_Nullable)messageId data:(id _Nullable)data;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BaseVM : NSObject

/// 设置VM接收者（多代理支持）
- (void)addVMMessageReceiver:(id <VMMessageDelegate>)receiver;

/// 移除VM接收者（内部已经weak处理 可以不用这方法）
- (void)removeVMMessageReceiver:(id <VMMessageDelegate>)receiver;

/// 发送VM消息
- (void)sendVMMessage:(NSString *_Nonnull)messageId data:(id _Nullable)data;

@end

NS_ASSUME_NONNULL_END
