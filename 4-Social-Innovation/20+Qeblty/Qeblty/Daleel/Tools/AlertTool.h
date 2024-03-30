//
//  AlertTool.h
//  Daleel
//
//  Created by mac on 2022/12/16.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN


typedef void(^btnClickBlock)(void);

@interface AlertTool : BaseView

/// 更新视图
/// - Parameters:
///   - title: 标题
///   - content: 内容
///   - isForce: 是否强更
- (instancetype)initUpdateViewWithTitle:(NSString *_Nullable)title content:(NSString *_Nullable)content forceUpdate:(BOOL)isForce btnTitle:(NSString *_Nullable)btnTitle btnClick:(nullable btnClickBlock)btnClick;

/// 创建带图片弹窗
/// - Parameters:
///   - title: 标题
///   - message: 内容
///   - imageStr: 图片名/图片url
///   - btnTitle: 按钮标题
///   - btnClick: 按钮回调 
- (instancetype)initWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message image:(NSString *_Nullable)imageStr btnTitle:(NSString *_Nullable)btnTitle btnClick:(nullable btnClickBlock)btnClick;

- (void)show;
- (void)hide;

@property(nonatomic,copy)void (^hideBlock) (void);

@end

NS_ASSUME_NONNULL_END
