//
//  DaleelWebController.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "DaleelWebController.h"
#import <WebKit/WebKit.h>

@interface DaleelWebController ()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *wkWV;
/// 网页添加的方法dic （key 方法明 value 方法回调）
@property (nonatomic, strong) NSMutableDictionary <NSString *,void(^)(NSDictionary *message)>  *scriptMessageHandlerDic;

@end

@implementation DaleelWebController

- (instancetype)init {
    if(self  = [super init]) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        self.wkWV = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        self.wkWV.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return self;
}

- (void)setupViews {
    self.title = self.titleStr;
    self.wkWV.frame = CGRectMake(17, kHeight_NavBar+20, kScreenWidth-34, kScreenHeight-kHeight_NavBar-20);
    [self.wkWV setNavigationDelegate:self];
    [self.wkWV setUIDelegate:self];
    [self.wkWV setMultipleTouchEnabled:YES];
    [self.wkWV setAutoresizesSubviews:YES];
    [self.wkWV.scrollView setAlwaysBounceVertical:YES];
    self.wkWV.backgroundColor = kPublicBgColor;
    self.wkWV.hidden = YES;
    self.wkWV.scrollView.showsVerticalScrollIndicator = NO;
    [self.wkWV addTopCornerPath:15];
    [self.view addSubview:self.wkWV];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addScriptMessageHandles];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeScriptMessageHandlers];
}

#pragma mark - private

- (void)addScriptMessageHandles {
    for (NSString *name in self.scriptMessageHandlerDic.allKeys) {
        [self.wkWV.configuration.userContentController addScriptMessageHandler:self name:name];
    }
}

- (void)removeScriptMessageHandlers {
    for (NSString *name in self.scriptMessageHandlerDic.allKeys) {
        [self.wkWV.configuration.userContentController removeScriptMessageHandlerForName:name];
    }
}

#pragma mark - delegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView evaluateJavaScript:@"document.body.style.backgroundColor=\"#f8f8f8\"" completionHandler:nil];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.1*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        webView.hidden = NO;
    });
}
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSString *name in self.scriptMessageHandlerDic.allKeys) {
            if([message.name isEqualToString:name]) {
                if(self.scriptMessageHandlerDic[name]) {
                    NSDictionary *dic = [message.body mj_JSONObject];
                    ExecBlock(self.scriptMessageHandlerDic[name],dic);
                }
            }
        }
    });
}

#pragma mark - public
- (void)loadURL:(NSURL *)URL {
    [self loadRequest:[NSURLRequest requestWithURL:URL]];
}
- (void)loadRequest:(NSURLRequest *)request {
    [self.wkWV loadRequest:request];
}

- (void)loadURLString:(NSString *)URLString {
    NSURL *URL = [NSURL URLWithString:URLString];
    [self loadURL:URL];
}

- (void)loadHTMLString:(NSString *)HTMLString {
    [self.wkWV loadHTMLString:HTMLString baseURL:nil];
}

- (void)dealloc {
    [self.wkWV setNavigationDelegate:nil];
    [self.wkWV setUIDelegate:nil];
}

- (void)addScriptMessageHandlerWithName:(NSString *)name handler:(void (^)(NSDictionary * _Nonnull))handlerBlock {
    if(name.length == 0) {DLog(@"不要添加空方法名！！！") return;}
    if(handlerBlock) {
        [self.scriptMessageHandlerDic setValue:handlerBlock forKey:name];
    }else {
        [self.scriptMessageHandlerDic setNilValueForKey:name];
    }
}

#pragma mark - lazyload
- (NSMutableDictionary *)scriptMessageHandlerDic {
    if (!_scriptMessageHandlerDic) {
        _scriptMessageHandlerDic = [NSMutableDictionary dictionary];
    }
    return _scriptMessageHandlerDic;;
}

@end
