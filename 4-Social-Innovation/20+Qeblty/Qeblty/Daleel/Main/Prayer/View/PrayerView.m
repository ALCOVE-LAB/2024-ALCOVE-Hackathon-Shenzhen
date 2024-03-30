//
//  PrayerView.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "PrayerView.h"
#import "BaseTableView.h"
#import "PrayerAlreadyCell.h"
#import "PrayerToDoCell.h"
#import "PrayerModel.h"
#import "RemindPrayerController.h"
#import "PrayerViewModel.h"
#import "LocalNotificationManager.h"
#import "DownloadSoundManager.h"
#import "PrayTime.h"
#import "BadgesModel.h"

#define kFix  667 / 812.f / kScale_H

@interface PrayerView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIImageView *imgBgView;
@property (nonatomic,strong)BaseTableView *prayerTableView;
@property (nonatomic,strong)PrayerViewModel *prayerViewModel;
@property (nonatomic,strong)PrayerCheckInModel *prayerCheckInModel;
/// 签到按钮 会传回来 为了做动画处理
@property (nonatomic,strong)UIButton *checkInBtn;
@end

@implementation PrayerView

- (void)initialize {
    [self dl_bindViewModel];
}

- (void)dl_bindViewModel {
    @weakify(self);
    [[self.prayerViewModel.getPrayerListSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        /// 把今天所有的列表数据传给后台
        [self dl_reloadData];
    }];
    
    [[self.prayerViewModel.prayerCheckInSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(PrayerCheckInModel  *_Nullable prayerCheckInModel) {
        @strongify(self);
        /// 动画结束 隐藏loading
        [self.checkInBtn.imageView.layer removeAnimationForKey:@"rotationAnimation"];
        [self.checkInBtn setImage:nil forState:UIControlStateNormal];
        if ([prayerCheckInModel isKindOfClass:[PrayerCheckInModel class]]) {
            /// 将签到之后的数据回传
            self.prayerCheckInModel = prayerCheckInModel;
            /// 保存本地设置
            NSString *prayType;
            if (self.prayerViewModel.firstModel && self.prayerViewModel.firstModel.prayType.length > 0 && isService) {
                prayType = self.prayerViewModel.firstModel.prayType;
            }else {
                prayType = self.prayerViewModel.firstNoNetModel.prayType;
            }
            /// 在此处保存一下签到记录  防止在刷新tableView赋值的时候checkInFlag还是之前的值
            [kUserDefaults setBool:YES forKey:[NSString stringWithFormat:@"%@-%@-checkInFlag",kUser.userInfo.userId,prayType]];
            if ([prayType isEqualToString:@"Isha"]) {
                /// 移除昨天保存的值 防止数据太多 占用内存
                [kUserDefaults removeObjectForKey:[NSString stringWithFormat:@"%@-Isha-checkInFlag-%@",kUser.userInfo.userId,[NSString yesterdayTimeFormatted]]];
                /// 如果走到这  证明今天所有的数据都完事了  展示明天得数据
                [kUserDefaults setBool:YES forKey:[NSString stringWithFormat:@"%@-Isha-checkInFlag-%@",kUser.userInfo.userId,[NSString nowTimeFormatted]]];
            }
            [kUserDefaults synchronize];
            
            /// 签到成功之后 访问一次列表接口刷新界面
            [self dl_getRequestWithLatitude:kLatitude andWithLongitude:kLongitudeStr andWithCityName:kCityName];
            /// 判断是否有勋章数组,有的话展示数组弹窗,没有展示签到弹窗
            if (prayerCheckInModel.awardVOS.count > 0) {
                
                AlertTool *alert = [[AlertTool alloc] initWithTitle:kLocalize(@"pray_complete") message:@"You've earned 10 points" image:@"prayer_complete" btnTitle:kLocalize(@"confirm") btnClick:^{ }];
                [alert show];

                
            } else {
                AlertTool *alert = [[AlertTool alloc] initWithTitle:kLocalize(@"pray_complete") message:@"You've earned 10 points" image:@"prayer_complete" btnTitle:kLocalize(@"confirm") btnClick:^{ }];
                [alert show];
            }
        }
    }];
}
#pragma mark --请求数据Command
- (void)dl_getRequestWithLatitude:(NSString *)latitude andWithLongitude:(NSString *)longitude andWithCityName:(NSString *)cityName {
    [self.prayerViewModel dl_getRequestWithLatitude:latitude andWithLongitude:longitude];
}

#pragma mark -- 刷新界面
- (void)dl_reloadData {
    [self.prayerTableView reloadData];
}

#pragma mark --数据处理区域
- (void)setPrayerModel:(PrayerModel *)prayerModel {
    _prayerModel = prayerModel;
    [self dl_reloadData];
}
#pragma mark -- ============================ UI处理 =================================
- (void)setupViews {
    [self addSubview:self.imgBgView];
}

- (UIImageView *)imgBgView {
    if(!_imgBgView){
        _imgBgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_imgBgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"prayer_%@",self.prayerViewModel.firstNoNetModel.prayType]]];
        _imgBgView.userInteractionEnabled = YES;
        
        [_imgBgView addSubview:self.prayerTableView];
        [self.prayerTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.mas_equalTo(0);
            make.top.mas_equalTo(kHeight_NavBar + 6);
        }];
    }
    return _imgBgView;
}

- (BaseTableView *)prayerTableView{
    if(!_prayerTableView){
        _prayerTableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _prayerTableView.backgroundColor = [UIColor clearColor];
        _prayerTableView.dataSource = self;
        _prayerTableView.delegate = self;
        _prayerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _prayerTableView.separatorColor = [UIColor clearColor];
        _prayerTableView.sectionHeaderHeight = 0.01;
        _prayerTableView.sectionFooterHeight = 0.01;
        _prayerTableView.showsVerticalScrollIndicator = NO;
        _prayerTableView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _prayerTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _prayerTableView;
}

#pragma mark --代理处理区域
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    }
    /// 如果listArray有值  则走网络数据
    if (self.prayerViewModel.listArray.count > 0 && isService) {
        return self.prayerViewModel.listArray.count;
    }
    return self.prayerViewModel.noNetListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 112.f * kFix;
    }
    return 80.f * kFix;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return 66 * kFix;
    }
    return 15 * kFix;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        PrayerAlreadyCell *cell = [PrayerAlreadyCell initCellWithTableView:tableView];
        if (self.prayerViewModel.firstModel && isService) {
            /// 访问网络的时候 将firstNoNetModel重新赋值 [self.prayerViewModel dl_getNoNetPrayerModel]  经过此方法重新得到一个新的model
            PrayerModel *model = [self.prayerViewModel dl_getNoNetPrayerModelWithBackGroundModel:self.prayerViewModel.firstModel];
            self.prayerViewModel.firstModel.prayDate = model.prayDate;// 将祈祷日期赋值为本地日期
            self.prayerViewModel.firstModel.prayTime = model.prayTime;// 将祈祷时间赋值为本地时间
            self.prayerViewModel.firstModel.isLocation = self.prayerModel.isLocation;// 更改地理位置权限之后的回调
            /// 处理倒计时和第一组数据相关
            [self dl_dataComepletWithModel:self.prayerViewModel.firstModel andWithListArray:self.prayerViewModel.listArray];
            cell.prayerModel = self.prayerViewModel.firstModel;
        }else {
            /// 将firstNoNetModel重新赋值 [self.prayerViewModel dl_getNoNetPrayerModel] 这个方法只有在这的时候用,其它地方不能用,会导致创建多个prayerModel
            self.prayerViewModel.firstNoNetModel = [self.prayerViewModel dl_getNoNetPrayerModelWithBackGroundModel:[PrayerModel new]];
            self.prayerViewModel.firstNoNetModel.isLocation = self.prayerModel.isLocation;// 更改地理位置权限之后的回调
            /// 处理倒计时和第一组数据相关
            [self dl_dataComepletWithModel:self.prayerViewModel.firstNoNetModel andWithListArray:self.prayerViewModel.noNetListArray];
            cell.prayerModel = self.prayerViewModel.firstNoNetModel;
        }
        @weakify(self);
        cell.prayerAlreadyCellBtnBlock = ^(UIButton * _Nonnull sender) {
            @strongify(self);
            if (sender.tag == 100) { /// 签到按钮回调
                [self dl_checkInBtnClick:sender];
            }else { /// 点击地理位置 去设置定位信息  此处复用nav原来的点击事件  之前的需求是在头部的nav处理  2023年6月1上线版本中更改为点击地理位置
                ExecBlock(self.prayerNavBlock,KNavTips);
            }
        };
        cell.prayerAlreadyCellReloadBlock = ^{ /// 倒计时结束之后 刷新一次界面
            @strongify(self);
            
            [self dl_getRequestWithLatitude:kLatitude andWithLongitude:kLongitudeStr andWithCityName:kCityName];
        };
        return cell;
    }
    PrayerToDoCell *cell = [PrayerToDoCell initCellWithTableView:tableView];
    if(indexPath.row == 0){
        cell.isRadiusTeger = 0;
    }else if (indexPath.row == (self.prayerViewModel.listArray.count > 0 ? self.prayerViewModel.listArray.count : self.prayerViewModel.noNetListArray.count) - 1){
        cell.isRadiusTeger = 1;
    }else{
        cell.isRadiusTeger = 100;
    }
    /// listArray如果有值  则用listArray
    if (self.prayerViewModel.listArray.count > 0 && isService) {
        PrayerModel *prayerModel = self.prayerViewModel.listArray[indexPath.row];
        prayerModel.cellBgColorStr = self.prayerViewModel.firstModel.prayType;
        if (indexPath.row < self.prayerViewModel.listArray.count) {
            prayerModel.prayTime = [self.prayerViewModel dl_getPrayerTimeWithString:prayerModel.prayDateStr][indexPath.row];
            if ([prayerModel.prayType isEqualToString:self.prayerViewModel.firstModel.prayType]) {
                prayerModel.isSelect = YES;
            }else {
                prayerModel.isSelect = NO;
            }
        }
        cell.prayerModel = prayerModel;
    }else {
        PrayerModel *prayerModel = self.prayerViewModel.noNetListArray[indexPath.row];
        if ([prayerModel.prayType isEqualToString:self.prayerViewModel.firstNoNetModel.prayType]) {
            prayerModel.isSelect = YES;
        }else {
            prayerModel.isSelect = NO;
        }
        prayerModel.cellBgColorStr = self.prayerViewModel.firstNoNetModel.prayType;
        cell.prayerModel = prayerModel;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (kUser.userInfo.touristFlag == 1) {
            // 游客点击按钮弹出登陆
            [[AccountManager sharedInstance] pushLogin];
            return;
        }
        if (self.prayerViewModel.listArray.count == 0) {
            kToast(kLocalize(@"noNetCurrent_checkNet"));
            return;
        }
        RemindPrayerController *remindPrayerController = [[RemindPrayerController alloc] initWithPrayerModel:self.prayerViewModel.listArray[indexPath.row] andWithViewModel:self.prayerViewModel andWithModelArr:self.prayerViewModel.listArray];
        @weakify(self);
        remindPrayerController.remindPrayerVCBlock = ^(RemindModel * _Nonnull remindModel) {/// 在铃声界面设置之后的回调
            @strongify(self);
            for (int i = 0; i < self.prayerViewModel.listArray.count; i++) {
                PrayerModel * prayerModel = self.prayerViewModel.listArray[i];
                if ([remindModel.prayType isEqualToString:prayerModel.prayType]) {
                    prayerModel.ringingUrl = remindModel.url;
                    prayerModel.ringingName = remindModel.name;
                    prayerModel.remindType = remindModel.remindType;
                    NSIndexPath *setIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
                    [self.prayerTableView reloadRowsAtIndexPaths:@[setIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        };
        [[UIViewController getCurrentViewController].navigationController pushViewController:remindPrayerController animated:YES];
    }
}

#pragma mark --正常用户登录成功之后需要把游客登录的信息删除
- (void)removeTouristMessage {
    /// 正常用户登录 删除本地保存的首页保存的状态
    for (PrayerModel *prayerModel in self.prayerViewModel.listArray) {
        [kUserDefaults removeObjectForKey:[NSString stringWithFormat:@"%@-%@-ringName",kUser.userInfo.userId,prayerModel.prayType]];
        [kUserDefaults removeObjectForKey:[NSString stringWithFormat:@"%@-%@-remindTime",kUser.userInfo.userId,prayerModel.prayType]];
        [kUserDefaults removeObjectForKey:[NSString stringWithFormat:@"%@-%@-checkInFlag",kUser.userInfo.userId,prayerModel.prayType]];
        /// 移除昨天保存的值
        [kUserDefaults removeObjectForKey:[NSString stringWithFormat:@"%@-Isha-checkInFlag-%@",kUser.userInfo.userId,[NSString yesterdayTimeFormatted]]];
        /// 移除今天保存的值
        [kUserDefaults removeObjectForKey:[NSString stringWithFormat:@"%@-Isha-checkInFlag-%@",kUser.userInfo.userId,[NSString nowTimeFormatted]]];
    }
    /// 正常用户登录,将所有的网络获取数据全部移除
    [self.prayerViewModel.listArray removeAllObjects];
    self.prayerViewModel.firstModel = nil;
}

#pragma mark -- 点击签到按钮
- (void)dl_checkInBtnClick:(UIButton *)sender {
    if (kUser.isLogin) {
        NSInteger offset = [NSTimeZone systemTimeZone].secondsFromGMT;
        offset = offset / 3600;
        NSString *tzStr = [NSString stringWithFormat:@"%ld", (long)offset];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (self.prayerViewModel.firstModel && isService) {
            [params setValue:self.prayerViewModel.firstModel.prayType forKey:@"prayerType"];
        }else {
            [params setValue:self.prayerViewModel.firstNoNetModel.prayType forKey:@"prayerType"];
        }
        [params setValue:tzStr forKey:@"timeZone"];
        [params setValue:[NSString nowTimeInterval] forKey:@"mobileLocalTime"];
        self.checkInBtn = sender;
        [self.prayerViewModel.prayerCheckInCommand execute:params];
    }else {
        ExecBlock(self.prayerViewJumpLoginBlock);
    }
}
#pragma mark -- 拿到model计算第一行的数据
- (void)dl_dataComepletWithModel:(PrayerModel *)prayerModel andWithListArray:(NSArray *)listArray {
    [self.imgBgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"prayer_%@",prayerModel.prayType]]];
    
    prayerModel.timeSecond = (prayerModel.prayDate.integerValue - [NSDate getCurrentStamp]) / 1000;
    if (prayerModel.timeSecond <= 0) {
        prayerModel.isShowCheckBtn = YES;
    }else {
        prayerModel.isShowCheckBtn = NO;
    }
    /// 判断下面选中的项
    for (int i = 0; i < listArray.count; i++) {
        PrayerModel *model = listArray[i];
        if ([model.prayType isEqualToString:prayerModel.prayType]) {
            model.isSelect = YES;
        }else{
            model.isSelect = NO;
        }
    }
}

#pragma mark --懒加载========================================================
- (PrayerViewModel *)prayerViewModel{
    if(!_prayerViewModel){
        _prayerViewModel = [[PrayerViewModel alloc] init];
        @weakify(self);
        _prayerViewModel.prayerBackComeFrontBlock = ^{
            @strongify(self);
            [self dl_reloadData];
        };
    }
    return _prayerViewModel;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
