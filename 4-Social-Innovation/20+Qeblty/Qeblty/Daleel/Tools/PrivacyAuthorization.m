//
//  PrivacyAuthorization.m
//  Gamfun
//
//  Created by mac on 2022/7/18.
//

#import "PrivacyAuthorization.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@implementation PrivacyAuthorization

#pragma mark - 相机授权状态
+ (BOOL)authorizationStatusForMediaTypeCamera {
    return [self authorizationStatusForMediaType:AVMediaTypeVideo];
}

+ (BOOL)authorizationStatusForMediaType:(AVMediaType)mediaType {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus ==AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
        return NO;
    }
    
    return YES;
}

#pragma mark - 相册授权状态
+ (BOOL)authorizationStatusForPhotoLibrary {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        return NO;
    }
    
    return YES;
}

+ (void)openSetting {
    openUrl(UIApplicationOpenSettingsURLString, @{});
}



@end
