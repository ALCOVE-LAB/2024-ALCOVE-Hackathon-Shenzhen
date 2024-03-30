//
//  LoginViewController.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "LoginViewController.h"
#import "PhoneLoginViewController.h"
#import "LoginVM.h"
#import "DaleelWebController.h"

@interface LoginViewController ()<UITextViewDelegate>

@property (nonatomic,strong) UIButton *checkBoxBtn;
@property (nonatomic,strong) LoginVM *vm;
/// 记录是否点击手机登录按钮 如果有则埋点时候传递return_login
@property (nonatomic,assign)NSInteger phoneBtnClickTag;

@property (nonatomic, strong) UIButton *metaMastButton;

@end

@implementation LoginViewController

- (void)initialize {
    self.vm = [[LoginVM alloc] init];
    [self bindVM:self.vm];
    self.isHideNav = YES;
    self.phoneBtnClickTag = 0;/// 给点击按钮次数一个初始值
}

- (void)setupViews {
    UIButton *closeBtn = [UIButton buttonWithSuperView:self.view];
    [closeBtn setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
    closeBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 0, 0);
    [self.view addSubview:closeBtn];
    @weakify(self);
    [closeBtn addTapAction:^{
        @strongify(self);
        /// 埋点处理
        NSString *sourceStr = @"";
        
        if ([NSStringFromClass([[UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers  lastObject].class) isEqualToString:@"ProfileViewControllerV2"]) {
            sourceStr = @"profile_signin_click";
        }
        if (self.phoneBtnClickTag > 0) {
            sourceStr = @"return_login";
        }
        [self dismissViewController];
    }];
    
    UIImageView *iconImgv = [UIImageView imgViewWithImg:@"icon_logo" superView:self.view];
    
    UILabel *titleLabel = [UILabel labelWithTextColor:[UIColor colorWithHexString:@"#1B1B1B"] boldFont:32 text:@"Qeblty" superView:self.view];
    
    // 登陆按钮  下面数据可配置
    NSArray *loginBtnTypeArr;
    if(@available(iOS 14.0 , *)) {
        loginBtnTypeArr = @[
#if DEBUG
        @{@"login_icon":@"login_phone_icon",@"accountLoginType":@(AccountLoginType_phone)},
#endif
//        @{@"login_icon":@"login_facebook_icon",@"accountLoginType":@(AccountLoginType_facebook)},
        @{@"login_icon":@"login_google_icon",@"accountLoginType":@(AccountLoginType_google)},
        @{@"login_icon":@"login_apple_icon",@"accountLoginType":@(AccountLoginType_apple)},
        @{@"login_icon":@"metamask_login_btn",@"accountLoginType":@(AccountLoginType_matamask)}
        ];
    }else{
        loginBtnTypeArr = @[
#if DEBUG
        @{@"login_icon":@"login_phone_icon",@"accountLoginType":@(AccountLoginType_phone)},
#endif
//        @{@"login_icon":@"login_facebook_icon",@"accountLoginType":@(AccountLoginType_facebook)},
        @{@"login_icon":@"login_google_icon",@"accountLoginType":@(AccountLoginType_google)},
        ];
    }
    float leadingOffset = (self.view.width - (loginBtnTypeArr.count * 78 + ((loginBtnTypeArr.count - 1) * 4))) / 2;
    for (int i = 0; i < loginBtnTypeArr.count; i++) {
        UIButton *loginBtn = [UIButton buttonWithSuperView:self.view];
        [loginBtn setBackgroundImage:[UIImage imageNamed:(NSString *)[loginBtnTypeArr[i] valueForKey:@"login_icon"]] forState:UIControlStateNormal];
        loginBtn.tag = [[loginBtnTypeArr[i] valueForKey:@"accountLoginType"] integerValue] + 999;
        [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(78, 78));
            make.leading.equalTo(self.view.mas_leading).offset((78 + 4) * i + leadingOffset);
            make.top.equalTo(titleLabel.mas_bottom).offset(65);
        }];
    }
    
    /// 协议
    UIButton *checkBoxBtn = [UIButton buttonWithSuperView:self.view];
    _checkBoxBtn = checkBoxBtn;
    [checkBoxBtn setBackgroundImage:[UIImage imageNamed:@"login_checkbox_n"] forState:UIControlStateNormal];
    [checkBoxBtn setBackgroundImage:[UIImage imageNamed:@"login_checkbox_s"] forState:UIControlStateSelected];
    [[checkBoxBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        x.selected = !x.selected;
    }];
    
    // 确认
    NSString *text = kLocalize(@"i_agree_to_the_user_service_agreement_and_privacy_policy_terms");
    NSMutableParagraphStyle *muParagraph = [[NSMutableParagraphStyle alloc] init];
    muParagraph.lineSpacing = 10;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range1 = [text rangeOfString:kLocalize(@"user_service_agreement")];
    NSRange range2 = [text rangeOfString:kLocalize(@"privacy_policy_terms")];
    [attrStr addAttributes:@{NSUnderlineStyleAttributeName:@(1),NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#3898E1"]} range:range1];
    [attrStr addAttributes:@{NSUnderlineStyleAttributeName:@(1),NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#3898E1"]} range:range2];
    [attrStr addAttribute:NSLinkAttributeName value:@"agreement://" range:range1];
    [attrStr addAttribute:NSLinkAttributeName value:@"privacy://" range:range2];
    // 协议
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-80, 60)];
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.delegate = self;
    textView.attributedText = attrStr;
    textView.font = kFontMedium(12);
    textView.textColor = [UIColor colorWithHexString:@"#666666"];
    textView.backgroundColor = [UIColor clearColor];
    textView.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#3898E1"]};
    [self.view addSubview:textView];
    [textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view.mas_trailing).offset(-24);
        make.leading.equalTo(checkBoxBtn.mas_trailing).offset(10);
        make.top.equalTo(checkBoxBtn.mas_top).offset(-10);
        make.height.equalTo(@60);
    }];
    
    [checkBoxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.leading.equalTo(self.view.mas_leading).offset(30);
        make.bottom.equalTo(self.view.mas_bottom).offset(-40);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(iconImgv);
        make.top.equalTo(iconImgv.mas_bottom).offset(11);
    }];
    
    [iconImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(160);
        make.size.mas_equalTo(CGSizeMake(110, 110));
    }];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view.mas_trailing).offset(-12);
        make.top.equalTo(self.view.mas_top).offset(kHeight_StatusBar + 10);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
}


#pragma mark - private
- (void)loginAction:(UIButton *)btn {
    AccountLoginType type = (AccountLoginType)(btn.tag - 999);
    if( [self checkAgreementCheckboxSelected]) {
        switch (type) {
            case AccountLoginType_phone:{
                PhoneLoginViewController *vc = [[PhoneLoginViewController alloc] init];
                [self pushViewController:vc];
                self.phoneBtnClickTag++;/// 增加点击手机按钮的次数
            }
                break;
            case AccountLoginType_facebook:{
                [self.vm thirdPartAuthorizeWithType:AccountLoginType_facebook];
            }
                break;
            case AccountLoginType_google:{
                [self.vm thirdPartAuthorizeWithType:AccountLoginType_google];
            }
                break;
            case AccountLoginType_apple:{
                [self.vm thirdPartAuthorizeWithType:AccountLoginType_apple];
            }
                break;
            case AccountLoginType_matamask:
                [self.vm thirdPartAuthorizeWithType:AccountLoginType_matamask];
            default:
                break;
        }
    }
}

/// 检查隐私协议是否同意
- (BOOL)checkAgreementCheckboxSelected {
    if (self.checkBoxBtn.selected) {
        return YES;
    }else {
        [ToastTool showToast:kLocalize(@"you_need_to_agree_agreement")];
        return NO;
    }
    return NO;
}

#pragma mark - Delegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if ([[URL scheme] isEqualToString:@"agreement"]) {
        NSString *urlPath = [NSString stringWithFormat:@"UserServiceAgreement?local=%@",[LanguageTool currentLanguageName]];
        NSString *url = WEBURL(urlPath);
        DaleelWebController *vc = [[DaleelWebController alloc] init];
        vc.titleStr = kLocalize(@"user_service_agreement");
        [vc loadURLString:url];
        [self pushViewController:vc];
        return NO;
    }else {
        
        NSString *urlPath = [NSString stringWithFormat:@"PrivacyPolicyRegulation?local=%@",[LanguageTool currentLanguageName]];
        NSString *url = WEBURL(urlPath);
        DaleelWebController *vc = [[DaleelWebController alloc] init];
        vc.titleStr = kLocalize(@"privacy_policy_terms");
        [vc loadURLString:url];
        [self pushViewController:vc];
        return NO;
    }
    return YES;
}

#pragma mark - vmmessage
- (void)vmMessage:(NSString *)messageId data:(id)data {
    if ([messageId isEqualToString:kThirdPartAuthorizeSuccess]) {
        //三方认证成功
        NSDictionary *dic = (NSDictionary *)data;
        DLog(@"Account_Login&Regist_process --- 三方认证成功 %@",[dic valueForKey:@"accountType"]);
        // 判断是否注销了 @{@"userId":uId,@"accountType":@(type)}
        [self.vm vaildAccountWithUid:[dic valueForKey:@"userId"] phoneCountryCode:nil accountType:[(NSNumber *)[dic valueForKey:@"accountType"] integerValue]];
    }else if([messageId isEqualToString:kThirdPartAuthorizeCancel]) {
        DLog(@"Account_Login&Regist_process --- 取消三方认证");
        //取消认证
//        kToast(@"authorizeCancel");
    }else if([messageId isEqualToString:kThirdPartAuthorizeError]) {
        DLog(@"Account_Login&Regist_process --- 三方认证失败");
        // 认证失败失败
//        NSError *error = (NSError *)data;
//        DLog(@"ThirdPartAuthorizeError : %@", error.userInfo);
//        kToast(error.userInfo[kHttpErrorReason]);
    }else if ([messageId isEqualToString:kVaildAccountRegisted]) {
        // 注册过 @{@"userId":uId,@"accountType":@(type)}
        DLog(@"Account_Login&Regist_process --- 判断三方账号注册过 准备开始走登陆接口");
        NSDictionary *dic = (NSDictionary *)data;
        // 登陆
        [self.vm LoginWithUid:[dic valueForKey:@"userId"] countryCode:nil password:nil loginType:[(NSNumber *)[dic valueForKey:@"accountType"] integerValue]];
    }else if ([messageId isEqualToString:kVaildAccountUnRegisted]) {
        // 没注册过
        DLog(@"Account_Login&Regist_process --- 判断三方账号没注册过 准备开始走注册接口");
        NSDictionary *dic = (NSDictionary *)data;
        // 走注册
        [self.vm registWithUid:[dic valueForKey:@"userId"] registType:[(NSNumber *)[dic valueForKey:@"accountType"] integerValue] countryCode:nil password:nil smsCode:nil];
    }else if ([messageId isEqualToString:kVaildAccountDeleted]) {
        // 注销了 冷静期内
        NSDictionary *dic = (NSDictionary *)data;
#warning 注销提醒放在在首页
        // 注销提醒放在在首页 直接登陆
        [self.vm LoginWithUid:[dic valueForKey:@"userId"] countryCode:nil password:nil loginType:[(NSNumber *)[dic valueForKey:@"accountType"] integerValue]];
    }else if ([messageId isEqualToString:kVaildAccountError]) {
        // 判断用户是否注销的接口失败
        DLog(@"Account_Login&Regist_process --- 判断账号是否注销接口调用失败了(判断三方)");
        NSError *error = (NSError *)data;
        DLog(@"VaildAccountError : %@", error.userInfo);
        kToast(error.userInfo[kHttpErrorReason]);
    }else if([messageId isEqualToString:kLoginSuccess]) {
        // 登陆成功
        DLog(@"Account_Login&Regist_process --- 三方账号登陆成功 保存用户信息");
        [[AccountManager sharedInstance] loginedAndSaveUserinfo:(UserModel *)data];
        // 判断用户是否有需要合并数据
        DLog(@"Account_Login&Regist_process --- 三方账号登陆成功 判断是否需要合并数据ing");
        [self.vm checkRouristHavaSyncData];
    }else if([messageId isEqualToString:kLoginError]) {
        // 登陆失败
        DLog(@"Account_Login&Regist_process --- 三方账号登陆失败了");
        NSError *error = (NSError *)data;
        DLog(@"VaildAccountError : %@", error.userInfo);
        kToast(error.userInfo[kHttpErrorReason]);
    }else if ([messageId isEqualToString:kRegistSuccess]) {
        // 注册成功
        DLog(@"Account_Login&Regist_process --- 三方账号注册成功了 保存用户信息");
        [[AccountManager sharedInstance] loginedAndSaveUserinfo:(UserModel *)data];
        // 判断用户是否有需要合并数据
        DLog(@"Account_Login&Regist_process --- 三方账号注册成功了 判断是否需要合并数据ing");
        [self.vm checkRouristHavaSyncData];
    }else if ([messageId isEqualToString:kRegistError]) {
        // 注册失败
        DLog(@"Account_Login&Regist_process --- 三方账号注册失败了");
        NSError *error = (NSError *)data;
        DLog(@"VaildAccountError : %@", error.userInfo);
        kToast(error.userInfo[kHttpErrorReason]);
    }else if ([messageId isEqualToString:kCheckUserDataNeedMerge]) {
        // 需要合并数据
        DLog(@"Account_Login&Regist_process --- 三方账号注册/登陆成功了 需要合并数据 关闭登陆页面 弹出合并弹窗");
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }else if ([messageId isEqualToString:kCheckUserDataNoNeedMerge]) {
        // 不需要合并数据
        DLog(@"Account_Login&Regist_process --- 三方账号登陆/注册成功了 不需要合并数据 直接关闭登陆窗口");
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }else if ([messageId isEqualToString:kCheckUserDataMergeError]) {
        // 合并数据失败
        DLog(@"Account_Login&Regist_process --- 三方账号注册/登陆成功后 合并数据失败了");
        NSError *error = (NSError *)data;
        DLog(@"VaildAccountError : %@", error.userInfo);
        kToast(error.userInfo[kHttpErrorReason]);
    }
}


@end
