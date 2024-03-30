//
//  DeleteAccountTermController.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "DeleteAccountTermController.h"
#import <WebKit/WebKit.h>
#import <NSDate+BRPickerView.h>

@interface DeleteAccountTermController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
///删除按钮
@property (nonatomic, strong) UIButton *deleteButton;
///取消按钮
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation DeleteAccountTermController

- (void)initialize {
    self.title = kLocalize(@"delete_account_agreement_terms");
}

- (void)setupViews {
    [self.view addSubview:self.webView];
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.deleteButton];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(14);
        make.width.mas_equalTo(kScreenWidth*0.24);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(-30);
    }];

    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cancelButton);
        make.trailing.mas_equalTo(-14);
        make.width.mas_equalTo(kScreenWidth*0.56);
        make.height.mas_equalTo(50);

    }];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(10);
        make.trailing.mas_equalTo(-10);
        make.bottom.mas_equalTo(self.cancelButton.mas_top).offset(-20);
    }];
}

- (void)requestData {
    [ProgressHUD showHudInView:self.view];
    NSString *urlPath = [NSString stringWithFormat:@"AccountDeletionAgreement?local=%@",[LanguageTool currentLanguageName]];
    NSString *url = WEBURL(urlPath);
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}
- (void)deleteData {
    [ProgressHUD showHudInView:self.view];
    [AccountNetworkTool deleteAccountSuccess:^(id  _Nullable responseObject) {
        [ProgressHUD hideHUDForView:self.view];
        [kUser logout];
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD hideHUDForView:self.view];
        kToast(error.userInfo[kHttpErrorReason]);
    }];
}

#pragma mark - lazy load
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithTitleFont:kFontSemibold(18) titleColor:RGB(0xFFF7D6) title:kLocalize(@"cancel")];
        _cancelButton.backgroundColor = RGB(0x28271F);
        _cancelButton.layer.cornerRadius = 15;
        @weakify(self)
        [[_cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self popToViewController:@"AccountSecurityController"];
        }];
    }
    return _cancelButton;
}
- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithTitleFont:kFontSemibold(18) titleColor:RGB(0x28271F) title:kLocalize(@"delete_my_account")];
        _deleteButton.layer.cornerRadius = 16;
        _deleteButton.layer.borderColor = RGB(0x28271F).CGColor;
        _deleteButton.layer.borderWidth = 2;
        @weakify(self)
        [[_deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self deleteAction];
        }];
    }
    return _deleteButton;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.backgroundColor = kPublicBgColor;
        _webView.hidden = YES;
    }
    return _webView;
}

#pragma mark - delegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView evaluateJavaScript:@"document.body.style.backgroundColor=\"#f8f8f8\"" completionHandler:nil];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.1*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        webView.hidden = NO;
        [ProgressHUD hideHUDForView:self.view];
    });
}

#pragma mark - event
- (void)deleteAction {
    NSDate *date = [[NSDate date] br_getNewDateToDays:7];
    NSString *str = [NSDate br_stringFromDate:date dateFormat:@"yyyy-MM-dd"];
    [UIAlertController showActionSheetInViewController:self withTitle:kLocalize(@"continue_with_the_delete_account_operation_title") message:[NSString stringWithFormat:kLocalize(@"continue_with_the_delete_account_operation_content"),str] cancelButtonTitle:kLocalize(@"cancel") destructiveButtonTitle:kLocalize(@"delete_my_account") otherButtonTitles:@[] tapBlock:^(UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == UIAlertControllerBlocksDestructiveButtonIndex) {
            [self deleteData];
        }
    }];
}

@end
