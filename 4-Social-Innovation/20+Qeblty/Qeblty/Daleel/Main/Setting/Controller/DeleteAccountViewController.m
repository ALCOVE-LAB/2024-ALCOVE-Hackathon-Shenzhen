//
//  DeleteAccountViewController.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "DeleteAccountViewController.h"
#import "DeleteInfoView.h"
#import "DeleteAccountTermController.h"

@interface DeleteAccountViewController ()

@property(nonatomic,strong)DeleteInfoView *infoView;

@end

@implementation DeleteAccountViewController

- (void)initialize {
    self.title = kLocalize(@"delete_account");
    self.view.backgroundColor = kPublicBgColor;
}

- (void)setupViews {
    UILabel *titleLabel = [UILabel labelWithTextFont:kFontRegular(14) textColor:RGB(0x666666) text:kLocalize(@"logged_in_account")];
    [self.view addSubview:titleLabel];
    [self.view addSubview:self.infoView];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(17);
        make.top.mas_equalTo(kHeight_NavBar+20);
    }];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(17);
        make.trailing.mas_equalTo(-17);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(90);
    }];
    
    UILabel *label = [UILabel labelWithTextFont:kFontMedium(16) textColor:RGB(0x1B1B1B) text:kLocalize(@"if_you_delete_your_current_account")];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.infoView);
        make.top.mas_equalTo(self.infoView.mas_bottom).offset(10);
    }];
    
    UIButton *deleteBtn = [UIButton buttonWithTitleFont:kFontSemibold(18) titleColor:RGB(0xFFF7D6) title:kLocalize(@"delete_my_account")];
    deleteBtn.backgroundColor = RGB(0x28271F);
    deleteBtn.layer.cornerRadius = 16;
    deleteBtn.layer.masksToBounds = YES;
    [self.view addSubview:deleteBtn];
    @weakify(self)
    [[deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self deleteAction];
    }];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-30);
        make.size.mas_equalTo(CGSizeMake(210, 50));
        make.centerX.mas_equalTo(0);
    }];
    
    UITextView *contentTV = [[UITextView alloc] init];
    contentTV.backgroundColor = kClearColor;
    contentTV.editable = NO;
    contentTV.textColor = RGB(0x1B1B1B);
    contentTV.font = kFontRegular(16);
    contentTV.text = kLocalize(@"delete_account_tips");
    [self.view addSubview:contentTV];
    [contentTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.infoView);
        make.top.mas_equalTo(label.mas_bottom).offset(8);
        make.bottom.mas_equalTo(deleteBtn.mas_top).offset(-40);
    }];
}

- (DeleteInfoView *)infoView {
    if (!_infoView) {
        _infoView = [[DeleteInfoView alloc] init];
    }
    return _infoView;
}

#pragma mark - event
- (void)deleteAction {
    DeleteAccountTermController *vc = [[DeleteAccountTermController alloc] init];
    [self pushViewController:vc];
}

@end
