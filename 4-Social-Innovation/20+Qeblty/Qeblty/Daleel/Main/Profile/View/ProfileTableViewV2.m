//
//  ProfileTableViewV2.m
//  Daleel
//
//  Created by mac on 2024/3/31.
//

#import "ProfileTableViewV2.h"
#import "ProfileHeaderV2View.h"
#import "ProfileModel.h"
#import "SettingCell.h"

@interface ProfileTableViewV2 ()

/// 勋章数据
@property (nonatomic,strong) NSArray<BadgesDetailModel *> *badgeData;
/// tableview header
@property (nonatomic,strong) ProfileHeaderV2View *headerView;

@property (nonatomic, strong) SettingModel *settingModel;


@end

@implementation ProfileTableViewV2

+ (ProfileTableViewV2 *)getProfileTableviewWithFrame:(CGRect)frame {
    ProfileTableViewV2 *profileTableView = [[ProfileTableViewV2 alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    return profileTableView;
}

- (void)initialize {
    [super initialize];
    @weakify(self);
    [[AccountManager sharedInstance] getAccountSate:nil addListenerWithKey:@"SettingTableView" listener:^(AccountManagerState state, id  _Nonnull msg) {
        @strongify(self);
        if(state == AccountManagerState_GuestLogined || state == AccountManagerState_Logined){
            [self reloadData];
        }
    }];
    
    [self registerClass:[SettingCell class] forCellReuseIdentifier:[SettingCell cellIdentifier]];
    
    
    ProfileHeaderV2View *headerView = [[ProfileHeaderV2View alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 122 + 20 + 56)]; //ProfileHeaderV2View 内部会根据用户信息简介高度自适应
    _headerView = headerView;
    
    headerView.editProfileAction = ^{
        @strongify(self);
        ExecBlock(self.editProfileAction);
    };
    headerView.ClickedPointsBlock = ^{
        @strongify(self);
        ExecBlock(self.ClickPoint);
    };
    
    self.dataArr = self.settingModel.settingArr;
    self.tableHeaderView = headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 123.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 46)];
    footerView.backgroundColor = kClearColor;
    UIButton *logBtn = [[UIButton alloc] init];
    logBtn.backgroundColor = RGB(0x28271F);
    logBtn.titleLabel.font = kFontSemibold(16);
    logBtn.layer.cornerRadius = 16.f;
    logBtn.layer.masksToBounds = YES;
    BOOL isGuest = kUser.userInfo.touristFlag;
    if (isGuest) {
        [logBtn setTitle:kLocalize(@"prayer_sign_in") forState:UIControlStateNormal];
        logBtn.tag = 100;
    }else {
        logBtn.tag = 101;
        [logBtn setTitle:kLocalize(@"sign_out") forState:UIControlStateNormal];
    }
    [logBtn addTarget:self action:@selector(logBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:logBtn];
    [logBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.top.mas_offset(23);
        make.size.mas_offset(CGSizeMake(187, 50));
    }];
    
    return footerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingCell *cell = [SettingCell initCellWithTableView:tableView];
    NSDictionary *dict = (NSDictionary *)self.dataArr[indexPath.row];
    cell.title = dict[@"title"];
    cell.imgStr = dict[@"image"];
    if (indexPath.row == 0) {
        cell.isRadiusTeger = 0;
    } else if (indexPath.row == self.dataArr.count - 1) {
        cell.isRadiusTeger = 1;
    } else {
        cell.isRadiusTeger = 100;
    }
    
//    if (indexPath.section == 2 && indexPath.row == 0) {
//        cell.isShowLanguage = YES;
//    }else{
        cell.isShowLanguage = NO;
//    }
    
    return cell;
}

- (void)dl_isRadiusWithIndexPath:(NSIndexPath *)indexPath andWithCell:(SettingCell *)cell andWithDataArr:(NSArray *)dataArr{
    if(indexPath.row == 0){
        cell.isRadiusTeger = 0;
    }else if(indexPath.row == dataArr.count - 1){
        cell.isRadiusTeger = 1;
    }else{
        cell.isRadiusTeger = 100;
    }
}

#pragma mark --一般方法抽取=============================================================
- (void)logBtnClick:(UIButton *)sender {
    ExecBlock(self.SettingTabSignBlock,sender);
}

- (void)updateTableHeaderUserInfo {
    self.headerView.model = kUser.userInfo;
}

- (void)updatePoints {
    self.headerView.model = kUser.userInfo;
}

- (SettingModel *)settingModel {
    if (!_settingModel) {
        _settingModel = [[SettingModel alloc] init];
    }
    return _settingModel;
}
@end
