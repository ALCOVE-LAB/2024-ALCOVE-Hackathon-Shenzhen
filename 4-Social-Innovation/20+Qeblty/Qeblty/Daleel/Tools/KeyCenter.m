//
//  KeyCenter.m
//  Gamfun
//
//  Created by mac on 2022/6/10.
//

#import "KeyCenter.h"

@implementation KeyCenter


+ (NSString *)googleClientId {
    return @"624972041406-fr6n4obil8prkt8ifr37lc4jldks64id.apps.googleusercontent.com";
}

+ (NSString *)googleClientSecret {
    return @"AIzaSyCViaP8yCJWyv_Tav1mtnfHpemPmUkDH0k";
}

+ (NSString *)facebookAppId {
    return @"3764511587108477";
}

+ (NSString *)facebookToken {
    return @"90bf79fb13fc8a1a2c30ed150cf3e8f4";
}

+ (NSString *)insAppId {
    return @"1430877740739496";
}
+ (NSString *)insAppSecrect {
    return @"caf3b014cf464cd76d06bceff3b3fc3f";
}

+ (NSString *)tiktokAppKey {
    return @"awrobryai4zdv9ss";
}
+ (NSString *)tiktokAppSecrect {
    return @"48e8c09f59e2bb608de3d6aa6aa86062";
}

+ (NSString *)snapAppId {
    return @"d764e0d4-a8bd-425d-b2a7-912bcd91ac76";
}
+ (NSString *)snapSecrect {
    return @"KqifUubjFc6IBBryLRrJSTPdWo5jTe53-4djOoaPzt8";
}

+ (NSString *)thinkingAppId {
#if DEBUG
    return @"debug-appid";
#else
    return @"0807655febb34ad1b4d83022e075cad2";
#endif
    
}

+ (NSString *)thinkingServer {
    return @"http://77.242.243.108:8991/";
}

@end
