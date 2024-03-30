//
//  AccountManager.m
//  Daleel
//
//  Created by mac on 2022/12/2.
//

// 当前登陆账号的用户信息的NSUserdefault 的 key
NSString * const SAVE_USER_KEY = @"SEAL_SAVE_USER";

#import "AccountManager.h"
#import "LoginViewController.h"
#import "LoginForUnexpectedViewController.h"

static AccountManager *_instance = nil;
static dispatch_once_t onceToken;

@interface AccountManager ()

/// 当前用户登陆状态
@property (nonatomic, assign) AccountManagerState accountState;
/// 是否正在刷新token
@property (nonatomic,assign) BOOL isRefreshingToken;
/// 监听回调字典
@property (nonatomic,strong) NSMutableDictionary <NSString *,void(^)(AccountManagerState state, id msg)> *listenerBlockDic;
/// 谷歌token
@property (nonatomic, strong) NSString *googleToken;

@end

@implementation AccountManager

+(void)load {
    // 初始化
    [AccountManager sharedInstance];
}

+ (instancetype)sharedInstance {
    if (!_instance) {
        _instance = [[self alloc] init];
        [_instance getSavedUserInfo];
    }
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copy {
    DLog(@"这是一个单例对象，copy将不起任何作用");
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
    _instance = nil;
}

- (void)dealloc {
    DLog(@"Account_Login&Regist_process - dealloc");
}

#pragma mark - private
/// 初始化单例的时候  获取用户信息  发现没有用户 则创建游客
- (void)getSavedUserInfo {
    NSData *data = [kUSER_DEFAULT objectForKey:SAVE_USER_KEY];
    UserModel *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (user.token.length > 0) {
        _userInfo = user;
        [self accountSateChanged:_userInfo.touristFlag == 1 ? AccountManagerState_GuestLogined : AccountManagerState_Logined];
        // 每次app启动都要更新下用户信息
        [self refreshUserInfoSuccess:nil failure:nil];
    }else {
        [self accountSateChanged:AccountManagerState_Undefind];
        // 没有登陆 创建游客
        [self createGuestUser];
    }
}

- (BOOL)isLogin {
    return _userInfo.token.length > 0;
}

/// 更新用户信息,和token 独立
- (void)setUserInfo:(UserModel *)userInfo {
    _userInfo = userInfo;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_userInfo];
    [kUSER_DEFAULT setObject:data forKey:SAVE_USER_KEY];
    [kUSER_DEFAULT synchronize];
}

/// 创建游客身份
- (void)createGuestUser {
    DLog(@"Account_Login&Regist_process --- 创建游客身份ing");
    [self accountSateChanged:AccountManagerState_GuestLogining];
    [AccountNetworkTool touristRegistWithDeviceId:[DeviceTool getUUIDInKeychain] success:^(id  _Nullable responseObject) {
        DLog(@"Account_Login&Regist_process --- 创建游客 成功")
        // 更新用户状态
        [self accountSateChanged:AccountManagerState_GuestLogined];
        // 创建游客身份成功
        // 保存用户信息 游客用户信息和普通用户没有本质区别
        NSDictionary *userInfoDic = (NSDictionary *)responseObject;
        UserModel *userModel = [UserModel mj_objectWithKeyValues:userInfoDic];
        [self updateAndSaveUserinfo:userModel];
    } failure:^(NSError * _Nonnull error) {
        DLog(@"Account_Login&Regist_process --- 创建游客 失败")
        // 创建游客身份失败
        DLog(@"创建游客身份失败 %@",error.userInfo);
//        kToast(error.userInfo[kHttpErrorReason]);
        // 更新用户状态
        [self accountSateChanged:AccountManagerState_GuestLoginFail];
    }];
}

/// 清除数据
- (void)clearUserInfo {
    [kUSER_DEFAULT removeObjectForKey:SAVE_USER_KEY];
    [kUSER_DEFAULT synchronize];
    _userInfo = nil;
}

/// 登出
- (void)logoutWithUnexpected:(BOOL)isUnexpected {
    [self logoutThinking];
    // 游客模式不会走异常登出
    if (isUnexpected && kUser.userInfo.touristFlag != 1) { // 意外登出 不要删除用户信息
        DLog(@"Account_Login&Regist_process --- 意外登出了 清空本地token refreshtoken 但是不会晴空用户信息");
        // 更新token refreshtoken 为空
        [self updateToken:@"" refreshToken:@""];
        //异常登出的弹窗
        [self pushUnexpectedLogin];
        // 账号状态变化
        [self accountSateChanged:AccountManagerState_LogoutUnexcepted];
    }else {
        if(kUser.userInfo.touristFlag == 1) {
            DLog(@"Account_Login&Regist_process --- 游客异常登出 清空用户信息 切换到主页 准备创建游客身份");
        }else {
            DLog(@"Account_Login&Regist_process --- 正常登出 清空用户信息 切换到主页 准备创建游客身份");
        }
        // 正常登出
        // 登出接口调用
        [AccountNetworkTool logoutSuccess:nil failure:nil];
        [self clearUserInfo];
        // 切换到首页
        [self pushRootVC];
        // 账号状态变化
        [self accountSateChanged:AccountManagerState_Logout];
        // 创建游客身份
        [self createGuestUser];
    }
}

/// 切换到首页
- (void)pushRootVC {
    // nav切换到首页
    DLog(@"Account_Login&Regist_process --- 切换到主页");
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [nav popToRootViewControllerAnimated:NO];
}

// 展示异常登出弹窗
- (void)pushUnexpectedLogin {
    DLog(@"Account_Login&Regist_process --- 异常登出后 弹窗弹出来");
    
    /// 防止多次弹出异常登出登陆弹窗 
    BaseViewController *currentVc = (BaseViewController *)[UIViewController getCurrentViewController];
    if ([currentVc isMemberOfClass:LoginForUnexpectedViewController.class]) {
        return;
    }
    
    LoginForUnexpectedViewController *vc = [[LoginForUnexpectedViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [UIViewController getCurrentViewController].definesPresentationContext = YES;
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [[UIViewController getCurrentViewController] presentViewController:nav animated:YES completion:nil];
    vc.closeBtnBlock = ^{
        // 异常登出后用户选择了不要登陆 则重新创建游客模式
        // 创建游客身份
        DLog(@"Account_Login&Regist_process --- 异常登出后弹窗点击关闭 清除用户数据 创建游客身份");
        [self clearUserInfo];
        [self createGuestUser];
    };
}

/// 账号状态变化  之行状态监听的回调
- (void)accountSateChanged:(AccountManagerState)state {
    DLog(@"Account_Login&Regist_process --- 账号状态变化了 state = %ld",state);
    if (state == AccountManagerState_Logined || state == AccountManagerState_GuestLogined || state == AccountManagerState_GuestLoginFail || state == AccountManagerState_Undefind) {
        // 只有这几个状态才会保存 其他状态只是过客
        _accountState = state;
    }
    for (NSString *key in self.listenerBlockDic.allKeys) {
        if (state == AccountManagerState_UpdatedUserInfo) {
            ExecBlock(self.listenerBlockDic[key],state,_userInfo);
        }else {
            ExecBlock(self.listenerBlockDic[key],state,nil);
        }
    }
}

- (void)requestToSaveGoogleToken {
    if (self.googleToken.length == 0) {
        return;
    }
    [AccountNetworkTool pushGooogleTokenParam:@{@"googleToken" : self.googleToken} andWithSuccess:^(NSDictionary * _Nullable resultDics) {
        DLog(@"requestToSaveGoogleTokenSuccess : %@", resultDics);
    } failure:^(NSError * _Nonnull error) {
        DLog(@"requestToSaveGoogleTokenError : %@", error.userInfo);
        //kToast(error.userInfo[kHttpErrorReason]);
    }];
}

#pragma mark - public

/// 高版本用户第一次安装  没有网络  处理
- (void)firstInstalledAppForInitAcount {
    if (@available(iOS 16.0, *)) {
        if (!self.isLogin){
            [self createGuestUser];
        }
        // 第一次安装谷歌推送token给后台
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self requestToSaveGoogleToken];
        });
    }
}

/// 刷新用户信息
- (void)refreshUserInfoSuccess:(void  (^ _Nullable )(UserModel *userInfo))success failure:(void  (^ _Nullable )(NSError *error))failure {
    if (!self.isLogin) {
        return;
    }
    DLog(@"Account_Login&Regist_process --- 接口刷新用户信息");
    [AccountNetworkTool getUserInfo:^(id  _Nullable responseObject) {
        NSDictionary *userInfoDic = (NSDictionary *)responseObject;
        UserModel *userModel = [UserModel mj_objectWithKeyValues:userInfoDic];
        [self updateAndSaveUserinfo:userModel];
        
        ExecBlock(success,userModel);
    } failure:^(NSError * _Nonnull error) {
        DLog(@"Account_Login&Regist_process --- 获取用户信息出错： %@", error.userInfo);
        ExecBlock(failure,error);
    }];
}

/// 刷新用户token
- (void)refreshTokenSuccess:(void(^)(void))success failure:(void(^)(NSError *error))failure {
    DLog(@"Account_Login&Regist_process --- token过期了 有可能两天后 也有可能被顶掉了  开始刷新token ");
    if (self.isRefreshingToken) {return;}
    self.isRefreshingToken = YES;
    [AccountNetworkTool refreshTokenSuccess:^(id  _Nullable responseObject) {
        DLog(@"Account_Login&Regist_process --- token过期了 刷新token 成功");
        kToast(kLocalize(@"Network connection failed, please try again later"));
        [self updateToken:[NSString stringWithFormat:@"%@",responseObject[@"token"]] refreshToken:[NSString stringWithFormat:@"%@",responseObject[@"refreshToken"]]];
        ExecBlock(success);
        self.isRefreshingToken = NO;
    } failure:^(NSError * _Nonnull error) {
        /// 意外退出登陆  进入首页
        DLog(@"Account_Login&Regist_process --- 通过renfreshtoken刷新token失败，原因:被别人顶掉了 OR 异常 ，异常登出会删除token refreshtoke 不会删除用户本地数据，进入首页，error： %@", error.userInfo);
        [self logoutWithUnexpected:YES];
        [NetworkService cancelAllRequest];
//        kToast(kLocalize(@"Login has expried, please login again"));
        ExecBlock(failure,error);
        self.isRefreshingToken = NO;
    }];
}

- (void)updateAndSaveUserinfo:(UserModel *)userInfo {
    if(!userInfo) {
        DLog(@"更新用户信息不能为空")
        return;
    }
    if (userInfo.token.length <= 0 || userInfo.refreshToken.length <= 0) {
        DLog(@"保存用户信息token OR refreshToken可能存在问题");
    }
    DLog(@"Account_Login&Regist_process --- 更新单例和本地用户信息 ")
    _userInfo = userInfo;
    // 保存本地
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_userInfo];
    [kUSER_DEFAULT setObject:data forKey:SAVE_USER_KEY];
    [kUSER_DEFAULT synchronize];
    [self accountSateChanged:AccountManagerState_UpdatedUserInfo];
}

- (void)getAccountSate:(void (^)(AccountManagerState))currentState addListenerWithKey:(NSString *)key listener:(void (^)(AccountManagerState, id _Nonnull))listenerBlock {
    ExecBlock(currentState,_accountState);
    if(key.length > 0 && listenerBlock) {
        DLog(@"Account_Login&Regist_process --- 添加了用户登陆状态监听了 key=%@",key);
        [self.listenerBlockDic setValue:listenerBlock forKey:key];
    }
}

- (void)removeListenerWithKey:(NSString *)key {
    [self.listenerBlockDic removeObjectForKey:key];
}

/// 登陆注册成功后走的唯一入口
- (void)loginedAndSaveUserinfo:(UserModel *)userInfo {
    // 更新保存用户信息
    [self updateAndSaveUserinfo:userInfo];
    // 检测用户状态
    if (userInfo.touristFlag == 1) {
        [self accountSateChanged:AccountManagerState_GuestLogined];
    }else {
        [self accountSateChanged:AccountManagerState_Logined];
        // 普通用户登陆保存token
        [self requestToSaveGoogleToken];
    }
    [self loginThinking];
}

- (void)updateToken:(NSString *)token refreshToken:(NSString *)refreshToken {
    if(token == nil) {
        DLog(@"保存token == nil 不保存")
    } else {
        _userInfo.token = token;
    }
    if(refreshToken == nil) {
        DLog(@"保存refreshToken == nil 不保存")
    }else {
        _userInfo.refreshToken = refreshToken;
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_userInfo];
    [kUSER_DEFAULT setObject:data forKey:SAVE_USER_KEY];
    [kUSER_DEFAULT synchronize];
}

- (void)logout {
    DLog(@"Account_Login&Regist_process --- 非游客模式下 主动退出登陆")
    _accountState =  AccountManagerState_Logout;
    [self logoutWithUnexpected:NO];
}

- (void)pushLogin {
    DLog(@"Account_Login&Regist_process --- 弹出登陆界面")
    LoginViewController *v = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:v];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [[UIViewController getCurrentViewController] presentViewController:nav animated:YES completion:^{
    }];
}

- (void)saveFcmToken:(NSString *)fcmToken {
    self.googleToken = fcmToken;
    if (_accountState == AccountManagerState_Logined) { // 普通账户登陆才会给后台谷歌推送token
        [self requestToSaveGoogleToken];
    }
}

#pragma mark - lazyload
- (NSMutableDictionary *)listenerBlockDic {
    if(!_listenerBlockDic){
        _listenerBlockDic = [NSMutableDictionary dictionary];
    }
    return _listenerBlockDic;
}

#pragma mark - 其他

- (void)getDeleteInfo {
    if (!self.isLogin || self.userInfo.touristFlag == 1) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [AccountNetworkTool getDeleteInfoSuccess:^(id  _Nullable responseObject) {
            /// 0正常 1注销中 2已注销
            NSInteger isDelete = [responseObject[@"destroyFlag"] boolValue];
            if (isDelete == 1) {
                NSInteger deleteApplyTime = [responseObject[@"destroyDate"] integerValue];
                NSInteger deleteTime = [responseObject[@"deleteTime"] integerValue];
                NSString *str = [NSString stringWithFormat:kLocalize(@"account_delete_freeze_period_terminated"),[NSDate convertTimeWithUTCTimeStamp:deleteApplyTime format:@"yyyy-MM-dd HH:mm:ss"],[NSDate convertTimeWithUTCTimeStamp:deleteTime format:@"yyyy-MM-dd HH:mm:ss"]];
                [UIAlertController showAlertInViewController:[UIViewController getCurrentViewController] withTitle:nil message:str cancelButtonTitle:kLocalize(@"OK") destructiveButtonTitle:nil otherButtonTitles:@[] tapBlock:^(UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                }];
            }
        } failure:^(NSError * _Nonnull error) {
            
        }];
    });
}

- (void)setIQkeyboard:(BOOL)enable {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = enable;
    manager.shouldResignOnTouchOutside = enable;
    manager.enableAutoToolbar = NO;
}

#pragma mark - 数数埋点设置账号

- (void)loginThinking {
    
}
- (void)logoutThinking {
    
}

//#pragma mark - 测试用
//#if DEBUG
//// 模拟token失效
//- (void)testForTokenInvalid {
//    [self updateToken:@"11111212313" refreshToken:nil];
//}
//// 模拟refreshtoken & token失效 （被顶掉了 意外登出）
//- (void)testForRefreshTokenInvalid {
//    [self updateToken:@"1312313132131" refreshToken:@"665etrterterterte"];
//}
//
//- (void)testForCreateGusetFail {
//    [self clearUserInfo];
//    // 更新用户状态
//    [self accountSateChanged:AccountManagerState_GuestLoginFail];
//}
//#endif

@end
