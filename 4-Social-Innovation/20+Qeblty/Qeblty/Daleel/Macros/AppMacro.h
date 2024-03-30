//
//  AppMacro.h
//  Gamfun
//
//  Created by mac on 2022/6/2.
//

#ifndef AppMacro_h
#define AppMacro_h

// 网络请求url拼接
#define URL(path) [NSString stringWithFormat:@"%@%@",kRequestServerDomain, path]
#define WEBURL(path) [NSString stringWithFormat:@"%@/%@",kRequestWebDomain, path]

/// 是否加密
#define isEntry NO


#if DEBUG
/// 增加本地测试开关   NO为本地可以更改时间测试   YES表示跟随服务器时间  即使本地更改时间 也不会更改时间签到
#define isService YES
#else
#define isService YES
#endif

/// yp - 打印请写 DLog
#if DEBUG
#define DLog(fmt, ...) NSLog((@"[Function:%s\n - Line:%d] \n" fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__);
//#define DLog(fmt, ...) NSLog((@"\n[File:%s]\n" "[Function:%s]\n" "[Line:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

/// yp -  代码中直接使用此宏定义 减少代码中block判断
#define ExecBlock(block, ...) if (block) { block(__VA_ARGS__); }
/// yp - 判断是否为空对象
#define kIsNilOrNull(__object)  ((nil == __object) || [__object isKindOfClass:[NSNull class]])

/// yp - 国际化方法
#define kLocalize(key) NSLocalizedString(key, nil)
/// 图片
#define kImageName(imageName) [UIImage imageNamed:imageName]
/// yp - 屏幕宽度
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
/// yp - 屏幕高度
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
/// yp - 是否为iPhone
#define Is_Iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
/// yp - 是否为iPad
#define IS_IPAD [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad
/// yp - 是否是x系列
#define Is_Iphone_X (Is_Iphone && (double)kScreenHeight - (double)812 >= 0.0)
/// yp - 导航栏高度
#define kHeight_NavBar  (Is_Iphone_X ? 88 : 64)
/// yp - 状态栏高度
#define kHeight_StatusBar (Is_Iphone_X ? 44 : 20)
/// yp - tabbar高度
#define kHeight_Tabbar (Is_Iphone_X ? 98 : 49)
/// yp - iphoneX tabbar额外高度
#define kHeight_Tabbar_Extra (Is_Iphone_X ? 34 : 0)
/// yp - iphoneX 底部安全距离
#define kHeight_Bottom_Extra (Is_Iphone_X ? 13 : 0)

/// yp - 本地持久化宏
#define kUSER_DEFAULT [NSUserDefaults standardUserDefaults]
/// yp - 存
#define kUDSetObjForKey(VALUE,KEY)  [kUSER_DEFAULT setObject:VALUE forKey:KEY]
/// yp - 取
#define kUDObjForKey(KEY)     [kUSER_DEFAULT objectForKey:KEY]

/// yp - 本地存储  路径
#define kPATH_TEMP NSTemporaryDirectory()
#define kPATH_DOCUMENT [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kPATH_CACHE [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

/// 无特殊需求 toast
#define kToast(x) [ToastTool showToast:x]

/// 用户信息单例模型
#define kUser [AccountManager sharedInstance]
#define kUserModel kUser.userInfo

#define kPageSize 10
#define kPageSize_message 10

#define kLastPhone @"lastPhone"
#define kIsAR [LanguageTool isArabic]

#define kUserDefaults  [NSUserDefaults standardUserDefaults]

#define kFirstInstall @"FirstInstall"
#define kLocationCity @"LocationCity"
#define kLocationLimit @"LocationLimit"
#define kNotificationLimit @"NotificationLimit"
#define kLocationLatitude @"LocationLatitude"
#define kLocationlongitude @"Locationlongitude"
#define kLocationLastPrayerTime @"LocationLastPrayerTime"

#define kLatitude  [kUserDefaults valueForKey:kLocationLatitude]
#define kLongitudeStr  [kUserDefaults valueForKey:kLocationlongitude]
#define kCityName  [kUserDefaults valueForKey:kLocationCity]


/**
 *  打开Url
 */
UIKIT_STATIC_INLINE void openUrl(NSString *url , NSDictionary<UIApplicationOpenExternalURLOptionsKey, id> *options) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:options completionHandler:^(BOOL success) {
    }];
}


#endif /* AppMacro_h */
