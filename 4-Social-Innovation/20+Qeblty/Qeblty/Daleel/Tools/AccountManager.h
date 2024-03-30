//
//  AccountManagerq.h
//  Daleel
//
//  Created by mac on 2022/12/2.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

typedef enum : NSInteger {
    AccountManagerState_Logined = 1, // 正常用户已经登陆了
    AccountManagerState_GuestLogined, // 游客用户已经登陆了
    AccountManagerState_GuestLogining, // 游客正在登陆
    AccountManagerState_GuestLoginFail, // 游客登陆失败
    AccountManagerState_Logout, // 正常用户登出
    AccountManagerState_LogoutUnexcepted, // 账号异常登出
    AccountManagerState_Undefind, // 未知状态
    AccountManagerState_UpdatedUserInfo, // 更新了用户信息
//    AccountManagerState_PushLogin,
} AccountManagerState;

NS_ASSUME_NONNULL_BEGIN

@interface AccountManager : NSObject

+ (instancetype _Nonnull )sharedInstance;

/// 用户信息 只读  更新操作请用 updateAndSaveUserinfo
@property (nonatomic, strong, readonly) UserModel *userInfo;
/// 是否登陆  （主要判断本地保存的token是否存在 游客模式创建成功也是登陆成功状态 游客模式创建失败则属于未登陆状态）
@property (nonatomic, assign, readonly) BOOL isLogin;

/// 高版本用户第一次安装  没有网络  处理
- (void)firstInstalledAppForInitAcount;

/// 更新 用户信息（带着token refreshtoken的话也会更新）
- (void)updateAndSaveUserinfo:(UserModel *)userInfo;

/// 登录注册成功后保存用户信息（登陆注册成功后唯一入口）
- (void)loginedAndSaveUserinfo:(UserModel *)userInfo;

/// 添加监听账号状态的回调
/// - Parameters:
///   - currentState: 直接返回当前状态
///   - key: 设置监听回调的唯一key
///   - listenerBlock: 回调
- (void)getAccountSate:(void(^_Nullable)(AccountManagerState state))currentState addListenerWithKey:(NSString *)key listener:(void(^)(AccountManagerState state, id msg))listenerBlock;

/// 删除监听
- (void)removeListenerWithKey:(NSString *)key;

/// 刷新用户数据  重新请求接口数据
- (void)refreshUserInfoSuccess:(void  (^ _Nullable )(UserModel *userInfo))success failure:(void  (^ _Nullable )(NSError *error))failure;

/// 刷新用户token
- (void)refreshTokenSuccess:(void(^)(void))success failure:(void(^)(NSError *error))failure;

///  跳转登陆页面
- (void)pushLogin;

///  登出 (用户点击退出 正常退出)
- (void)logout;

/// 保存谷歌token
- (void)saveFcmToken:(NSString *)fcmToken;

#pragma mark - 其他
/// 获取用户注销信息
- (void)getDeleteInfo;

- (void)setIQkeyboard:(BOOL)enable;

//#pragma mark - 测试用
//#if DEBUG
//// 模拟token失效
//- (void)testForTokenInvalid;
//// 模拟refreshtoken & token失效 （被顶掉了 意外登出）
//- (void)testForRefreshTokenInvalid;
//// 模拟游客创建失败了
//- (void)testForCreateGusetFail;
//#endif

@end

NS_ASSUME_NONNULL_END
