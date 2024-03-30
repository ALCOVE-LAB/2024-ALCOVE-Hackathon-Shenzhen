//
//  PrayerViewModel.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "PrayerViewModel.h"
#import "PrayerNetworkTool.h"
#import "PrayerModel.h"
#import "PrayTime.h"
#import "LocalNotificationManager.h"
#import "DownloadSoundManager.h"

@interface PrayerViewModel ()

@property (nonatomic,copy)NSString *lastPrayTime;

@property (nonatomic,strong)UIViewController *becomeVC;

/// 定时器
@property (nonatomic, strong) RACDisposable *disposable;

@end

@implementation PrayerViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _getPrayerListSubject = [RACSubject subject];
        _getPrayerRingListSubject = [RACSubject subject];
        _prayerCheckInSubject = [RACSubject subject];
        _prayerCheckInDaysSubject = [RACSubject subject];
        _prayerUnlockRingSubject = [RACSubject subject];
        _prayerSetRingSubject = [RACSubject subject];
        _prayerTimeSetBeforeOrDelaySubject = [RACSubject subject];
        //        _googleTokenSubject = [RACSubject subject];
        _googlePushSubject = [RACSubject subject];
        [self dl_observeNetChange];
        self.indexRow = -1;
        
        /// app从后台进入前台刷新一次界面
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
        
        [self dl_initViewModel];
    }
    return self;
}
#pragma mark -- 监听网络变化
- (void)dl_observeNetChange {
    // 检测网络连接的单例,网络变化时的回调方法
    @weakify(self);
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        @strongify(self);
        if (status == 1 || status == 2) {
            [self dl_getRequestWithLatitude:[kUserDefaults objectForKey:kLocationLatitude] andWithLongitude:[kUserDefaults objectForKey:kLocationlongitude]];
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)dl_initViewModel {
    @weakify(self);
    [self.getPrayerLogListCommand.executionSignals.switchToLatest subscribeNext:^(NSArray * _Nullable resultArr) {
        @strongify(self);
        [self.listArray removeAllObjects];
        for (int i = 0; i < resultArr.count; i++) {
            NSDictionary *dataDic = resultArr[i];
            if(i == 0){
                self.firstModel = [PrayerModel mj_objectWithKeyValues:dataDic];
            }else{
                PrayerModel *model = [PrayerModel mj_objectWithKeyValues:dataDic];
                [self.listArray addObject:model];
            }
        }
        self.prayerListArr = resultArr;/// 保存返回的数组
        [self.getPrayerListSubject sendNext:nil];
    }];
    
    [self.getPrayerRingListCommand.executionSignals.switchToLatest subscribeNext:^(NSArray * _Nullable resultArr) {
        @strongify(self);
        [self.ringArray removeAllObjects];
        
        RemindModel *remindModel = [[RemindModel alloc] init];
        remindModel.checkFlag = @"0";
        remindModel.isShowArrow = YES;
        self.firstRingModel = remindModel;
        
        for (NSDictionary *dataDic in resultArr) {
            RemindModel *model = [RemindModel mj_objectWithKeyValues:dataDic];
            [self.ringArray addObject:model];
        }
        [self.getPrayerRingListSubject sendNext:nil];
    }];
    
    [self.prayerCheckInCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary * _Nullable dict) {
        @strongify(self);
        PrayerCheckInModel *model;
        if (dict) {
            model = [PrayerCheckInModel mj_objectWithKeyValues:dict];
        }
        [self.prayerCheckInSubject sendNext:model];
        
    }];
    
    [self.prayerUnlockRingCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary * _Nullable dic) {
        @strongify(self);
        [self.prayerUnlockRingSubject sendNext:kLocalize(@"unlocked")];
    }];
    
    [self.prayerSetRingCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary * _Nullable dic) {
        @strongify(self);
        [self.prayerSetRingSubject sendNext:kLocalize(@"setting_completed")];
    }];
    
    [self.prayerTouristSetRingCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary * _Nullable dic) {
        @strongify(self);
        [self.prayerSetRingSubject sendNext:kLocalize(@"setting_completed")];
    }];
    
    [self.prayerTimeSetBeforeOrDelayCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary * _Nullable dic) {
        @strongify(self);
        [self.prayerTimeSetBeforeOrDelaySubject sendNext:kLocalize(@"setting_completed")];
    }];
    
    [self.prayerCheckInDaysCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary * _Nullable dic) {
        @strongify(self);
        DLog(@"%@",dic);
        [self.prayerCheckInDaysSubject sendNext:nil];
    }];
}

- (RACCommand *)getPrayerLogListCommand {
    if (!_getPrayerLogListCommand) {
        _getPrayerLogListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary  *_Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [PrayerNetworkTool getPrayerListLogWithParam:input success:^(NSDictionary * _Nullable resultDics) {
                    if (resultDics) {
                        [subscriber sendNext:resultDics];
                        [subscriber sendCompleted];
                    } else {
                        [subscriber sendError:nil];
                        [subscriber sendCompleted];
                    }
                    [ProgressHUD hideHUD];
                } failure:^(NSError * _Nonnull error) {
                    [ProgressHUD hideHUD];
                    [subscriber sendNext:nil];
                    [subscriber sendError:nil];
                    [subscriber sendCompleted];
                    DLog(@"VaildError : %@", error.userInfo);
                    kToast(error.userInfo[kHttpErrorReason]);
                }];
                
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _getPrayerLogListCommand;
}

- (RACCommand *)getPrayerRingListCommand {
    if (!_getPrayerRingListCommand) {
        _getPrayerRingListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary  *_Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [PrayerNetworkTool getPrayerRingingListWithParam:input success:^(NSDictionary * _Nullable resultDics) {
                    if (resultDics) {
                        [subscriber sendNext:resultDics];
                        [subscriber sendCompleted];
                    } else {
                        [subscriber sendError:nil];
                        [subscriber sendCompleted];
                        [ProgressHUD hideHUD];
                    }
                } failure:^(NSError * _Nonnull error) {
                    [ProgressHUD hideHUD];
                    [subscriber sendError:nil];
                    [subscriber sendCompleted];
                    DLog(@"VaildError : %@", error.userInfo);
                    kToast(error.userInfo[kHttpErrorReason]);
                }];
                
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _getPrayerRingListCommand;
}

- (RACCommand *)prayerCheckInCommand{
    if (!_prayerCheckInCommand) {
        _prayerCheckInCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary  *_Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                /// 被邀请人签到(不用在意结果)
                [PrayerNetworkTool inviteCheckInSuccess:^(id  _Nullable responseObject) {
                    
                } failure:^(NSError * _Nonnull error) {
                    
                }];
                [PrayerNetworkTool checkIn:input success:^(NSDictionary   * _Nullable resultDics) {
                    if (resultDics) {
                        [subscriber sendNext:resultDics];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendNext:nil];
                        [subscriber sendCompleted];
                        [ProgressHUD hideHUD];
                    }
                } failure:^(NSError * _Nonnull error) {
                    [ProgressHUD hideHUD];
                    [subscriber sendError:nil];
                    [subscriber sendCompleted];
                    DLog(@"VaildError : %@", error.userInfo);
                    kToast(error.userInfo[kHttpErrorReason]);
                    [self.prayerCheckInSubject sendNext:nil];
                }];
                
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _prayerCheckInCommand;
}

- (RACCommand *)prayerCheckInDaysCommand{
    if (!_prayerCheckInDaysCommand) {
        _prayerCheckInDaysCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary  *_Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [PrayerNetworkTool checkInDays:input success:^(NSDictionary * _Nullable resultDics) {
                    if (resultDics) {
                        [subscriber sendNext:resultDics];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendError:nil];
                        [subscriber sendCompleted];
                        [ProgressHUD hideHUD];
                    }
                } failure:^(NSError * _Nonnull error) {
                    [ProgressHUD hideHUD];
                    [subscriber sendError:nil];
                    [subscriber sendCompleted];
                    DLog(@"VaildError : %@", error.userInfo);
                    kToast(error.userInfo[kHttpErrorReason]);
                }];
                
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _prayerCheckInDaysCommand;
}

- (RACCommand *)prayerUnlockRingCommand{
    if (!_prayerUnlockRingCommand) {
        _prayerUnlockRingCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary  *_Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [PrayerNetworkTool unlockRingring:input success:^(NSDictionary * _Nullable resultDics) {
                    if (resultDics) {
                        [subscriber sendNext:resultDics];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendError:nil];
                        [subscriber sendCompleted];
                        [ProgressHUD hideHUD];
                    }
                } failure:^(NSError * _Nonnull error) {
                    [ProgressHUD hideHUD];
                    [subscriber sendError:nil];
                    [subscriber sendCompleted];
                    DLog(@"VaildError : %@", error.userInfo);
                    kToast(error.userInfo[kHttpErrorReason]);
                }];
                
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _prayerUnlockRingCommand;
}

- (RACCommand *)prayerSetRingCommand{
    if (!_prayerSetRingCommand) {
        _prayerSetRingCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary  *_Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [PrayerNetworkTool setDefaultRing:input success:^(NSDictionary * _Nullable resultDics) {
                    if (resultDics) {
                        [subscriber sendNext:resultDics];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendError:nil];
                        [subscriber sendCompleted];
                        [ProgressHUD hideHUD];
                    }
                } failure:^(NSError * _Nonnull error) {
                    [ProgressHUD hideHUD];
                    [subscriber sendError:nil];
                    [subscriber sendCompleted];
                    DLog(@"VaildError : %@", error.userInfo);
                    kToast(error.userInfo[kHttpErrorReason]);
                }];
                
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _prayerSetRingCommand;
}
/// 游客模式  设置铃声
- (RACCommand *)prayerTouristSetRingCommand{
    if (!_prayerTouristSetRingCommand) {
        _prayerTouristSetRingCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary  *_Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [PrayerNetworkTool touristSetDefaultRing:input success:^(NSDictionary * _Nullable resultDics) {
                    if (resultDics) {
                        [subscriber sendNext:resultDics];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendError:nil];
                        [subscriber sendCompleted];
                        [ProgressHUD hideHUD];
                    }
                } failure:^(NSError * _Nonnull error) {
                    [ProgressHUD hideHUD];
                    [subscriber sendError:nil];
                    [subscriber sendCompleted];
                    DLog(@"VaildError : %@", error.userInfo);
                    kToast(error.userInfo[kHttpErrorReason]);
                }];
                
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _prayerTouristSetRingCommand;
}


- (RACCommand *)prayerTimeSetBeforeOrDelayCommand {
    if (!_prayerTimeSetBeforeOrDelayCommand) {
        _prayerTimeSetBeforeOrDelayCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary  *_Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [PrayerNetworkTool setPrayerTimeDelayOrBefore:input success:^(NSDictionary * _Nullable resultDics) {
                    if (resultDics) {
                        [subscriber sendNext:resultDics];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendError:nil];
                        [subscriber sendCompleted];
                        [ProgressHUD hideHUD];
                    }
                } failure:^(NSError * _Nonnull error) {
                    [ProgressHUD hideHUD];
                    [subscriber sendError:nil];
                    [subscriber sendCompleted];
                    DLog(@"VaildError : %@", error.userInfo);
                    kToast(error.userInfo[kHttpErrorReason]);
                }];
                
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _prayerTimeSetBeforeOrDelayCommand;
}

- (RACCommand *)googlePushCommand {
    if (!_googlePushCommand) {
        _googlePushCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary  *_Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [PrayerNetworkTool setPushMessageWithParam:input success:^(NSDictionary * _Nullable resultDics) {
                    if (resultDics) {
                        [subscriber sendNext:resultDics];
                        [subscriber sendCompleted];
                    }else {
                        [subscriber sendError:nil];
                        [subscriber sendCompleted];
                    }
                } failure:^(NSError * _Nonnull error) {
                    [subscriber sendError:nil];
                    [subscriber sendCompleted];
                    DLog(@"VaildError : %@", error.userInfo);
                    //                    kToast(error.userInfo[kHttpErrorReason]);
                }];
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
    return _googlePushCommand;
}

- (NSMutableArray<PrayerModel *> *)listArray {
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (NSMutableArray<PrayerModel *> *)noNetListArray {
    _noNetListArray = [self dl_getNoNetListArr];/// 每次获取数据的时候都要去从方法中获取
    return _noNetListArray;
}
/// 无网络时候的第一行数据
- (PrayerModel *)firstNoNetModel {
    if(!_firstNoNetModel){
        _firstNoNetModel = [self dl_getNoNetPrayerModelWithBackGroundModel:[PrayerModel new]];
    }
    return _firstNoNetModel;
}

#pragma mark -- 将NSDate类型的时间转换为时间戳,从1970/1/1开始
- (long long)getDateTimeTOMilliSeconds:(NSDate *)datetime {
    NSTimeInterval interval = [datetime timeIntervalSince1970];
    long long totalMilliseconds = interval * 1000 ;
    totalMilliseconds = totalMilliseconds + [NSTimeZone systemTimeZone].secondsFromGMT * 1000;
    return totalMilliseconds;
}

#pragma mark --判断显示今天数据还是明天数据
- (BOOL)dl_justIfToday{
    long long currentTimeStamp = [self getDateTimeTOMilliSeconds:[NSDate date]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *lastDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@",[NSString nowTimeFormatted],self.lastPrayTime]];
    long long lastTimeStamp = [self getDateTimeTOMilliSeconds:lastDate];
    
    /// 获取本地是否签到
    BOOL checkInFlag = [kUserDefaults boolForKey:[NSString stringWithFormat:@"%@-Isha-checkInFlag-%@",kUser.userInfo.userId,[NSString nowTimeFormatted]]];
    if (lastTimeStamp - currentTimeStamp > -3660000 && !checkInFlag) {
        return YES;
    }
    return NO;
}

#pragma mark --方法抽取 获取无网络情况的数据
- (NSMutableArray<PrayerModel *> *)dl_getNoNetListArr {
    NSMutableArray *noNetArr = [NSMutableArray array];
    NSArray *prayTypeArr = @[@"Fajr",@"Sunrise",@"Dhuhr",@"Asr",@"Maghrib",@"Isha"];
    /// 获取明天日期
    NSString *timeStr = [NSString tomorrowTimeFormatted];
    if ([self dl_justIfToday]) {// 判断是不是今天数据
        /// 获取今天得数据
        timeStr = [NSString nowTimeFormatted];
    }
    ///  默认 利亚德的位置
    NSArray *prayTimeArr = [self dl_getPrayerTimeWithString:timeStr];
    /// 保存一下今天最后的祈祷时间
    self.lastPrayTime = [prayTimeArr lastObject];
    
    for (int i = 0; i < prayTypeArr.count; i++) {
        /// 获取保存本地的铃声
        NSString *ringName = [kUserDefaults valueForKey:[NSString stringWithFormat:@"%@-%@-ringName",kUser.userInfo.userId,prayTypeArr[i]]];
        /// 获取保存本地提醒时间
        NSString *remindTime = [kUserDefaults valueForKey:[NSString stringWithFormat:@"%@-%@-remindTime",kUser.userInfo.userId,prayTypeArr[i]]];
        /// 获取保存本地是否签到
        BOOL checkInFlag = [kUserDefaults boolForKey:[NSString stringWithFormat:@"%@-%@-checkInFlag",kUser.userInfo.userId,prayTypeArr[i]]];
        if (![self dl_justIfToday]) {
            checkInFlag = NO;
        }
        NSString *prayerDateStr = [NSString tomorrowTimeFormatted];
        if ([self dl_justIfToday]) {
            prayerDateStr = [NSString nowTimeFormatted];
        }
        // 获取时间戳
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        NSDate *useDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@",prayerDateStr,prayTimeArr[i]]];
        /// 给Model赋值
        PrayerModel *prayerModel = [[PrayerModel alloc] init];
        prayerModel.remindType = remindTime;
        prayerModel.prayType = prayTypeArr[i];
        prayerModel.ringingName = ringName;
        prayerModel.checkInFlag = @(checkInFlag).stringValue;
        prayerModel.prayTime = prayTimeArr[i];
        prayerModel.prayDateStr = prayerDateStr;
        prayerModel.prayDate = [NSString stringWithFormat:@"%lld",[self getDateTimeTOMilliSeconds:useDate]];
        
        // 添加到数组
        [noNetArr addObject:prayerModel];
    }
    return noNetArr;
}

#pragma mark --方法抽取 获取模型
/// 带参数的是有网络的时候  没有参数是无网络 本地访问
- (PrayerModel *)dl_getNoNetPrayerModelWithBackGroundModel:(PrayerModel *)model {
    NSMutableArray *useArrM = [NSMutableArray array];
    NSMutableArray *noNetArr = [self dl_getNoNetListArr];// 获取无网络时候的数据
    PrayerModel *currentPrayerModel = [[PrayerModel alloc] init];
    /// useArrM 把祈祷时间戳 - 现在的时间戳保存
    for (PrayerModel *prayerModel in noNetArr) {
        NSString *useStr = [NSString stringWithFormat:@"%lld",prayerModel.prayDate.integerValue - [self getDateTimeTOMilliSeconds:[NSDate date]]];
        [useArrM addObject:useStr];
    }
    /// 从useArrM中把保存的时间戳取出来  一个一个做对比
    for (int i = 0;i < useArrM.count;i++) {
        NSString *timeStr = useArrM[i];
        if (timeStr.integerValue > -3660000) {/// 判断时间戳是不是在签到范围内
            currentPrayerModel = noNetArr[i];/// 取出model
            if (model.prayType && model.prayType.length > 0) {/// 如果参数中model有值,则证明又网络的情况,这时候要处理签到逻辑
                if (![model.prayType isEqualToString:currentPrayerModel.prayType]) {
                    for (int j = 0; j < useArrM.count; j++) {
                        NSString *checkInTimeStr = useArrM[j];
                        if (checkInTimeStr.integerValue > 0) {
                            currentPrayerModel = noNetArr[j];
                            break;
                        }
                    }
                }
            }
            if (currentPrayerModel.checkInFlag.boolValue) {
                for (int j = 0; j < useArrM.count; j++) {
                    NSString *checkInTimeStr = useArrM[j];
                    if (checkInTimeStr.integerValue > 0) {
                        currentPrayerModel = noNetArr[j];
                        break;
                    }
                }
            }
            break;
        }else {/// 如果多有的签到时间戳都不在签到一个小时之内  则直接使用第一个
            currentPrayerModel = [noNetArr firstObject];
        }
    }
    return currentPrayerModel;
}

#pragma mark -- 获取祈祷时间
- (NSArray *)dl_getPrayerTimeWithString:(NSString *)timeStr {
    PrayTime *pr = [[PrayTime alloc] init];
    NSArray *timeArr = [timeStr componentsSeparatedByString:@"-"];
    NSString *yearStr = [timeArr firstObject];
    int year = yearStr.intValue;
    NSString *monthStr = timeArr[1];
    int month = monthStr.intValue;
    NSString *dayStr = [timeArr lastObject];
    int day = dayStr.intValue;
    NSInteger offset = [NSTimeZone systemTimeZone].secondsFromGMT / 3600;
    ///  默认 利亚德的位置
    NSString *localLatitude = [kUserDefaults valueForKey:kLocationLatitude];
    NSString *localLongitude = [kUserDefaults valueForKey:kLocationlongitude];
    NSMutableArray *prayTimeArr = [pr getDatePrayerTimes:year andMonth:month andDay:day andLatitude:localLatitude.doubleValue andLongitude:localLongitude.doubleValue andtimeZone:offset];
    [prayTimeArr removeObjectAtIndex:prayTimeArr.count - 2];
    
    return prayTimeArr.copy;
}
#pragma mark --一般方法抽取=============================================================

#pragma mark --请求数据Command
- (void)dl_getPrayerRequestWithResult:(HomePageModelBlock )homePageModelBlock andWithNumDownBlock:(HomePageNumDownBlock )homePageNumDownBlock andWithFromController:(UIViewController *)vc {
    
    self.becomeVC = vc;
    
    [self dl_getRequestWithLatitude:[kUserDefaults objectForKey:kLocationLatitude] andWithLongitude:[kUserDefaults objectForKey:kLocationlongitude]];
    
    @weakify(self);
    [[self.getPrayerListSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        /// 将推送的相关信息传递给后台
        [self dl_pushBackgroundMessage];
        if (self.firstModel && isService) {
            /// 访问网络的时候 将firstNoNetModel重新赋值 [self.prayerViewModel dl_getNoNetPrayerModel]  经过此方法重新得到一个新的model
            PrayerModel *model = [self dl_getNoNetPrayerModelWithBackGroundModel:self.firstModel];
            self.firstModel.prayDate = model.prayDate;// 将祈祷日期赋值为本地日期
            self.firstModel.prayTime = model.prayTime;// 将祈祷时间赋值为本地时间
            /// 处理倒计时和第一组数据相关
            [self dl_dataComepletWithModel:self.firstModel andWithListArray:self.listArray];
            /// 模型回调
            homePageModelBlock(self.firstModel);
            /// 设置定时器并且回调
            [self dl_getTimerFire:self.firstModel andWithNumDownBlock:homePageNumDownBlock];
            
        }else {
            /// 将firstNoNetModel重新赋值 [self.prayerViewModel dl_getNoNetPrayerModel] 这个方法只有在这的时候用,其它地方不能用,会导致创建多个prayerModel
            self.firstNoNetModel = [self dl_getNoNetPrayerModelWithBackGroundModel:[PrayerModel new]];
            /// 处理倒计时和第一组数据相关
            [self dl_dataComepletWithModel:self.firstNoNetModel andWithListArray:self.noNetListArray];
            /// 模型回调
            homePageModelBlock(self.firstNoNetModel);
            /// 设置定时器并且回调
            [self dl_getTimerFire:self.firstNoNetModel andWithNumDownBlock:homePageNumDownBlock];
        }
        
        /// listArray如果有值  则用listArray 注册通知
        if (self.listArray.count > 0 && isService) {
            for (int i = 0; i < self.listArray.count; i++) {
                PrayerModel *prayerModel = self.listArray[i];
                [self dl_ringDownSuccess:prayerModel];
            }
        }else {
            for (int i = 0; i < self.listArray.count; i++) {
                PrayerModel *prayerModel = self.noNetListArray[i];
                [self dl_ringDownSuccess:prayerModel];
            }
        }
    }];
}
#pragma mark --请求网络
- (void)dl_getRequestWithLatitude:(NSString *)latitude andWithLongitude:(NSString *)longitude {
    NSString *tzStr = [self dl_getTimeZoneStr];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:latitude forKey:@"lat"];
    [params setValue:longitude forKey:@"lon"];
    [params setValue:tzStr forKey:@"timeZone"];
    if(kUser.isLogin) { // 登陆过 获取用户信息
        [params setValue:kUser.userInfo.userId forKey:@"userId"];
        [self.getPrayerLogListCommand execute:params];
    }else {
        /// 第一次安装 时间更正
        self.noNetListArray = [self dl_getNoNetListArr];
    }
}

#pragma mark -- 拿到model计算第一行的数据
- (void)dl_dataComepletWithModel:(PrayerModel *)prayerModel andWithListArray:(NSArray *)listArray {
    
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

#pragma mark --开发定时器
- (void)dl_getTimerFire:(PrayerModel *)prayerModel andWithNumDownBlock:(HomePageNumDownBlock )homePageModelBlock{
    [self dl_timerStop];
    @weakify(self);
    /// 添加定时器
    self.disposable = [[[RACSignal interval:1 onScheduler:[RACScheduler currentScheduler]]takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self);
        prayerModel.timeSecond --;
        if (prayerModel.timeSecond >= 0) {
            homePageModelBlock([NSString timeFormatted:prayerModel.timeSecond]);
        }
        if (prayerModel.timeSecond == -3660) {
            [self dl_timerStop];// 停止计时器
            // 访问网络
            [self dl_getRequestWithLatitude:[kUserDefaults objectForKey:kLocationLatitude] andWithLongitude:[kUserDefaults objectForKey:kLocationlongitude]];
        }
    }];
}

#pragma mark --判断铃声是否下载
- (void)dl_ringDownSuccess:(PrayerModel *)prayerModel {
    if (prayerModel.ringingUrl && [prayerModel.ringingUrl containsString:@"http"]) {// 判断后台返回的是不是url
        NSString *musicTemptr = [[prayerModel.ringingUrl componentsSeparatedByString:@"/"] lastObject];
        NSString *soundStr = [[musicTemptr componentsSeparatedByString:@"."] firstObject];
        NSString *musictr = [NSString stringWithFormat:@"%@.m4a",soundStr];
        if (![[DownloadSoundManager sharedInstance] judgeFileExist:musictr]) {
            [[DownloadSoundManager sharedInstance] dl_beginDownLoadSoundsResourceWithUrl:prayerModel.ringingUrl andWithProgress:^(NSProgress * _Nonnull downloadProgress) {} andWithCallBack:^(NSString * _Nullable path, BOOL success) {
                [self dl_registerLocationNotification:prayerModel];
            }];
        }else {
            [self dl_registerLocationNotification:prayerModel];
        }
    }
}

#pragma mark --本地通知
- (void)dl_registerLocationNotification:(PrayerModel *)prayerModel {
    if(prayerModel) {
        // 缓存数据 铃声
        [kUserDefaults setValue:prayerModel.ringingName forKey:[NSString stringWithFormat:@"%@-%@-ringName",kUser.userInfo.userId,prayerModel.prayType]];
        // 缓存数据 祈祷时间 提前OR延后
        [kUserDefaults setValue:prayerModel.remindType forKey:[NSString stringWithFormat:@"%@-%@-remindTime",kUser.userInfo.userId,prayerModel.prayType]];
        // 缓存数据 是否签到
        [kUserDefaults setBool:prayerModel.checkInFlag.boolValue forKey:[NSString stringWithFormat:@"%@-%@-checkInFlag",kUser.userInfo.userId,prayerModel.prayType]];
        [kUserDefaults synchronize];
        
        // 计算本地推送的时间
        NSInteger countDownValue = (prayerModel.prayDate.integerValue - [NSDate  getCurrentStamp]) / 1000;
        NSInteger tomorrowValue = countDownValue + 86400;
        /// 取消今天通知
        [LocalNotificationManager dl_cancleLocalNotificationWithIdentifer:[NSString stringWithFormat:@"%@",kLocalize(prayerModel.prayType.lowercaseString)]];
        /// 取消相应的明天通知
        [LocalNotificationManager dl_cancleLocalNotificationWithIdentifer:[NSString stringWithFormat:@"%@_tomorrow",kLocalize(prayerModel.prayType.lowercaseString)]];
        ///注册今天本地通知
        [self dl_localMessage:prayerModel andWithCountDown:countDownValue andWithIdentifier:kLocalize(prayerModel.prayType.lowercaseString)];
        /// 注册明天通知
        [self dl_localMessage:prayerModel andWithCountDown:tomorrowValue andWithIdentifier:[NSString stringWithFormat:@"%@_tomorrow",kLocalize(prayerModel.prayType.lowercaseString)]];
    }
}

#pragma mark --通知方法提取
- (void)dl_localMessage:(PrayerModel *)prayerModel andWithCountDown:(NSInteger )timeDown andWithIdentifier:(NSString *)identifier {
    NSString *soundStr = @"";
    if(prayerModel.ringingName && kUser.isLogin){/// 登录的状态展示铃声名字,未登录状态展示的是默认的
        soundStr = prayerModel.ringingName;
    }else {
        if ([prayerModel.prayType isEqualToString:@"Sunrise"]) {
            soundStr = kLocalize(@"none");
        }else {
            soundStr = kLocalize(@"abdul_basit");
        }
    }

    if ([soundStr isEqualToString:kLocalize(@"none")] || [soundStr isEqualToString:kLocalize(@"silent")]) {
        if ([soundStr isEqualToString:kLocalize(@"none")]) {
            return;
        }
    }else {
        switch (prayerModel.remindType.integerValue) {
            case 0:
                break;
            case 5:
                timeDown = timeDown - 300;
                break;
            case 10:
                timeDown = timeDown - 600;
                break;
            case 15:
                timeDown = timeDown - 900;
                break;
            case -5:
                timeDown = timeDown + 300;
                break;
            case -10:
                timeDown = timeDown + 600;
                break;
            case -15:
                timeDown = timeDown + 900;
                break;
            default:
                break;
        }
    }
    /// 传递个参数 如果有prayerModel.ringingName 将参数传递
    NSDictionary *userInfo = @{};
    if (soundStr.length > 0) {
        userInfo = @{@"ringName":soundStr};
    }
    /// 推送标题
    NSString *cityName = [kUserDefaults valueForKey:kLocationCity];
    NSString *messageTitle = [NSString stringWithFormat:kLocalize(@"location_message_begin"),kLocalize(prayerModel.prayType.lowercaseString),cityName];
    if (![identifier containsString:@"tomorrow"]) {/// 保存祈祷的时间提示  为了埋点处使用
        [kUserDefaults setValue:prayerModel.remindType forKey:messageTitle];
        [kUserDefaults synchronize];
    }
    NSString *bodyStr = @"  اللهُ أكبرْ , اللهُ أكبرْ . اللهُ أكبرْ , اللهُ أكبرْ";
    
    if (timeDown > 0) {
        NSString *ringUrlStr = prayerModel.ringingUrl;// 拿到返回的ringUrl
        NSString *musicTemptr;// 定义一个铃声字符串
        NSString *musictr;
        if (ringUrlStr && [ringUrlStr containsString:@"http"]) {// 判断后台返回的是不是url
            musicTemptr = [[ringUrlStr componentsSeparatedByString:@"/"] lastObject];
            NSString *soundStr = [[musicTemptr componentsSeparatedByString:@"."] firstObject];
            musictr = [NSString stringWithFormat:@"%@.m4a",soundStr];
            [LocalNotificationManager dl_addLocalNotificationWithTitle:messageTitle subTitle:@"" body:bodyStr timeInterval:timeDown identifier:identifier userInfo:userInfo repeats:NO sound:musictr];
        } else {
            NSString *musicStr = kUser.isLogin ? @"" : @"Abdul-basit";
            [LocalNotificationManager dl_addLocalNotificationWithTitle:messageTitle subTitle:@"" body:bodyStr timeInterval:timeDown identifier:identifier userInfo:userInfo repeats:NO sound:musicStr];
        }
    }
}

#pragma mark ---触发给后台的推送消息的接口
- (void)dl_pushBackgroundMessage {
    NSString *tzStr = [self dl_getTimeZoneStr];
    NSString *latitude = [kUserDefaults valueForKey:kLocationLatitude];
    NSString *longitudeStr = [kUserDefaults valueForKey:kLocationlongitude];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:latitude forKey:@"lat"];
    [params setValue:longitudeStr forKey:@"lon"];
    [params setValue:tzStr forKey:@"timeZone"];

    NSArray *timeArr = [self dl_getPrayerTimeWithString:self.firstNoNetModel.prayDateStr];
    NSDateFormatter *formatter = [NSString dateFormat];
    NSMutableArray *fitArrM = [NSMutableArray array];
    for (NSString *timeStr in timeArr) {
        NSString *fitStr;
        fitStr = [NSString stringWithFormat:@"%@ %@:00",[formatter stringFromDate:[NSDate date]],timeStr];
        if ([LanguageTool isArabic]) {
            /// 此处将日期转换成正常格式传给后台  stringFromDate这个方法在阿语状态下可能把日期转换成阿语展示
            fitStr = [NSString translatNum:fitStr];
        }
        [fitArrM addObject:fitStr];
    }
    NSArray *arr = [NSArray array];
    if (fitArrM.count >= 6) {
        arr = @[@{@"prayerType" : @"Fajr",@"checkTime":fitArrM[0]},@{@"prayerType" : @"Sunrise",@"checkTime":fitArrM[1]},@{@"prayerType" : @"Dhuhr",@"checkTime":fitArrM[2]},@{@"prayerType" : @"Asr",@"checkTime":fitArrM[3]},@{@"prayerType" : @"Maghrib",@"checkTime":fitArrM[4]},@{@"prayerType" : @"Isha",@"checkTime":fitArrM[5]}];
    }
    [params setValue:arr forKey:@"prayerTime"];
    [self.googlePushCommand execute:params];
}
#pragma mark --签到接口访问
- (void)dl_checkInRequestWithResult:(HomePageCheckInBlock )homePageCheckInBlock {
    NSString *tzStr = [self dl_getTimeZoneStr];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.firstModel && isService) {
        [params setValue:self.firstModel.prayType forKey:@"prayerType"];
    }else {
        [params setValue:self.firstNoNetModel.prayType forKey:@"prayerType"];
    }
    [params setValue:tzStr forKey:@"timeZone"];
    [params setValue:[NSString nowTimeInterval] forKey:@"mobileLocalTime"];
    [self.prayerCheckInCommand execute:params];
    
    [[self.prayerCheckInSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(PrayerCheckInModel  *_Nullable prayerCheckInModel) {
        if (prayerCheckInModel) {
            /// 保存本地设置
            NSString *prayType;
            if (self.firstModel && self.firstModel.prayType.length > 0 && isService) {
                prayType = self.firstModel.prayType;
            }else {
                prayType = self.firstNoNetModel.prayType;
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
            // 签到成功 刷新界面
            [self dl_getRequestWithLatitude:[kUserDefaults objectForKey:kLocationLatitude] andWithLongitude:[kUserDefaults objectForKey:kLocationlongitude]];
        }
        homePageCheckInBlock(prayerCheckInModel);
    }];
}

#pragma mark --app 从后台进入前台
- (void)applicationBecomeActive {
    @weakify(self);
    // 检测网络连接的单例,网络变化时的回调方法
    if ([self.becomeVC isKindOfClass:NSClassFromString(@"HomeViewController")]) {
        // 刷新签到数据 防止祈祷页面签到后首页数据不刷新
         [self dl_getRequestWithLatitude:kLatitude andWithLongitude:kLongitudeStr];
    }else {
        // 检测网络连接的单例,网络变化时的回调方法
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            @strongify(self);
            if (status == 1 || status == 2) {
                /// 后台进入前端 刷新一次界面
                [self dl_getRequestWithLatitude:kLatitude andWithLongitude:kLongitudeStr];
            }else {
                ExecBlock(self.prayerBackComeFrontBlock);
            }
        }];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
}

#pragma mark --定时器关闭
- (void)dl_timerStop {
    if (self.disposable) {
        [self.disposable dispose];
        self.disposable = nil;
    }
}
/// 时区获取
- (NSString *)dl_getTimeZoneStr {
    NSInteger offset = [NSTimeZone systemTimeZone].secondsFromGMT;
    offset = offset / 3600;
    return [NSString stringWithFormat:@"%ld", (long)offset];
}
#pragma mark --懒加载========================================================
- (NSMutableArray<RemindModel *> *)ringArray {
    if(!_ringArray){
        _ringArray = [NSMutableArray array];
    }
    return _ringArray;
}

- (NSArray *)prayerListArr {
    if(!_prayerListArr){
        _prayerListArr = [NSArray array];
    }
    return _prayerListArr;
}

@end
