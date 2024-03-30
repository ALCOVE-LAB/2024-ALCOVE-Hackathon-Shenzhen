//
//  BaseWebViewController.h
//  Daleel
//
//  Created by mac on 2023/5/22.
//

#import "BaseViewController.h"
#import <Webkit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseWebViewController : BaseViewController <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

/// webView
@property (nonatomic, strong) WKWebView *webView;
/// requestUrl
@property (nonatomic, strong) NSString *requestUrl;
/// 交互方法数组
@property (nonatomic, copy) NSArray *messageHandlers;

/// 接收到web调用
/// - Parameter message: message
- (void)receiveJSCallWithMessage:(WKScriptMessage *)message;
@end

NS_ASSUME_NONNULL_END
