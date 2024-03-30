//
//  LoginForUnexpectedViewController.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "LoginForUnexpectedViewController.h"
#import "LoginVM.h"
#import "PhoneLoginViewController.h"
#import "DaleelWebController.h"

@interface LoginForUnexpectedViewController ()<VMMessageDelegate,UITextViewDelegate>

@property (nonatomic,strong) UIButton *checkBoxBtn;
@property (nonatomic,strong) LoginVM *vm;

@end

@implementation LoginForUnexpectedViewController

- (void)initialize {
    self.vm = [[LoginVM alloc] init];
    [self bindVM:self.vm];
    self.isHideNav = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.4];
}

- (void)setupViews {
    [super setupViews];
    
    // 意外登出不会删除保存的用户数据
    UserModel *lastUserInfo = kUser.userInfo;
    
    UIView *bgView  = [UIView viewWithSuperView:self.view];
    bgView.frame = CGRectMake(0, 0, self.view.width, 355);
    bgView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [bgView drawCornerRadius:16 withSize:CGSizeMake(self.view.width, 355) cornerType:UIRectCornerTopLeft|UIRectCornerTopRight];
    
    
    UILabel *titleLabel = [UILabel labelWithTextColor:[UIColor colorWithHexString:@"#1B1B1B"] boldFont:18 text:kLocalize(@"sign_in_status_invalid") superView:bgView];
    
    UIButton *closeBtn = [UIButton buttonWithSuperView:bgView];
    [closeBtn setImage:[UIImage imageNamed:@"common_close"] forState:UIControlStateNormal];
    closeBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 0, 0);
    [bgView addSubview:closeBtn];
    @weakify(self);
    [closeBtn addTapAction:^{
        @strongify(self);
        ExecBlock(self.closeBtnBlock);
        [self dismissViewController];
    }];
    
    UIImageView *headImgv = [UIImageView imgViewWithImg:@"avatar_default" superView:bgView];
    headImgv.layer.cornerRadius = 40;
    headImgv.layer.masksToBounds = YES;
    [headImgv sd_setImageWithURL:[NSURL URLWithString:lastUserInfo.headUrl] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    
    UILabel *nameLabel = [UILabel labelWithTextColor:[UIColor colorWithHexString:@"#1B1B1B"] boldFont:14 text:@"name" superView:bgView];
    nameLabel.text = lastUserInfo.nickName;
    
    // 登陆按钮  下面数据可配置
    NSArray *loginBtnTypeArr;
    if(@available(iOS 13.0 , *)) {
        loginBtnTypeArr = @[
#if DEBUG
            @{@"login_icon":@"login_phone_icon",@"accountLoginType":@(AccountLoginType_phone)},
#endif
//        @{@"login_icon":@"login_facebook_icon",@"accountLoginType":@(AccountLoginType_facebook)},
        @{@"login_icon":@"login_google_icon",@"accountLoginType":@(AccountLoginType_google)},
        @{@"login_icon":@"login_apple_icon",@"accountLoginType":@(AccountLoginType_apple)}
        ];
    }else{
        loginBtnTypeArr = @[
#if DEBUG
            @{@"login_icon":@"login_phone_icon",@"accountLoginType":@(AccountLoginType_phone)},
#endif
//        @{@"login_icon":@"login_facebook_icon",@"accountLoginType":@(AccountLoginType_facebook)},
        @{@"login_icon":@"login_google_icon",@"accountLoginType":@(AccountLoginType_google)}
        ];
    }
    float leadingOffset = (bgView.width - (loginBtnTypeArr.count * 78 + ((loginBtnTypeArr.count - 1) * 4))) / 2;
    for (int i = 0; i < loginBtnTypeArr.count; i++) {
        UIButton *loginBtn = [UIButton buttonWithSuperView:bgView];
        [loginBtn setBackgroundImage:[UIImage imageNamed:(NSString *)[loginBtnTypeArr[i] valueForKey:@"login_icon"]] forState:UIControlStateNormal];
        loginBtn.tag = [[loginBtnTypeArr[i] valueForKey:@"accountLoginType"] integerValue] + 999;
        [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //添加上次登陆的标记
        if(lastUserInfo.registerType == [[loginBtnTypeArr[i] valueForKey:@"accountLoginType"] integerValue]) {
            UIView *signBgView = [UIView viewWithSuperView:loginBtn];
            signBgView.backgroundColor = [UIColor gradientFromColor:[UIColor colorWithHexString:@"#514F42"] toColor:[UIColor colorWithHexString:@"#000000"] withWidth:48];
            if(kIsAR) {
                [signBgView drawCornerRadius:8 withSize:CGSizeMake(48, 16) cornerType:UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft];
            }else {
                [signBgView drawCornerRadius:8 withSize:CGSizeMake(48, 16) cornerType:UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomRight];
            }
            
            UILabel *signLabel = [UILabel labelWithTextColor:[UIColor colorWithHexString:@"#FFF7D6"] font:8 text:kLocalize(@"last_used") superView:signBgView];
            signLabel.textAlignment = NSTextAlignmentCenter;
            
            [signBgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(48, 16));
                make.leading.equalTo(loginBtn.mas_centerX).offset(0);
                make.bottom.equalTo(loginBtn.mas_centerY).offset(-15);
            }];
            
            [signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(signBgView);
                make.leading.trailing.equalTo(signBgView);
            }];
        }
        
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(78, 78));
            make.leading.equalTo(bgView.mas_leading).offset((78 + 4) * i + leadingOffset);
            make.top.equalTo(nameLabel.mas_bottom).offset(16);
        }];
    }
    
    /// 协议
    UIButton *checkBoxBtn = [UIButton buttonWithSuperView:bgView];
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
    [bgView addSubview:textView];
    [textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(bgView.mas_trailing).offset(-24);
        make.leading.equalTo(checkBoxBtn.mas_trailing).offset(10);
        make.top.equalTo(checkBoxBtn.mas_top).offset(-10);
        make.height.equalTo(@60);
    }];
    
    [checkBoxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.leading.equalTo(bgView.mas_leading).offset(30);
        make.bottom.equalTo(bgView.mas_bottom).offset(-40);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headImgv);
        make.top.equalTo(headImgv.mas_bottom).offset(6);
    }];
    
    [headImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.top.equalTo(titleLabel.mas_bottom).offset(28);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(bgView.mas_trailing).offset(-17);
        make.top.equalTo(bgView.mas_top).offset(17);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.top.equalTo(bgView.mas_top).offset(24);
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@355);
        make.width.equalTo(@kScreenWidth);
        make.leading.equalTo(self.view.mas_leading).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
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
    if ([[URL scheme] isEqualToString:@"Agreement"]) {
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
        //取消认证
        DLog(@"Account_Login&Regist_process --- 取消三方认证");
//        kToast(@"authorizeCancel");
    }else if([messageId isEqualToString:kThirdPartAuthorizeError]) {
        DLog(@"Account_Login&Regist_process --- 三方认证失败");
        // 认证失败失败
//        NSError *error = (NSError *)data;
//        DLog(@"ThirdPartAuthorizeError : %@", error.userInfo);
//        kToast(error.userInfo[kHttpErrorReason]);
    }else if ([messageId isEqualToString:kVaildAccountRegisted]) {
        DLog(@"Account_Login&Regist_process --- 判断三方账号注册过 准备开始走登陆接口");
        // 注册过 @{@"userId":uId,@"accountType":@(type)}
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
        NSError *error = (NSError *)data;
        DLog(@"VaildAccountError : %@", error.userInfo);
        kToast(error.userInfo[kHttpErrorReason]);
    }else if([messageId isEqualToString:kLoginSuccess]) {
        /// 异常登出后 在登陆不会存在合并数据的情况
        DLog(@"Account_Login&Regist_process --- 三方账号登陆成功 保存用户信息");
        [[AccountManager sharedInstance] loginedAndSaveUserinfo:(UserModel *)data];
        [self dismissViewController];
    }else if([messageId isEqualToString:kLoginError]) {
        DLog(@"Account_Login&Regist_process --- 三方账号登陆失败了");
        // 登陆失败
        NSError *error = (NSError *)data;
        DLog(@"VaildAccountError : %@", error.userInfo);
        kToast(error.userInfo[kHttpErrorReason]);
    }else if ([messageId isEqualToString:kRegistSuccess]) {
        // 注册成功,进入首页
        DLog(@"Account_Login&Regist_process --- 三方账号注册成功了 保存用户信息");
        [[AccountManager sharedInstance] loginedAndSaveUserinfo:(UserModel *)data];
        [self dismissViewController];
    }else if ([messageId isEqualToString:kRegistError]) {
        // 注册失败
        DLog(@"Account_Login&Regist_process --- 三方账号注册失败了");
        NSError *error = (NSError *)data;
        DLog(@"VaildAccountError : %@", error.userInfo);
        kToast(error.userInfo[kHttpErrorReason]);
    }
}


@end
