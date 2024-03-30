//
//  EditProfileDetailController.m
//  Daleel
//
//  Created by mac on 2024/3/31.
//

#import "EditProfileDetailController.h"

@interface EditProfileDetailController ()<UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong)UIView  *nameBgView;
@property (nonatomic,strong)UITextField  *nameTextField;
@property (nonatomic,strong)UILabel  *strNumLB;
@property (nonatomic,strong)UITextView  *introduceTextView;
@property (nonatomic,strong)UILabel  *placeHolderLB;

@end

@implementation EditProfileDetailController

- (void)initialize {
    self.title = self.type == kEditName ? kLocalize(@"name") : kLocalize(@"introduce");
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
              name:@"UITextFieldTextDidChangeNotification" object:self.nameTextField];
}

- (void)setupViews {
    @weakify(self);
    UIButton *btn = [self addNavRightBarButtonWithImgName:nil title:kLocalize(@"confirm") tapAction:^{
        @strongify(self);
        [self dl_rightBtnClick];
    }];
    [btn setTitleFont:kFontSemibold(16) titleColor:RGB(0xD0B92B)];
    
    CGFloat height = self.type == kEditName ? 58.f : 162.f;
    [self.view addSubview:self.nameBgView];
    [self.nameBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(17);
        make.trailing.mas_equalTo(-17);
        make.top.mas_equalTo(kHeight_NavBar + 20);
        make.height.mas_equalTo(height);
    }];
    
    [self.view addSubview:self.strNumLB];
    [self.strNumLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-17);
        make.top.equalTo(self.nameBgView.mas_bottom).offset(10);
    }];
    
    self.type == kEditName ? [self dl_addEditNameView] : [self dl_addEditIntroduceView];
}

- (void)updateUserInfo:(NSString *_Nullable)name signature:(NSString *_Nullable)signature {
    [ProgressHUD showHudInView:self.view];
    [AccountNetworkTool updateUserInfo:nil nickName:name birthday:nil gender:0 introduction:signature success:^(id  _Nullable responseObject) {
        UserModel *model = [UserModel mj_objectWithKeyValues:responseObject];
        [kUser updateAndSaveUserinfo:model];
        [ProgressHUD hideHUDForView:self.view];
        [self popAnimated];
    } failure:^(NSError * _Nonnull error) {
        kToast(error.userInfo[kHttpErrorReason]);
        [ProgressHUD hideHUDForView:self.view];
    }];
}

#pragma mark -- 编辑名字视图
- (void)dl_addEditNameView {
    [self.nameBgView addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(17);
        make.trailing.mas_equalTo(-17);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeOneCI:)
         name:UITextFieldTextDidChangeNotification
         object:self.nameTextField];
}

#pragma mark -- 编辑介绍页面
- (void)dl_addEditIntroduceView {
    [self.nameBgView addSubview:self.introduceTextView];
    [self.introduceTextView addSubview:self.placeHolderLB];
    
    [self.introduceTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(-7);
        make.top.bottom.mas_equalTo(0);
    }];
    [self.placeHolderLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(5);
        make.top.mas_equalTo(10);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeOneCI:)
         name:UITextFieldTextDidChangeNotification
         object:self.introduceTextView];
}

- (UIView *)nameBgView {
    if(!_nameBgView){
        _nameBgView = [[UIView alloc] init];
        _nameBgView.backgroundColor = UIColor.whiteColor;
        _nameBgView.layer.cornerRadius = 16.f;
        _nameBgView.layer.masksToBounds = YES;
    }
    return _nameBgView;
}

- (UITextField *)nameTextField {
    if(!_nameTextField){
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameTextField.limitCount = 40;
        _nameTextField.placeholder = kLocalize(@"pls_input_your_name");
        _nameTextField.font = kFont(18);
        _nameTextField.text = kUserModel.nickName;
        _nameTextField.delegate = self;
    }
    return _nameTextField;
}

- (UILabel *)strNumLB {
    if(!_strNumLB){
        NSInteger maxIn = self.type == kEditName ? 40 : 120;
        NSInteger orgineStrLength = self.type == kEditName ? kUserModel.nickName.length : kUserModel.introduction.length;
        _strNumLB = [UILabel labelWithTextFont:kFont(15) textColor:RGB(0x999999) text:[NSString stringWithFormat:@"0/%ld",maxIn]];
        if (orgineStrLength > 0) {
            _strNumLB = [UILabel labelWithTextFont:kFont(15) textColor:RGB(0x999999) text:[NSString stringWithFormat:@"%ld/%ld",orgineStrLength,maxIn]];
        }
    }
    return _strNumLB;
}

- (UITextView *)introduceTextView {
    if (!_introduceTextView) {
        _introduceTextView = [[UITextView alloc] init];
        _introduceTextView.limitCount = 120;
        _introduceTextView.hasLimitLabel = YES;
        _introduceTextView.delegate = self;
        _introduceTextView.font = kFont(18);
        _introduceTextView.text = kUserModel.introduction;
    }
    return _introduceTextView;
}

- (UILabel *)placeHolderLB {
    if(!_placeHolderLB){
        _placeHolderLB = [UILabel labelWithTextFont:kFont(18) textColor:RGB(0x999999) text:kLocalize(@"pls_input_your_introduce")];
        _placeHolderLB.hidden = kUserModel.introduction.length > 0;
    }
    return _placeHolderLB;
}

#pragma mark -- 代理处理区域
- (void)textFieldTextDidChangeOneCI:(NSNotification *)notification{
    UITextField * textfield = [notification object];
    self.strNumLB.text = [NSString stringWithFormat:@"%lu/40",(unsigned long)textfield.text.length];
}

- (void)textViewDidChange:(UITextView *)textView{
    self.placeHolderLB.hidden = textView.text.length != 0;
    self.strNumLB.text = [NSString stringWithFormat:@"%lu/120",textView.text.length];
}

/// 限制字符方法
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.text.length - range.length + text.length > 120) {
        return NO;
    }
    return YES;
}

-(void) textFiledEditChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];       //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 40) {
                textField.text = [toBeString substringToIndex:40];
            }
        }       // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }   // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况   else{
    if (toBeString.length > 40) {
        textField.text = [toBeString substringToIndex:40];
    }
}

#pragma mark - event
- (void)dl_rightBtnClick {
    if (self.type == kEditName) {
        if (self.nameTextField.text == 0){
            [ToastTool showToast:kLocalize(@"pls_enter_your_name")];
            return;
        }
        [self updateUserInfo:self.nameTextField.text signature:nil];
    }else{
        if (self.introduceTextView.text.length <= 0) {
            kToast(kLocalize(@"pls_enter_your_introduce"));
            return;
        }
        [self updateUserInfo:nil signature:self.introduceTextView.text];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
