//
//  BaseWebViewController.m
//  Daleel
//
//  Created by mac on 2023/5/22.
//

#import "BaseWebViewController.h"

@interface BaseWebViewController ()

@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation BaseWebViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self cjdAddMessageHandlers];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self cjdRemoveMessageHandlers];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark - init
- (void)initialize {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]]];
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:nil];
    @weakify(self);
    [self replaceNavBackActionWithAction:^{
        @strongify(self);
        [self back];
    }];
}
#pragma mark - UI
- (void)setupViews {
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];

    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kHeight_NavBar + self.progressView.height);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
}
#pragma mark - pravite method
/// 添加交互方法
- (void)cjdAddMessageHandlers {
    for (NSString *messageHandlerString in self.messageHandlers) {
        [self.webView.configuration.userContentController addScriptMessageHandler:self name:messageHandlerString];
    }
}
/// 移除交互方法
- (void)cjdRemoveMessageHandlers {
    if (@available(iOS 14.0, *)) {
        [self.webView.configuration.userContentController removeAllScriptMessageHandlers];
    } else {
        for (NSString *messageHandlerString in self.messageHandlers) {
            [self.webView.configuration.userContentController removeScriptMessageHandlerForName:messageHandlerString];
        }
    }
}
#pragma mark - WKWebViewUIDelegate
/// 获取网页标题
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    @weakify(self);
    NSString *getTitleJs = @"document.title";
    [self.webView evaluateJavaScript:getTitleJs completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        @strongify(self);
        if (!error) {
            self.title = [NSString stringWithFormat:@"%@",result];
        }
    }];
}
#pragma mark - WKScriptMessageHandler
/// 接收web调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self receiveJSCallWithMessage:message];
}
/// 接收到web调用
- (void)receiveJSCallWithMessage:(WKScriptMessage *)message {
    
}
#pragma mark - Estimated Progress KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.webView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.webView.estimatedProgress animated:animated];
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
#pragma mark - pravite method
/// 返回/后退
- (void)back {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - lazy load
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.configuration.preferences.javaScriptEnabled = YES;
        _webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    }
    return _webView;
}
- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        [_progressView setTrackTintColor:kClearColor];
        [_progressView setProgressTintColor:RGB(0xD9A53E)];
        [_progressView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
        _progressView.frame = CGRectMake(0, kHeight_NavBar, kScreenWidth, 3);
    }
    return _progressView;
}
- (void)dealloc {
    NSLog(@"BaseWebViewController 释放了");
}

@end
