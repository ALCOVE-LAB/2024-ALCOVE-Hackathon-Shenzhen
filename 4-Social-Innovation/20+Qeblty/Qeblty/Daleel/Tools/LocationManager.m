//
//  LocationManager.m
//  Daleel
//
//  Created by mac on 2022/12/7.
//

#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "MultiDelegateManager.h"

static LocationManager *instance = nil;
static dispatch_once_t onceToken;

@interface LocationManager ()<CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *localtionManager;
@property (nonatomic,strong) MultiDelegateManager *delegateManager;
/// 定位权限回调字典
@property (nonatomic,strong) NSMutableDictionary <NSString *,void(^)(BOOL success,CLAuthorizationStatus status)> *authorizationBlockDic;
/// 获取定位回调
@property (nonatomic,copy) void(^getLocationBlock)(CLLocation *location, NSString *latitude, NSString *longitudeStr, NSString *city);
/// 获取定位 OR 解析地址失败回调
@property (nonatomic,copy) void(^getLocationFailBlock)(NSError *error);

@end

@implementation LocationManager

+ (instancetype)sharedInstance {
    if (!instance) {
        instance = [[self alloc] init];
        [instance initLocationManager];
    }
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (id)copy {
    return self;
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(struct _NSZone *)zone {
    return self;
}

- (void)invalidateInstance {
    onceToken = 0;
    instance = nil;
}

- (void)initLocationManager {
    // 初始化多代理管理工具
    _delegateManager = [[MultiDelegateManager alloc] init];
    // 初始化CLLocationManager
    CLLocationManager *localtionManager = [[CLLocationManager alloc] init];
    localtionManager.delegate = self;
    localtionManager.distanceFilter = 3000; // 在用户位置改变10米时调用一次代理方法 本次定位 与 上次定位 位置之间的物理距离 > 下面设置的数值时,就会通过代理,将当前位置告诉外界
//    localtionManager.desiredAccuracy = 100; // 当用户在100米范围内，系统会默认将100米范围内都当作一个位置
    localtionManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers; // 设置定位的精确度 (单位:米),（定位精确度越高, 越耗电, 定位的速度越慢）
//    [localtionManager requestAlwaysAuthorization]; // 申请前后台定位权限
//    [localtionManager requestWhenInUseAuthorization];
    _localtionManager = localtionManager;
    // 初始化权限监听字典
    _authorizationBlockDic = [NSMutableDictionary dictionaryWithCapacity:0];
}

#pragma mark - public
- (void)requestAuthorizationAndAddListenerWithKey:(NSString *)keyName listenerBlock:(void(^)(BOOL success, CLAuthorizationStatus status))block {
    // 获取现在的授权状态 如果没有授权 则申请授权
    CLAuthorizationStatus currentStatus;
    if (@available(iOS 14.0, *)) {
        currentStatus = _localtionManager.authorizationStatus;
    } else {
        currentStatus = [CLLocationManager authorizationStatus];
    }
    BOOL isAuthorizated = NO;
    BOOL isAuthorizationStatusNotDetermined = NO; // 判断用户是否做过是否给权限的决定
    switch (currentStatus) { //authorizationStatus
        case kCLAuthorizationStatusNotDetermined: {
            // 用户没设置过权限 没做决定
            isAuthorizationStatusNotDetermined = YES;
        }
            break;
        case kCLAuthorizationStatusRestricted: {
            
        }
            break;
        case kCLAuthorizationStatusDenied: {
//            if([CLLocationManager locationServicesEnabled]) {
////                //定位服务是开启状态，需要手动授权，即将跳转设置界面
//            }else {
////                //定位关闭，不可用
//            }
        }
            break;
        case kCLAuthorizationStatusAuthorizedAlways: {
            isAuthorizated = YES;
        }
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse: {
            isAuthorizated = YES;
        }
            break;
            
        default:
            break;
    }
    
    /// 保存回调
    [self.authorizationBlockDic setValue:block forKey:keyName];
    
    if (!isAuthorizated) {
        // 没有定位授权
        // 申请授权 回调 _authorizationBlock
        [_localtionManager requestWhenInUseAuthorization];
        if (!isAuthorizationStatusNotDetermined) {
            // 用户做过是否给权限的决定了 此处权限被拒绝了
            ExecBlock(block,isAuthorizated,currentStatus);
        }
    }else {
        // 有权限
        ExecBlock(block,isAuthorizated,currentStatus);
    }
}

/// 移除监听
- (void)removeAuthorizationListenerWithKey:(NSString *)keyName {
    [self.authorizationBlockDic removeObjectForKey:keyName];
}

/// 获取经纬度 国家信息
- (void)getLocation:(void(^)(CLLocation *location, NSString *latitude, NSString *longitudeStr, NSString *city))locationBlock fail:(void(^)(NSError *error))failBlock {
    [_localtionManager startUpdatingLocation];
    _getLocationBlock = locationBlock;
    _getLocationFailBlock = failBlock;
}

/// 开始指北  需要配置代理 实时获取
- (void)startUpdateHeading {
    [_localtionManager startUpdatingHeading]; // 开始导航 指北
}

- (void)stopUpdateHeading {
    [_localtionManager stopUpdatingHeading];
}

- (void)addDelegate:(id<LocationManagerDelegate>)receiver{
    [self.delegateManager addDelegate:receiver];
}

- (void)removeDelegate:(id<LocationManagerDelegate>)receiver {
    [self.delegateManager removeDelegate:receiver];
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    self.getLocationFailBlock(error);
}

// 授权变化
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    BOOL isAuthorizated = NO;
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            // 用户没设置过权限 没做决定
        }
            break;
        case kCLAuthorizationStatusRestricted: {
            
        }
            break;
        case kCLAuthorizationStatusDenied: {
//            if([CLLocationManager locationServicesEnabled]) {
////                //定位服务是开启状态，需要手动授权，即将跳转设置界面
//            }else {
////                //定位关闭，不可用
//            }
        }
            break;
        case kCLAuthorizationStatusAuthorizedAlways: {
            isAuthorizated = YES;
        }
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse: {
            isAuthorizated = YES;
        }
            break;
            
        default:
            break;
    }
    for (NSString *key in self.authorizationBlockDic.allKeys) {
        ExecBlock(self.authorizationBlockDic[key],isAuthorizated,status);
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    [self.delegateManager enumerateDelegate:^(id  _Nonnull delegate) {
        if (delegate) {
            [delegate locationManagerDidUpdateHeading:newHeading];
        }
    }];
}

//判断设备是否需要校验
-(BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
    __block BOOL isNeed = NO;
    [self.delegateManager enumerateDelegate:^(id  _Nonnull delegate) {
        if (delegate) {
            isNeed = [delegate locationManagerShouldDisplayHeadingCalibration];
        }
    }];
    return isNeed;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    // 停止获取位置信息
    [_localtionManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    NSString * latitudeStr = [NSString stringWithFormat:@"%3.2f", currentLocation.coordinate.latitude];
    NSString * longitudeStr  = [NSString stringWithFormat:@"%3.2f", currentLocation.coordinate.longitude];
    NSString * altitudeStr  = [NSString stringWithFormat:@"%3.2f", currentLocation.altitude];
    DLog(@"纬度 %@  经度 %@  高度 %@", latitudeStr, longitudeStr, altitudeStr);
//    [ToastTool showToast:[NSString stringWithFormat:@"纬度 %@  经度 %@  高度 %@",latitudeStr, longitudeStr, altitudeStr]];
    // 解析具体位置
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation preferredLocale:kIsAR ? [NSLocale localeWithLocaleIdentifier:@"ar_SA"] : [NSLocale localeWithLocaleIdentifier:@"en_US"] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if ([placemarks count] > 0) {
                CLPlacemark *placeMark = placemarks[0];
//                NSLog(@"当前国家 - %@",placeMark.country);//当前国家
//                NSLog(@"当前城市 - %@",placeMark.locality);//当前城市
//                NSLog(@"当前位置 - %@",placeMark.subLocality);//当前位置
//                NSLog(@"当前街道 - %@",placeMark.thoroughfare);//当前街道
//                NSLog(@"具体地址 - %@",placeMark.name);//具体地址
                ExecBlock(self.getLocationBlock,currentLocation, latitudeStr, longitudeStr, placeMark.locality);
//                [ToastTool showToast:[NSString stringWithFormat:@"当前国家-%@ 当前城市-%@",placeMark.country,placeMark.locality]];
            }else if(placemarks.count == 0){
    //            NSLog(@"无位置和错误返回");
                if(currentLocation && latitudeStr.length > 0 && longitudeStr.length > 0){
                    // 有经纬度 但是解析城市失败了 返回成功 但是城市返回 nil
                    ExecBlock(self.getLocationBlock,currentLocation, latitudeStr, longitudeStr, nil);
                    DLog(@"location error 有经纬度 但是解析城市失败了 返回成功 但是城市返回 nil :%@",error);
//                    [ToastTool showToast:[NSString stringWithFormat:@"location error 有经纬度-%@-%@ 但是解析城市失败了 返回成功 但是城市返回 nil error:%@",latitudeStr,longitudeStr,error]];
                    return;
                }
                if(error){
                    ExecBlock(self.getLocationFailBlock,error);
//                    [ToastTool showToast:[NSString stringWithFormat:@"location error %@",error]];
                    DLog(@"location error:%@",error);
                }else{
                    NSError *placemarksError = [NSError errorWithDomain:@"locationError" code:-99999999 userInfo:@{@"locationError":@"placemarks.count <= 0"}];
                    ExecBlock(self.getLocationFailBlock,placemarksError);
                    DLog(@"location error:%@",placemarksError);
//                    [ToastTool showToast:[NSString stringWithFormat:@"location error placemarksError:%@",placemarksError]];
                }
            }else if(error){
                ExecBlock(self.getLocationFailBlock,error);
                DLog(@"location error:%@",error);
//                [ToastTool showToast:[NSString stringWithFormat:@"其他 error :%@",error]];
            }
    }];
}

@end
