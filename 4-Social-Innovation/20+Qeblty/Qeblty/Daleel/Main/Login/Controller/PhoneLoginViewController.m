//
//  PhoneLoginViewController.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "PhoneLoginViewController.h"
#import "PhoneLoginPwdViewController.h"
#import "PhoneSignupViewController.h"
#import "PhoneLoginCountryCodeListPopupView.h"
#import "LoginVM.h"

@interface PhoneLoginViewController ()

@property (nonatomic,strong) UIImageView *countryImgv;
@property (nonatomic,strong) UILabel *countryCodeLabel;
@property (nonatomic,strong) UITextField *phoneTextField;
@property (nonatomic,strong) PhoneCountryCodeModel * phoneCodeModel;
@property (nonatomic,strong) UIButton *nextBtn;
@property (nonatomic,strong) LoginVM *vm;

@property (nonatomic,strong) NSArray <PhoneCountryCodeGroupModel *>  *phoneCountryCodeGroupArr;

@end

@implementation PhoneLoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
}

- (void)initialize {
    [super initialize];
    // 生成默认 phoneCodeModel
    self.phoneCodeModel = [[PhoneCountryCodeModel alloc] init];
    self.phoneCodeModel.countryCode = @"996";
    
    self.vm = [[LoginVM alloc] init];
    [self bindVM:self.vm];
    
    
}

- (void)setupViews {
    UILabel *titleLabel = [UILabel labelWithTextColor:[UIColor colorWithHexString:@"#1B1B1B"] boldFont:30 text:kLocalize(@"sign_in") superView:self.view];
    
    UILabel *detailLabel = [UILabel labelWithTextColor:[UIColor colorWithHexString:@"#666666"] font:14 text:kLocalize(@"login_tip_phone_number") superView:self.view];
    detailLabel.numberOfLines = 0;
    
    // 手机号登陆
    UIView *phoneBgView = [UIView viewWithSuperView:self.view];
    phoneBgView.backgroundColor = [UIColor whiteColor];
    phoneBgView.layer.cornerRadius = 16;
    phoneBgView.layer.masksToBounds = YES;
    
    _countryImgv = [UIImageView imgViewWithImg:@"login_countrycode_default" superView:phoneBgView];
    @weakify(self);
    [_countryImgv addTapAction:^{
        @strongify(self);
        [self selectCountryCode];
    }];
    
    /// 国家代码
    _countryCodeLabel = [UILabel labelWithTextColor:[UIColor colorWithHexString:@"#1B1B1B"] font:16 text:@"+996" superView:phoneBgView];
    
    UILabel *cornerLabel = [UILabel labelWithTextColor:[UIColor blackColor] font:16 text:@"▼" superView:phoneBgView];
    
    /// 竖向分割线
    UIView *sepLineView  = [UIView viewWithSuperView:phoneBgView];
    sepLineView.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    
    /// 点击选择国家
    UIButton *selecCountryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneBgView addSubview:selecCountryBtn];
    selecCountryBtn.backgroundColor = kClearColor;
    [[selecCountryBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self selectCountryCode];
    }];
    
    _phoneTextField = [UITextField new];
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTextField.font = kFont(14);
    [phoneBgView addSubview:_phoneTextField];
    [_phoneTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        self.nextBtn.enabled = (x.length > 4);
    }];
    
    // 下一步
    UIButton *nextBtn = [UIButton buttonWithSuperView:self.view];
    nextBtn.enabled = NO;
    [nextBtn setBackgroundImage:[[UIImage imageNamed:@"login_phone_next_disable"] yp_imageFlippedForRightToLeftLayoutDirection] forState:UIControlStateDisabled];
    [nextBtn setBackgroundImage:[[UIImage imageNamed:@"login_phone_next_enable"] yp_imageFlippedForRightToLeftLayoutDirection] forState:UIControlStateNormal];
    _nextBtn = nextBtn;
    [nextBtn addTapAction:^{
        @strongify(self);
        [self nextStepAction];
    }];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(91, 91));
        make.trailing.equalTo(self.view.mas_trailing).offset(-7);
        make.top.equalTo(phoneBgView.mas_bottom).offset(14);
    }];
    
    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(sepLineView.mas_trailing).offset(8);
        make.trailing.equalTo(phoneBgView.mas_trailing).offset(-8);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [sepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1, 28));
        make.leading.equalTo(cornerLabel.mas_trailing).offset(8);
        make.centerY.equalTo(phoneBgView);
    }];
    
    [selecCountryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.mas_equalTo(0);
        make.trailing.equalTo(sepLineView.mas_leading);
    }];
    
    [cornerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phoneBgView);
        make.leading.equalTo(_countryCodeLabel.mas_trailing).offset(4);
    }];
    
    [_countryCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 18));
        make.centerY.equalTo(phoneBgView);
        make.leading.equalTo(_countryImgv.mas_trailing).offset(4);
    }];
    
    [_countryImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(26, 26));
        make.leading.equalTo(phoneBgView.mas_leading).offset(12);
        make.centerY.equalTo(phoneBgView);
    }];
    
    [phoneBgView mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (void)requestData {
    //请求手机国家编号列表数据
    [self.vm getPhoneCountryCodeList];
}

#pragma mark - private
- (void)selectCountryCode {
    [self.phoneTextField resignFirstResponder];
    if(self.phoneCountryCodeGroupArr.count == 0) {
        [self requestData];
        kToast(@"try again later");
        return;
    }
    PhoneLoginCountryCodeListPopupView *countryCodeListView = [PhoneLoginCountryCodeListPopupView creatPopupView];
    [countryCodeListView setCountryCodeListData:self.phoneCountryCodeGroupArr];
    [countryCodeListView showToSuperView:self.view animationStyle:PopupViewAnimateStyle_bottomToTop];
    @weakify(self);
    countryCodeListView.selectCountryCode = ^(PhoneCountryCodeModel * _Nonnull codeModel) {
       @strongify(self);
        [self.countryImgv sd_setImageWithURL:[NSURL URLWithString:codeModel.countryFlags]];
        self.countryCodeLabel.text = [NSString stringWithFormat:@"+%@",codeModel.countryCode];
        self.phoneCodeModel = codeModel;
    };
}

- (void)nextStepAction {
    /// 验证手机号是否登陆了
    if ([NSString isAllEmpty:_countryCodeLabel.text] || [NSString isAllEmpty:self.phoneCodeModel.countryCode]) {
        return;
    }
    self.nextBtn.enabled = NO;
    [self.vm vaildAccountWithUid:self.phoneTextField.text phoneCountryCode:self.phoneCodeModel.countryCode accountType:AccountLoginType_phone];
}



#pragma mark - vmmessage
- (void)vmMessage:(NSString *)messageId data:(id)data {
    if ([messageId isEqualToString:kVaildAccountRegisted]) {
        DLog(@"Account_Login&Regist_process --- 手机号登陆 判断手机号注册过了 准备跳转 输入密码页面登陆");
        // 注册过
        self.nextBtn.enabled = YES;
        // 跳转输入密码页面
        PhoneLoginPwdViewController *vc = [[PhoneLoginPwdViewController alloc] init];
        vc.phoneNum = self.phoneTextField.text;
        vc.phoneCountryCode = self.phoneCodeModel.countryCode;
        vc.vm = self.vm;
        [self pushViewController:vc];
        self.type = 1;
    }else if ([messageId isEqualToString:kVaildAccountUnRegisted]) {
        DLog(@"Account_Login&Regist_process --- 手机号登陆 判断手机号注册过了 准备跳转 注册页面注册");
        // 没过注册
        self.nextBtn.enabled = YES;
        // 跳转注册页面
        PhoneSignupViewController *vc = [[PhoneSignupViewController alloc] init];
        vc.phoneNum = self.phoneTextField.text;
        vc.phoneCountryCode = self.phoneCodeModel.countryCode;
        vc.vm = self.vm;
        [self pushViewController:vc];
        self.type = 2;
    }else if ([messageId isEqualToString:kVaildAccountDeleted]) {
        // 注销了 冷静期内
#warning 注销提醒放在在首页 此处不处理 直接进入输入密码页面
        self.nextBtn.enabled = YES;
        // 跳转输入密码页面
        PhoneLoginPwdViewController *vc = [[PhoneLoginPwdViewController alloc] init];
        vc.phoneNum = self.phoneTextField.text;
        vc.phoneCountryCode = self.phoneCodeModel.countryCode;
        vc.vm = self.vm;
        [self pushViewController:vc];
        self.type = 1;
    }else if ([messageId isEqualToString:kVaildAccountError]) {
        // 判断用户是否注销的接口失败
        NSError *error = (NSError *)data;
        DLog(@"VaildAccountError : %@", error.userInfo);
        kToast(error.userInfo[kHttpErrorReason]);
        self.nextBtn.enabled = YES;
    }else if ([messageId isEqualToString:kPhoneCountryCodeListSuccess]) {
        DLog(@"Account_Login&Regist_process --- 手机号登陆 获取手机号国家code列表 成功");
        // 获取手机号国家code列表 成功
        NSArray <PhoneCountryCodeGroupModel *>  *phoneCountryCodeGroupArr =  (NSArray <PhoneCountryCodeGroupModel *> *)data;
        _phoneCountryCodeGroupArr = phoneCountryCodeGroupArr;
    }else if ([messageId isEqualToString:kPhoneCountryCodeListError]) {
        // 获取手机号国家code列表 失败
        DLog(@"Account_Login&Regist_process --- 手机号登陆 获取手机号国家code列表 失败");
        NSError *error = (NSError *)data;
        DLog(@"VaildAccountError : %@", error.userInfo);
        kToast(error.userInfo[kHttpErrorReason]);
    }
}

@end
