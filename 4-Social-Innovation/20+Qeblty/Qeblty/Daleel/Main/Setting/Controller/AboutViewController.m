//
//  AboutViewController.m
//  UISettingView
//
//  Created by mac on 2024/3/29.
//

#import "AboutViewController.h"
#import "AboutTableView.h"
#import "DaleelWebController.h"


@interface AboutViewController ()

@property (nonatomic,strong)UIImageView *logoIconImg;
@property (nonatomic,strong)UILabel *nameLB;
@property (nonatomic,strong)UILabel *versionLB;
@property (nonatomic,strong)AboutTableView *detailTabView;
@property (nonatomic,strong)NSArray *dataArr;

@end

@implementation AboutViewController

#pragma mark -- UI处理
- (void)setupViews{
    [self.view addSubview:self.logoIconImg];
    [self.view addSubview:self.nameLB];
    [self.view addSubview:self.versionLB];
    [self.view addSubview:self.detailTabView];
    
    [self.logoIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(40 + kHeight_NavBar);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.logoIconImg);
        make.top.equalTo(self.logoIconImg.mas_bottom).offset(20);
    }];
    
    [self.versionLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.logoIconImg);
        make.top.equalTo(self.nameLB.mas_bottom).offset(10);
    }];
    [self.detailTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.versionLB.mas_bottom).offset(40);
        make.leading.trailing.bottom.mas_equalTo(0);
    }];
}

- (void)requestData {
    self.detailTabView.dataArr = [NSMutableArray arrayWithArray:self.dataArr];
    [self.detailTabView reloadData];
}

#pragma mark - lazy load
- (UIImageView *)logoIconImg {
    if (!_logoIconImg) {
        _logoIconImg = [[UIImageView alloc] init];
        _logoIconImg.image = kImageName(@"icon_logo");
    }
    return _logoIconImg;
}

- (UILabel *)nameLB {
    if (!_nameLB) {
        _nameLB = [UILabel labelWithTextFont:kFont(28) textColor:[UIColor colorWithHexString:@"#1b1b1b"] text:[DeviceTool appName]];
    }
    return _nameLB;
}

- (UILabel *)versionLB {
    if (!_versionLB) {
        _versionLB = [UILabel labelWithTextFont:kFont(16) textColor:[UIColor colorWithHexString:@"1b1b1b"] text:[NSString stringWithFormat:kLocalize(@"about_version"),[DeviceTool appVersion]]];
    }
    return _versionLB;
}

- (AboutTableView *)detailTabView{
    if (!_detailTabView) {
        _detailTabView = [[AboutTableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        @weakify(self)
        [_detailTabView.didClickCellSubject subscribeNext:^(NSIndexPath *x) {
            @strongify(self)
            [self selectedTableviewAction:x.row];
        }];
    }
    return _detailTabView;
}

- (NSArray *)dataArr {
    if(!_dataArr){
        _dataArr = @[kLocalize(@"about_service"),kLocalize(@"about_policy"),kLocalize(@"about_update")];
    }
    return _dataArr;
}

#pragma mark - event
- (void)selectedTableviewAction:(NSInteger)row {
    switch (row) {
        case 0:{
            NSString *str = self.dataArr[row];
            NSString *urlPath = [NSString stringWithFormat:@"UserServiceAgreement?local=%@",[LanguageTool currentLanguageName]];
            NSString *url = WEBURL(urlPath);
            DaleelWebController *vc = [[DaleelWebController alloc] init];
            vc.titleStr = str;
            [vc loadURLString:url];
            [self pushViewController:vc];
        }break;
        case 1:{
            NSString *str = self.dataArr[row];
            NSString *urlPath = [NSString stringWithFormat:@"PrivacyPolicyRegulation?local=%@",[LanguageTool currentLanguageName]];
            NSString *url = WEBURL(urlPath);
            DaleelWebController *vc = [[DaleelWebController alloc] init];
            vc.titleStr = str;
            [vc loadURLString:url];
            [self pushViewController:vc];
        }break;
        case 2:
            /// 检查更新
//            [DeviceTool checkUpdateVeersion];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://apps.apple.com/us/app/qeblty/id6444711709"] options:@{} completionHandler:^(BOOL success) {
                
            }];
            break;
        default:
            break;
    }
}




@end
