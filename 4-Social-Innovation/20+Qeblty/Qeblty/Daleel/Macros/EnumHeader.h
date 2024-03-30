//
//  EnumHeader.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//


typedef NS_ENUM(NSUInteger, AccountLoginType) {
    AccountLoginType_phone = 0,
    AccountLoginType_facebook = 1,
    AccountLoginType_google = 2,
    AccountLoginType_apple = 3,
    AccountLoginType_matamask = 4,
};

typedef enum : NSUInteger {
    UserAuthTypeUstaz = 0,
} UserAuthType;
