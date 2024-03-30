//
//  UserModel.m
//  Gamfun
//
//  Created by mac on 2024/3/29.
//

#import "UserModel.h"

@implementation UserModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"authInfoList":@"AuthInfoModel"};
}

@end

