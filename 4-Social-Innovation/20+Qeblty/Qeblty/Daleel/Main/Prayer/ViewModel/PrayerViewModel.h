//
//  PrayerViewModel.h
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import <Foundation/Foundation.h>

@class PrayerModel,RemindModel,PrayerCheckInModel;
/// model的回调
typedef void(^HomePageModelBlock)(PrayerModel * _Nullable prayerModel);
/// 倒计时回调
typedef void(^HomePageNumDownBlock)(NSString * _Nullable numDownStr);
/// 签到成功回调
typedef void(^HomePageCheckInBlock)(PrayerCheckInModel  *_Nullable prayerCheckInModel);
/// 祈祷页 从后台进入前端回调
typedef void(^PrayerBackComeFrontBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface PrayerViewModel : NSObject
///  祈祷列表网络通道
@property (nonatomic, strong) RACCommand *getPrayerLogListCommand;
@property (nonatomic, strong) RACSubject *getPrayerListSubject;
/// 铃声列表的通道
@property (nonatomic,strong)RACCommand *getPrayerRingListCommand;
@property (nonatomic,strong)RACSubject *getPrayerRingListSubject;
///  签到的通道
@property (nonatomic,strong)RACCommand *prayerCheckInCommand;
@property (nonatomic,strong)RACSubject *prayerCheckInSubject;
/// 签到值传递的通道
@property (nonatomic,strong)RACCommand *prayerCheckInDaysCommand;
@property (nonatomic,strong)RACSubject *prayerCheckInDaysSubject;
/// 解锁铃声的网络通道
@property (nonatomic,strong)RACCommand *prayerUnlockRingCommand;
@property (nonatomic,strong)RACSubject *prayerUnlockRingSubject;
/// 设置铃声的网络通道
@property (nonatomic,strong)RACCommand *prayerSetRingCommand;
@property (nonatomic,strong)RACSubject *prayerSetRingSubject;
/// 游客设置铃声的通道
@property (nonatomic,strong)RACCommand *prayerTouristSetRingCommand;
@property (nonatomic,strong)RACSubject *prayerTouristSetRingSubject;

/// 设置提前  延后提醒的网络通道
@property (nonatomic,strong)RACCommand *prayerTimeSetBeforeOrDelayCommand;
@property (nonatomic,strong)RACSubject *prayerTimeSetBeforeOrDelaySubject;
///// 传递googleToken的网络通道
//@property (nonatomic,strong)RACCommand *googleTokenCommand;
//@property (nonatomic,strong)RACSubject *googleTokenSubject;
/// 传递后台推送的信息
@property (nonatomic,strong)RACCommand *googlePushCommand;
@property (nonatomic,strong)RACSubject *googlePushSubject;

@property (nonatomic,copy)PrayerBackComeFrontBlock prayerBackComeFrontBlock;

/// 祈祷列表数据第一组
@property (nonatomic,strong)PrayerModel  * _Nullable firstModel;
/// 祈祷列表数据第一组无网络情况
@property (nonatomic,strong)PrayerModel *firstNoNetModel;
/// 祈祷列表数据
@property (nonatomic,strong)NSMutableArray<PrayerModel *> *listArray;
/// 祈祷列表数据 map形式
@property (nonatomic,strong)NSArray *prayerListArr;
/// 无网络祈祷列表数据缓存
@property (nonatomic,strong)NSMutableArray<PrayerModel *> *noNetListArray;
/// 铃声界面第一组数据
@property (nonatomic,strong)RemindModel *firstRingModel;
/// 祈祷铃声界面数据
@property (nonatomic,strong)NSMutableArray<RemindModel *> *ringArray;
/// 设置的铃声回调参数
@property (nonatomic,copy)NSString *setRingStr;
/// 记录点击铃声选择的第几行cell
@property (nonatomic,assign)NSInteger indexRow;

///  --请求列表网络
- (void)dl_getRequestWithLatitude:(NSString *)latitude andWithLongitude:(NSString *)longitude;

/// 无网络的时候获取首页祈祷列表数据
- (NSMutableArray<PrayerModel *> *)dl_getNoNetListArr;

/// 方法抽取 获取无网络时候的第一行Model   此方法重复使用可创建多个PrayerModel  谨慎使用
- (PrayerModel *)dl_getNoNetPrayerModelWithBackGroundModel:(PrayerModel *)model;
/// 方法抽取  获取祈祷时间
- (NSArray *)dl_getPrayerTimeWithString:(NSString *)timeStr;

/// 首页需要接口访问 /// 首页获取祈祷时间和签到信息铃声设置的一些信息
- (void)dl_getPrayerRequestWithResult:(HomePageModelBlock )homePageModelBlock andWithNumDownBlock:(HomePageNumDownBlock )homePageNumDownBlock andWithFromController:(UIViewController *)vc;

/// 首页签到接口访问
- (void)dl_checkInRequestWithResult:(HomePageCheckInBlock )homePageCheckInBlock;

@end

NS_ASSUME_NONNULL_END
