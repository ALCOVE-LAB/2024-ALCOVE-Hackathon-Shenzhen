//
//  DaleelWebController.h
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DaleelWebController : BaseViewController

- (void)loadURL:(NSURL *)URL;
- (void)loadURLString:(NSString *)URLString;
- (void)loadHTMLString:(NSString *)HTMLString;
- (void)loadRequest:(NSURLRequest *)request;
/// 网页内添加方法给web使用
- (void)addScriptMessageHandlerWithName:(NSString *)name handler:(void(^)(NSDictionary *message))handlerBlock;

@property(nonatomic,copy)NSString *titleStr;

@end

NS_ASSUME_NONNULL_END
