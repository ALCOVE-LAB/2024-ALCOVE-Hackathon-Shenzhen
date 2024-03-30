//
//  LoginThirdAuthorizeTool.m
//  Daleel
//
//  Created by mac on 2022/11/30.
//

#import "LoginThirdAuthorizeTool.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <ShareSDK/ShareSDK.h>
#import <Daleel-Swift.h>

@interface LoginThirdAuthorizeTool ()

@end

@implementation LoginThirdAuthorizeTool

+ (void)authorizeWithPlatformType:(AccountLoginType)type
                          success:(void(^_Nullable)(NSString *userId, AccountLoginType type))successBlock
                      cancelShare:(void(^_Nullable)(void))cancelBlock
                             fail:(void(^_Nullable)(NSError *_Nullable error))failBlock {
    
    if (type == AccountLoginType_google) {
        GIDConfiguration *signInConfig = [[GIDConfiguration alloc] initWithClientID:[KeyCenter googleClientId]];
        [GIDSignIn.sharedInstance signInWithConfiguration:signInConfig
                                 presentingViewController:[UIViewController getCurrentViewController]
                                                 callback:^(GIDGoogleUser * _Nullable user, NSError * _Nullable error) {
            if (error) {
                if(error.code == -5 || [error.userInfo.description isEqualToString:@"The user canceled the sign-in flow."]) {
                    cancelBlock();
                }else {
                    failBlock(error);
                    // kToast(error.userInfo.description);
                }
                return;
            }
            if (user == nil) {
                NSError * error1 = [NSError errorWithDomain:@"com.google.GIDSignIn_LoginThirdAuthorizeTool" code:-99999999 userInfo:@{@"NSLocalizedDescription":@"user == nil"}];
                failBlock(error1);
                //kToast(@"user == nil");
                return;
            }
            NSString *userId = user.userID;
            successBlock(userId,type);
        }];
        return;
    }
    
    if (type == AccountLoginType_matamask) {
        JJPerson *p = [[JJPerson alloc] init];
        
        [p connectAndSignWithCallBlock:^(BOOL isSuccess, NSString * _Nonnull account) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isSuccess) {
                    NSLog(@"block收到了account = %@",account);
                    successBlock(account,AccountLoginType_google);
                } else {
                    NSError *error = [[NSError alloc] initWithDomain:account code:-100000 userInfo:@{}];
                    failBlock(error);
                }
            });
            
        } completionHandler:^{
            
        }];
        return;
    }
    
    SSDKPlatformType platform = SSDKPlatformTypeFacebook;
    if (type == AccountLoginType_facebook) {
        platform = SSDKPlatformTypeFacebook;
    }else if (type == AccountLoginType_apple) {
        platform = SSDKPlatformTypeAppleAccount;
    }
    NSDictionary * settings = nil;
    if (platform == SSDKPlatformTypeFacebook) {
        settings = @{@"isBrowser":@(YES)};
    }
    
    [ShareSDK authorize:platform settings:settings onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                if (state == SSDKResponseStateSuccess) {
                    // DLog(@"authorize - user %@", user.uid);
                    successBlock(user.uid,type);
                }else if(state == SSDKResponseStateCancel) {
                    cancelBlock();
                }else {
                    // kToast(kLocalize(@"Authorization failed, please try again"));
                }
            }else {
                failBlock(error);
                // kToast(error.userInfo[@"error_message"]);
            }
        });
    }];
}


@end
