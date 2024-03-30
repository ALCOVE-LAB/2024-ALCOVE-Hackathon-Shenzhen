//
//  RemindView.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "RemindView.h"
#import "BaseTableView.h"
#import "RemindCell.h"
#import "PrayerModel.h"
#import "PrayerViewModel.h"
#import "RemindTimeSetView.h"
#import "ToastTool.h"
#import "DownloadSoundManager.h"
#import "AVAudioManager.h"
#import "ProgressHUD.h"

@interface RemindView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)BaseTableView *remindTabView;

/// 此model是为了方便header头部数据传递
@property (nonatomic,strong)RemindModel *transmitRemindModel;

@property (nonatomic,assign)NSInteger  rowNum;// 标记选中的cell
@property (nonatomic,strong)PrayerViewModel *prayerViewModel;
/// 设置时间popView
@property (nonatomic,strong)RemindTimeSetView *remindTimeSetView;

@property (nonatomic,strong)RemindModel *remindModel;

@end

@implementation RemindView

- (instancetype)initRemindViewWithModel:(PrayerModel *)prayerModel andWithViewModel:(PrayerViewModel *)prayerViewModel {
    if (self == [super init]) {
        self.prayerViewModel = prayerViewModel;
        self.prayerModel = prayerModel;
        [self dl_setupViews];
        [self dl_bindViewModel];
    }
    return self;
}

- (void)dl_bindViewModel {
    @weakify(self);
    [[self.prayerViewModel.getPrayerRingListSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        /// 先停止播放的音乐
        [[AVAudioManager sharedInstance] dl_soundStop];
        /// 给当前的remindTime展示赋值
        self.prayerViewModel.firstRingModel.remindTimeName = [self dl_getModelReturnShowTimeStr:self.prayerModel];
        /// 给当前的remindTime赋值
        self.prayerViewModel.firstRingModel.remindTimeValue = self.prayerModel.remindType;
        /// 保存默认选中的行
        for (int i = 0; i < self.prayerViewModel.ringArray.count; i++) {
            RemindModel *remindModel = self.prayerViewModel.ringArray[i];
            if (remindModel.checkFlag.boolValue) {
                self.rowNum = i;
            }
        }
        
        [self.remindTabView reloadData];
    }];
    /// 铃声接口请求
    [self dl_getCommondWithType:self.prayerModel.prayType];
    
    [[self.prayerViewModel.prayerUnlockRingSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString  *_Nullable popStr) {
        @strongify(self);
        [self dl_getCommondWithType:self.prayerModel.prayType];
        /// 解锁铃声成功之后的弹窗
        AlertTool *alert = [[AlertTool alloc] initWithTitle:popStr message:@"" image:@"prayer_ring_unlock" btnTitle:kLocalize(@"use_it_now") btnClick:^{
            @strongify(self);
            /// 如果选择设置铃声 则访问接口设置铃声
            if (self.prayerViewModel.indexRow >= 0) {
                [self dl_setRingWithRow:self.prayerViewModel.indexRow andWithModel:self.remindModel];
                [UIView performWithoutAnimation:^{
                    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
                    [self.remindTabView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                }];
            }
        }];
        [alert show];
        
        if (self.remindModel.url && [self.remindModel.url containsString:@"http"]) {
            // 下载铃声  解锁成功之后下载铃声
            [[DownloadSoundManager sharedInstance] dl_beginDownLoadSoundsResourceWithUrl:self.remindModel.url andWithProgress:^(NSProgress * _Nonnull downloadProgress) {} andWithCallBack:^(NSString * _Nullable path, BOOL success) {}];
        }
    }];
    
    [[self.prayerViewModel.prayerSetRingSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString  *_Nullable popStr) {
        @strongify(self);
        if (self.remindViewBlock) {
            self.remindViewBlock(self.remindModel);
        }
        [ProgressHUD hideHUDForView:self];
        [ToastTool showToast:popStr];
    }];
}

#pragma mark -- 请求接口
- (void)dl_getCommondWithType:(NSString *)prayerType {
    self.rowNum = -2;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:prayerType forKey:@"prayerType"];
    [self.prayerViewModel.getPrayerRingListCommand execute:params];
}

- (RemindModel *)transmitRemindModel {
    if(!_transmitRemindModel){
        _transmitRemindModel = [[RemindModel alloc] init];
    }
    return _transmitRemindModel;
}

-(void)dl_setupViews {
    
    self.rowNum = -2;
    
    [self addSubview:self.remindTabView];
    [self.remindTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(0);
        make.top.mas_offset(kHeight_NavBar);
    }];
}
/// 传入新的model时候 给相应的remindTime赋新值 切换上面的nav时候用到
- (void)setPrayerModel:(PrayerModel *)prayerModel {
    _prayerModel = prayerModel;
    self.prayerViewModel.firstRingModel.remindTimeName = [self dl_getModelReturnShowTimeStr:prayerModel];
    self.prayerViewModel.firstRingModel.remindTimeValue = prayerModel.remindType;
    self.remindModel.remindType = prayerModel.remindType;
}

#pragma mark --UI处理
- (BaseTableView *)remindTabView {
    if(!_remindTabView){
        _remindTabView = [[BaseTableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _remindTabView.backgroundColor = [UIColor clearColor];
        _remindTabView.dataSource = self;
        _remindTabView.delegate = self;
        _remindTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _remindTabView.separatorColor = [UIColor clearColor];
        _remindTabView.sectionHeaderHeight = 0.01;
        _remindTabView.sectionFooterHeight = 0.01;
        _remindTabView.showsVerticalScrollIndicator = NO;
        _remindTabView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _remindTabView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _remindTabView;
}

#pragma mark --代理处理区域
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    }
    return self.prayerViewModel.ringArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 44.f)];
    headView.backgroundColor = UIColor.clearColor;
    UILabel *titleLB = [UILabel labelWithTextFont:kFont(14) textColor:[UIColor colorWithHexString:@"#666666"] text:self.transmitRemindModel.headerArr[section]];
    [headView addSubview:titleLB];
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(17);
        make.bottom.mas_equalTo(-10);
    }];
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RemindCell *cell = [RemindCell initCellWithTableView:tableView];
    if(indexPath.section == 0){
        self.prayerViewModel.firstRingModel.isRadiusTeger = 2;
        cell.remindModel = self.prayerViewModel.firstRingModel;
    }else{
        RemindModel *remindModel = self.prayerViewModel.ringArray[indexPath.row];
        if(indexPath.row == 0){
            remindModel.isRadiusTeger = 0;
        }else if (indexPath.row == self.prayerViewModel.ringArray.count - 1){
            remindModel.isRadiusTeger = 1;
        }else{
            remindModel.isRadiusTeger = 100;
        }
        if (self.rowNum >= 0) {
            if(indexPath.row == self.rowNum){
                remindModel.checkFlag = @"1";
            }else{
                remindModel.checkFlag = @"0";
            }
        }else if (self.rowNum == -1){
            remindModel.checkFlag = @"0";
        }
        cell.remindModel = remindModel;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        RemindTimeSetView *remindTimeSetView = [[RemindTimeSetView alloc] initRemindTimeSetViewWithViewModel:self.prayerViewModel andWithFrame:self.bounds andWithPrayerModel:self.prayerModel];
        @weakify(self);
        remindTimeSetView.remindTimeSetBlock = ^(NSString * _Nonnull showStr) {
            @strongify(self);
            if (showStr.length != 0) {
                NSString *useTimeStr;
                /// 判断选择的remindTime值 回调展示
                if (showStr.integerValue > 0) {
                    useTimeStr = [NSString stringWithFormat:kLocalize(@"minutes_ahead_remind"),showStr.integerValue];
                    if (showStr.integerValue > 11) {
                        useTimeStr = [NSString stringWithFormat:kLocalize(@"minutes_ahead_remind_more"),showStr.integerValue];
                    }
                } else if (showStr.integerValue == 0) {
                    useTimeStr = kLocalize(@"remind_on_time");
                } else {
                    useTimeStr = [NSString stringWithFormat:kLocalize(@"minutes_delay_remind"),labs(showStr.integerValue)];
                    if (labs(showStr.integerValue) > 11) {
                        useTimeStr = [NSString stringWithFormat:kLocalize(@"minutes_delay_remind_more"),labs(showStr.integerValue)];
                    }
                }
                self.prayerViewModel.firstRingModel.remindTimeName = useTimeStr;
                self.prayerViewModel.firstRingModel.remindTimeValue = showStr;
                [UIView performWithoutAnimation:^{
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [self.remindTabView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }];
                if (self.rowNum >= 0) {/// 如果你先切换铃声 在切换remindTime 则把相应的model传回
                    RemindModel *remindModel = self.prayerViewModel.ringArray[self.rowNum];
                    remindModel.remindType = showStr;
                    if (self.remindViewBlock) {
                        self.remindViewBlock(remindModel);
                    }
                }
            }
            if (self.remindTimeSetView) {
                [self.remindTimeSetView removeFromSuperview];
                self.remindTimeSetView = nil;
            }
        };
        self.remindTimeSetView = remindTimeSetView;
        [self addSubview:remindTimeSetView];
    }
    if(indexPath.section == 1){
        RemindModel *remindModel = self.prayerViewModel.ringArray[indexPath.row];
        remindModel.remindType = self.prayerModel.remindType;
        [[AVAudioManager sharedInstance] dl_soundStop];
        if (remindModel.unlockingFlag.boolValue) {
            if (self.rowNum == indexPath.row) {
                self.rowNum = -1;
            }else {
                [self dl_setRingWithRow:indexPath.row andWithModel:remindModel];
            }
            [UIView performWithoutAnimation:^{
                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
                [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            }];
        } else {
            if (remindModel.allowUnlock.boolValue) {
                @weakify(self);
                [UIAlertController showActionSheetInViewController:[UIViewController getCurrentViewController] withTitle:[NSString stringWithFormat:kLocalize(@"unlock_ringtone"),remindModel.name] message:[NSString stringWithFormat:kLocalize(@"unlock_ring_format"),remindModel.name] cancelButtonTitle:kLocalize(@"cancel") destructiveButtonTitle:kLocalize(@"unlock") otherButtonTitles:@[] tapBlock:^(UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                    @strongify(self);
                    if (buttonIndex == UIAlertControllerBlocksDestructiveButtonIndex) {
                        NSMutableDictionary *params = [NSMutableDictionary dictionary];
                        [params setValue:remindModel.ringingCode forKey:@"ringingName"];
                        self.prayerViewModel.indexRow = indexPath.row;
                        [self.prayerViewModel.prayerUnlockRingCommand execute:params];
                    }
                }];
            }else {
                [UIAlertController showActionSheetInViewController:[UIViewController getCurrentViewController] withTitle:[NSString stringWithFormat:kLocalize(@"remind_ring_unlock_format"),remindModel.unlockPoints] message:[NSString stringWithFormat:kLocalize(@"remind_ring_have_format"),[remindModel.points integerValue]] cancelButtonTitle:kLocalize(@"confirm") destructiveButtonTitle:nil otherButtonTitles:@[] tapBlock:^(UIAlertAction * _Nonnull action, NSInteger buttonIndex) { }];
            }
        }
        self.remindModel.remindType = self.prayerViewModel.firstRingModel.remindTimeValue;
        self.remindModel = remindModel;
    }
}

#pragma mark --选择铃声接口
- (void)dl_setRingWithRow:(NSInteger )indexRow andWithModel:(RemindModel *)remindModel{
    [ProgressHUD showHudInView:self];
    self.rowNum = indexRow;
    if (remindModel.url && remindModel.url.length > 0) {
        NSString *m4aPath = [[[remindModel.url lastPathComponent] componentsSeparatedByString:@"."] firstObject];
        NSString *path = [NSString stringWithFormat:@"%@%@.m4a",[NSHomeDirectory() stringByAppendingString:@"/Library/Sounds/"],m4aPath];
        [[AVAudioManager sharedInstance] dl_playSoundWithUrl:path];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:remindModel.ringingId forKey:@"ringingId"];
    [params setValue:self.prayerModel.prayType forKey:@"prayerType"];
    
    if (kUser.userInfo.touristFlag) {
        [params setValue:kUser.userInfo.userId forKey:@"touristId"];
        [self.prayerViewModel.prayerTouristSetRingCommand execute:params];
    }else {
        [self.prayerViewModel.prayerSetRingCommand execute:params];
    }
}

#pragma mark --拿到祈祷页给的状态 返回相应的字符串
- (NSString *)dl_getModelReturnShowTimeStr:(PrayerModel *)prayerModel{
    NSString *showStr;
    if (prayerModel.remindType.integerValue == 0) {
        showStr = kLocalize(@"remind_on_time");
    }else if (prayerModel.remindType.integerValue > 0) {
        showStr = [NSString stringWithFormat:kLocalize(@"minutes_ahead_remind"),prayerModel.remindType.integerValue];
        if (prayerModel.remindType.integerValue > 11) {
            showStr = [NSString stringWithFormat:kLocalize(@"minutes_ahead_remind_more"),prayerModel.remindType.integerValue];
        }
    }else{
        showStr = [NSString stringWithFormat:kLocalize(@"minutes_delay_remind"),labs(prayerModel.remindType.integerValue)];
        if (labs(prayerModel.remindType.integerValue) > 11) {
            showStr = [NSString stringWithFormat:kLocalize(@"minutes_delay_remind_more"),labs(prayerModel.remindType.integerValue)];
        }
    }
    return showStr;
}

- (RemindModel *)remindModel {
    if(!_remindModel){
        _remindModel = [[RemindModel alloc] init];
    }
    return _remindModel;
}

@end
