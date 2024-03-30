//
//  PhoneLoginPwdViewController.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "PhoneLoginPwdViewController.h"

@interface PhoneLoginPwdViewController ()

@property (nonatomic,strong) UITextField *psdTextField;
@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UserModel *lastUserInfo;

@end

@implementation PhoneLoginPwdViewController

- (void)initialize {
    [self bindVM:self.vm];
}

- (void)setupViews {
    UILabel *titleLabel = [UILabel labelWithTextColor:[UIColor colorWithHexString:@"#1B1B1B"] boldFont:30 text:kLocalize(@"sign_in") superView:self.view];
    
    UILabel *detailLabel = [UILabel labelWithTextColor:[UIColor colorWithHexString:@"#666666"] font:14 text:@"" superView:self.view];
    detailLabel.numberOfLines = 0;
    if(![NSString isAllEmpty:self.phoneNum]) {
        NSString *detailStr = [NSString stringWithFormat:kLocalize(@"number_is_registered_please_login"), [NSString stringWithFormat:@"+%@",self.phoneCountryCode],self.phoneNum];
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:detailStr];
        NSRange strRange = [detailStr rangeOfString:self.phoneNum];
        [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1B1B1B"] range:strRange];
        detailLabel.attributedText = attriStr;
    }
    
    // 手机号登陆
    UIView *pwdBgView = [UIView viewWithSuperView:self.view];
    pwdBgView.backgroundColor = [UIColor whiteColor];
    pwdBgView.layer.cornerRadius = 16;
    pwdBgView.layer.masksToBounds = YES;
    
    UITextField *psdTextField = [UITextField new];
    psdTextField.textColor = [UIColor colorWithHexString:@"#1B1B1B"];
    psdTextField.font = [UIFont systemFontOfSize:14];
    psdTextField.placeholder = kLocalize(@"enter_password");
    psdTextField.borderStyle = UITextBorderStyleNone;
    psdTextField.secureTextEntry = YES;
    psdTextField.keyboardType = UIKeyboardTypeASCIICapable;
    psdTextField.limitCount = 18;
    [self.view addSubview:psdTextField];
    _psdTextField = psdTextField;
    @weakify(self);
    [psdTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        self.loginBtn.enabled = (x.length >= 6);
    }];
    
    UIButton *eyeBtn = [UIButton buttonWithSuperView:pwdBgView];
    [eyeBtn setImage:[UIImage imageNamed:@"login_pwd_eye_off"] forState:UIControlStateNormal];
    [eyeBtn setImage:[UIImage imageNamed:@"login_pwd_eye_on"] forState:UIControlStateSelected];
    eyeBtn.imageEdgeInsets = UIEdgeInsetsMake(7, 10, 0, 0);
    [[eyeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        @strongify(self)
        x.selected = !x.selected;
        [self.psdTextField setSecureTextEntry:!x.selected];
    }];
    
    
    // 登陆
    UIButton *loginBtn = [UIButton buttonWithSuperView:self.view];
    loginBtn.enabled = NO;
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"login_phone_login_disable"] forState:UIControlStateDisabled];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"login_phone_login_enable"] forState:UIControlStateNormal];
    _loginBtn = loginBtn;
    [loginBtn addTapAction:^{
        @strongify(self);
        [self loginAction];
    }];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(91, 91));
        make.trailing.equalTo(self.view.mas_trailing).offset(-7);
        make.top.equalTo(pwdBgView.mas_bottom).offset(14);
    }];
    
    [eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 28));
        make.trailing.equalTo(pwdBgView.mas_trailing).offset(-20);
        make.centerY.equalTo(pwdBgView);
    }];
    
    [psdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(pwdBgView.mas_leading).offset(20);
        make.centerY.equalTo(pwdBgView);
        make.trailing.equalTo(eyeBtn.mas_leading).offset(-20);
        make.height.equalTo(@16);
    }];
    
    [pwdBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(15);
        make.trailing.equalTo(self.view.mas_trailing).offset(-15);
        make.height.equalTo(@56);
        make.top.equalTo(detailLabel.mas_bottom).offset(30);
    }];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(20);
        make.trailing.equalTo(self.view.mas_trailing).offset(-20);
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kHeight_NavBar + 20);
        make.leading.equalTo(self.view.mas_leading).offset(20);
    }];
}

#pragma mark -private

- (void)loginAction {
    if([NSString isAllEmpty:self.phoneCountryCode] || [NSString isAllEmpty:self.phoneNum]) {
        return;
    }
    [self.psdTextField resignFirstResponder];
    self.loginBtn.enabled = NO;
    [self.vm LoginWithUid:self.phoneNum countryCode:self.phoneCountryCode password:self.psdTextField.text loginType:AccountLoginType_phone];
}

#pragma mark - vmmessage
- (void)vmMessage:(NSString *)messageId data:(id)data {
    if ([messageId isEqualToString:kLoginSuccess]) {
        DLog(@"Account_Login&Regist_process --- 手机号登陆成功 保存用户信息");
        // 登陆成功
        [[AccountManager sharedInstance] loginedAndSaveUserinfo:(UserModel *)data];
        DLog(@"Account_Login&Regist_process --- 手机号登陆成功 判断需要合并数据ing");
        // 判断是否有合并数据
        [self.vm checkRouristHavaSyncData];
    }else if([messageId isEqualToString:kLoginError]) {
        // 登陆失败
        DLog(@"Account_Login&Regist_process --- 手机号登陆失败");
        NSError *error = (NSError *)data;
        kToast(error.userInfo[kHttpErrorReason]);
        self.loginBtn.enabled = YES;
    }else if ([messageId isEqualToString:kCheckUserDataNeedMerge]) {
        // 需要合并数据
        self.loginBtn.enabled = YES;
        DLog(@"Account_Login&Regist_process --- 手机号登陆成功了 需要合并数据 关闭登陆页面 弹出合并弹窗");
        // 合并数据弹窗
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else if ([messageId isEqualToString:kCheckUserDataNoNeedMerge]) {
        // 不需要合并数据
        self.loginBtn.enabled = YES;
        DLog(@"Account_Login&Regist_process --- 手机号登陆成功了 不需要合并数据 直接关闭登陆窗口");
        [self dismissViewController];
    }else if ([messageId isEqualToString:kCheckUserDataMergeError]) {
        // 判断是否合并数据接口调用失败
        DLog(@"Account_Login&Regist_process --- 手机号登陆成功了 判断是否合并数据接口调用失败！！ 直接关闭登陆窗口");
        NSError *error = (NSError *)data;
        DLog(@"VaildAccountError : %@", error.userInfo);
        kToast(error.userInfo[kHttpErrorReason]);
        // 关闭登陆
        [self dismissViewController];
    }
}

@end
