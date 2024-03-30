//
//  phoneLoginViewController.h
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "BaseVMViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhoneLoginViewController : BaseVMViewController

/// 上一个页面 0 从登录注册 landing page 进入, 1从 phone sign in 页面进入 , 2,从 phone sign up 页面进入
@property(nonatomic,assign)int type;

@end

NS_ASSUME_NONNULL_END
