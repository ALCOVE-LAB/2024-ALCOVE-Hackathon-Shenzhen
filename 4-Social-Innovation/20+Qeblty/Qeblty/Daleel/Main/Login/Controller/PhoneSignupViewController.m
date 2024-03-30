//
//  PhoneSignupViewController.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "PhoneSignupViewController.h"
#import "TimerTaskManager.h"

@interface PhoneSignupViewController ()

@property (nonatomic,strong) UITextField *psdTextField;
@property (nonatomic,strong) UIButton *getCodeBtn;
@property (nonatomic,strong) UITextField *codeTextField;
@property (nonatomic,strong) UIButton *signupBtn;

@end

@implementation PhoneSignupViewController

- (void)initialize {
    [self bindVM:self.vm];
}

- (void)setupViews {
    UILabel *titleLabel = [UILabel labelWithTextColor:[UIColor colorWithHexString:@"#1B1B1B"] boldFont:30 text:kLocalize(@"sign_up") superView:self.view];
    
    UILabel *detailLabel = [UILabel labelWithTextColor:[UIColor colorWithHexString:@"#666666"] font:14 text:@"" superView:self.view];
    detailLabel.numberOfLines = 0;
    
    if(![NSString isAllEmpty:self.phoneNum]){
        NSString *detailStr = [NSString stringWithFormat:kLocalize(@"sign_up_tip"), [NSString stringWithFormat:@"+%@",self.phoneCountryCode],self.phoneNum];
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:detailStr];
        NSRange strRange = [detailStr rangeOfString:self.phoneNum];
        [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1B1B1B"] range:strRange];
        detailLabel.attributedText = attriStr;
    }
    
    UIView *signupBgView = [UIView viewWithSuperView:self.view];
    signupBgView.backgroundColor = [UIColor whiteColor];
    signupBgView.layer.cornerRadius = 16;
    signupBgView.layer.masksToBounds = YES;
    
    UITextField *codeTextField = [[UITextField alloc] init];
    codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    codeTextField.font = [UIFont systemFontOfSize:14];
    codeTextField.placeholder = kLocalize(@"please_input_code");
    [signupBgView addSubview:codeTextField];
    codeTextField.limitCount = 6;
    _codeTextField = codeTextField;
    @weakify(self);
    [codeTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        self.signupBtn.enabled = ((x.length >= 4) && self.psdTextField.text.length >= 4); //此处只判断最小长度字符  && self.psdTextField.text.length <= 8
    }];
    
    _getCodeBtn = [UIButton buttonWithSuperView:signupBgView];
    [_getCodeBtn setTitle:kLocalize(@"get") forState:UIControlStateNormal];
    [_getCodeBtn setTitleColor:[UIColor colorWithHexString:@"#D0B92B"] forState:UIControlStateNormal];
    _getCodeBtn.layer.cornerRadius = 20;
    _getCodeBtn.layer.borderWidth = 1;
    _getCodeBtn.layer.borderColor = [UIColor colorWithHexString:@"#D0B92B"].CGColor;
    [signupBgView addSubview:_getCodeBtn];
    [_getCodeBtn addTapAction:^{
       @strongify(self);
        [self getCodeAction];
    }];
    
    UIView *sepLineView = [UIView viewWithSuperView:signupBgView];
    sepLineView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    UITextField *psdTextField = [UITextField new];
    psdTextField.textColor = [UIColor colorWithHexString:@"#1B1B1B"];
    psdTextField.font = [UIFont systemFontOfSize:14];
    psdTextField.placeholder = kLocalize(@"enter_password");
    psdTextField.borderStyle = UITextBorderStyleNone;
    psdTextField.secureTextEntry = YES;
    psdTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [signupBgView addSubview:psdTextField];
    psdTextField.limitCount = 18;
    _psdTextField = psdTextField;
    [psdTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        self.signupBtn.enabled = ((x.length >= 4) && self.codeTextField.text.length >= 4);
    }];
    
    UIButton *eyeBtn = [UIButton buttonWithSuperView:signupBgView];
    [eyeBtn setImage:[UIImage imageNamed:@"login_pwd_eye_off"] forState:UIControlStateNormal];
    [eyeBtn setImage:[UIImage imageNamed:@"login_pwd_eye_on"] forState:UIControlStateSelected];
    eyeBtn.imageEdgeInsets = UIEdgeInsetsMake(7, 10, 0, 0);
    [[eyeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        @strongify(self)
        x.selected = !x.selected;
        [self.psdTextField setSecureTextEntry:!x.selected];
    }];
    
    // 登陆
    UIButton *signupBtn = [UIButton buttonWithSuperView:self.view];
    signupBtn.enabled = NO;
    [signupBtn setBackgroundImage:[UIImage imageNamed:@"login_phone_login_disable"] forState:UIControlStateDisabled];
    [signupBtn setBackgroundImage:[UIImage imageNamed:@"login_phone_login_enable"] forState:UIControlStateNormal];
    _signupBtn = signupBtn;
    [signupBtn addTapAction:^{
        @strongify(self);
        [self registAccount];
    }];
    
    [signupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(91, 91));
        make.trailing.equalTo(self.view.mas_trailing).offset(-7);
        make.top.equalTo(signupBgView.mas_bottom).offset(14);
    }];
    
    [eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 28));
        make.trailing.equalTo(signupBgView.mas_trailing).offset(-20);
        make.centerY.equalTo(psdTextField);
    }];
    
    [psdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(signupBgView.mas_leading).offset(20);
        make.trailing.equalTo(eyeBtn.mas_leading).offset(-20);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(sepLineView.mas_bottom);
    }];
    
    [sepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(signupBgView.mas_leading).offset(20);
        make.trailing.equalTo(signupBgView.mas_trailing).offset(-20);
        make.height.equalTo(@1);
        make.centerY.equalTo(signupBgView);
    }];
    
    [codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(signupBgView.mas_leading).offset(20);
        make.trailing.equalTo(_getCodeBtn.mas_leading).offset(-20);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(sepLineView.mas_top);
    }];
    
    [_getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 40));
        make.centerY.equalTo(codeTextField);
        make.trailing.equalTo(signupBgView.mas_trailing).offset(-20);
    }];
    
    [signupBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(15);
        make.trailing.equalTo(self.view.mas_trailing).offset(-15);
        make.height.equalTo(@113);
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

- (void)requestData {
    //判断是否存在已经进行的倒计时
    [self getCodeBtnTimerState];
}

#pragma mark - private
- (void)getCodeBtnTimerState {
    TimerTask *task = [[TimerTaskManager sharedInstance] getTimerTaskWithTaskId:@"getCode"];
    if(task) { // 存在倒计时
        @weakify(self);
        task.handler = ^(NSString *taskId, float currentTime) {
            @strongify(self);
//            DLog(@"获取验证码倒计时 %@ -  %f", taskId,currentTime);
            if(currentTime == 0) {
                self.getCodeBtn.enabled = YES;
                [self.getCodeBtn setTitle:kLocalize(@"get") forState:UIControlStateNormal];
            }else{
                self.getCodeBtn.enabled = NO;
                [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%.0f",currentTime] forState:UIControlStateDisabled];
            }
        };
    }
}

- (void)startCodeTimer {
    @weakify(self);
    self.getCodeBtn.enabled = NO;
    TimerTask *task = [[TimerTask alloc] initWithTaskId:@"getCode" StartTime:60 endTime:0 timerInterval:-1 handleBlock:^(NSString *taskId, float currentTime) {
        @strongify(self);
//        DLog(@"获取验证码倒计时 %@ -  %f", taskId,currentTime);
        if(currentTime == 0) {
            self.getCodeBtn.enabled = YES;
            [self.getCodeBtn setTitle:kLocalize(@"get")  forState:UIControlStateNormal];
        }else{
            self.getCodeBtn.enabled = NO;
            [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%.0f",currentTime] forState:UIControlStateDisabled];
        }
    }];
    [[TimerTaskManager sharedInstance] runTimeTask:task];
}

- (void)getCodeAction {
    self.getCodeBtn.enabled = NO;
    [self.vm getSmsCodeWithPhoneNum:self.phoneNum countryCode:self.phoneCountryCode type:AccountLoginType_phone];
}

/// 注册账号
- (void)registAccount {
    [self.psdTextField resignFirstResponder];
    if([NSString isAllEmpty:self.codeTextField.text] || [NSString isAllEmpty:self.phoneNum] || [NSString isAllEmpty:self.phoneCountryCode]){
        return;
    }
    if(self.psdTextField.text.length < 4 || self.psdTextField.text.length > 8) {
        [UIAlertController showActionSheetInViewController:self withTitle:kLocalize(@"password_wrong_title") message:kLocalize(@"password_wrong_content") cancelButtonTitle:kLocalize(@"confirm") destructiveButtonTitle:nil otherButtonTitles:@[] tapBlock:^(UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
        }];
        return;
    }
    self.signupBtn.enabled = NO;
    [self.vm registWithUid:self.phoneNum registType:AccountLoginType_phone countryCode:self.phoneCountryCode password:_psdTextField.text smsCode:self.codeTextField.text];
}

#pragma mark - vmmessage
- (void)vmMessage:(NSString *)messageId data:(id)data {
    if([messageId isEqualToString:kRegistSuccess]) {
        // 注册成功
        DLog(@"Account_Login&Regist_process --- 手机号注册成功 保存用户信息");
        [[AccountManager sharedInstance] loginedAndSaveUserinfo:(UserModel *)data];
        DLog(@"Account_Login&Regist_process --- 手机号注册成功 判断需要合并数据ing");
        [self.vm checkRouristHavaSyncData];
    }else if ([messageId isEqualToString:kRegistError]) {
        // 注册失败
        DLog(@"Account_Login&Regist_process --- 手机号注册失败");
        NSError *error = (NSError *)data;
        [ToastTool showToast:error.userInfo[kHttpErrorReason]];
        self.signupBtn.enabled = YES;
    }else if ([messageId isEqualToString:kSendSmsCodeSuccess]) {
        // 发送验证码 成功
        DLog(@"Account_Login&Regist_process --- 手机号注册 发送验证码 成功");
        [ToastTool showToast:[NSString stringWithFormat:kLocalize(@"verification_code_sent_to"),self.phoneNum]];
        [self startCodeTimer];
    }else if ([messageId isEqualToString:kSendSmsCodeError]) {
        // 发送验证码 失败
        DLog(@"Account_Login&Regist_process --- 手机号注册 发送验证码 失败");
        [ToastTool showToast:kLocalize(@"Failed to send verification code")];
        self.getCodeBtn.enabled = YES;
        NSError *error = (NSError *)data;
        DLog(@"SendSmsCodeError %@", error.userInfo);
        kToast(error.userInfo[kHttpErrorReason]);
    }else if ([messageId isEqualToString:kCheckUserDataNeedMerge]) {
        // 需要合并数据
        self.signupBtn.enabled = YES;
        DLog(@"Account_Login&Regist_process --- 手机号注册成功 需要合并数据 关闭登陆窗口 弹出合并弹窗");
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }else if ([messageId isEqualToString:kCheckUserDataNoNeedMerge]) {
        // 不需要合并数据
        self.signupBtn.enabled = YES;
        DLog(@"Account_Login&Regist_process --- 手机号注册成功 不需要合并数据 直接关闭登陆窗口");
        [self dismissViewController];
    }else if ([messageId isEqualToString:kCheckUserDataMergeError]) {
        // 判断是否合并数据接口调用失败
        self.signupBtn.enabled = YES;
        DLog(@"Account_Login&Regist_process --- 手机号注册 判断是否合并数据接口调用失败");
        NSError *error = (NSError *)data;
        DLog(@"VaildAccountError : %@", error.userInfo);
        kToast(error.userInfo[kHttpErrorReason]);
        // 关闭登陆
        [self dismissViewController];
    }
}

@end
