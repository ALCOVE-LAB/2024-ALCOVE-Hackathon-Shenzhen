//
//  AuthInfoModel.h
//  Daleel
//
//  Created by mac on 2024/3/31.
//

#import "BaseModel.h"
#import "EnumHeader.h"
/**
 认证信息
 */

NS_ASSUME_NONNULL_BEGIN

@interface AuthInfoModel : BaseModel

/// 认证内容
@property (nonatomic, copy) NSString *authContent;

@property (nonatomic, copy) NSString *authIcon;
/// 认证类型（0：ustaz认证）
@property (nonatomic, assign) UserAuthType authType;

@end

NS_ASSUME_NONNULL_END
