//
//  ImagePicker.m
//  Gamfun
//
//  Created by mac on 2022/7/18.
//

#import "ImgPicker.h"
#import <MobileCoreServices/MobileCoreServices.h>


@implementation ImgPicker

- (UIImagePickerController *)imagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        return nil;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    imagePickerController.sourceType = sourceType;
    imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    imagePickerController.navigationBar.translucent = NO;
    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    
    return imagePickerController;
}

- (void)showPickInVC:(UIViewController *)vc sourceType:(UIImagePickerControllerSourceType)sourceType completion:(ImagePickBlock)completion {
    if (!vc) {
        vc = [UIViewController getCurrentViewController];
    }
    UIImagePickerController *imagePicker = [self imagePickerControllerWithSourceType:sourceType];
    if (imagePicker) {
        MJWeakSelf;
        [self privacyAuthorizationStateWithSourceType:sourceType showAlertIn:imagePicker success:^(bool isOpen) {
            if (isOpen) {
                weakSelf.pickBlock = completion;
                [vc presentViewController:imagePicker animated:YES completion:nil];
            }
        }];
    }
}
- (void)showNoEditPickInVC:(UIViewController *)vc sourceType:(UIImagePickerControllerSourceType)sourceType completion:(ImagePickBlock)completion {
    UIImagePickerController *imagePicker = [self imagePickerControllerWithSourceType:sourceType];
    imagePicker.allowsEditing = NO;
    if (imagePicker) {
        MJWeakSelf;
        [self privacyAuthorizationStateWithSourceType:sourceType showAlertIn:imagePicker success:^(bool isOpen) {
            if (isOpen) {
                weakSelf.pickBlock = completion;
                imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
                [vc presentViewController:imagePicker animated:YES completion:nil];
            }
        }];
    }
}

- (void)privacyAuthorizationStateWithSourceType:(UIImagePickerControllerSourceType)sourceType showAlertIn:(UIViewController *)controller success:(void (^)(bool isOpen))success {
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        success(NO);
        if (![PrivacyAuthorization authorizationStatusForMediaTypeCamera]) {
            [UIAlertController showAlertInViewController:controller withTitle:kLocalize(@"Get permission to access the camera") message:kLocalize(@"Gamfun gets your camera permissions for image uploads and sets up your user profile") cancelButtonTitle:kLocalize(@"Cancel") destructiveButtonTitle:nil otherButtonTitles:@[kLocalize(@"Allow")] tapBlock:^(UIAlertAction *action, NSInteger buttonIndex) {
                if ([action.title isEqualToString:kLocalize(@"Allow")]) {
                    [PrivacyAuthorization openSetting];
                }
            }];
        }else {
            success(YES);
        }
    }else if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        if (![PrivacyAuthorization authorizationStatusForPhotoLibrary]) {
            success(NO);
            [UIAlertController showAlertInViewController:controller withTitle:kLocalize(@"Get permission to access the album") message:kLocalize(@"Gamfun gets your camera permissions for image uploads and sets up your user profile") cancelButtonTitle:kLocalize(@"Cancel") destructiveButtonTitle:nil otherButtonTitles:@[kLocalize(@"Allow")] tapBlock:^(UIAlertAction *action, NSInteger buttonIndex) {
                if ([action.title isEqualToString:kLocalize(@"Allow")]) {
                    [PrivacyAuthorization openSetting];
                }
            }];
        }else {
            success(YES);
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *img = info[picker.allowsEditing ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.pickBlock) {
            self.pickBlock(img);
        }
        self.pickBlock = nil;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        self.pickBlock = nil;
    }];
}

- (void)uploadImage:(UIImage *)img index:(NSNumber *)index success:(void (^)(id responseObject))success progress:(void (^)(NSProgress * _Nonnull progress))progressBlock failure:(void (^)(NSError *error))failure {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *imgData = [self resizeImage:img];
        [NetworkService uploadWithURL:URL(kRequestUpLoadFile) parameters:@{@"index":@(0),@"userId":kUser.userInfo.userId} fileData:@[imgData] fileNames:@[@"file"] mimeType:nil progress:^(NSProgress * _Nonnull progress) {
            if (progressBlock) {
                progressBlock(progress);
            }
        } success:^(id  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
    });
}

- (void)uploadImages:(NSArray *)imgs success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *imgDatas = [[NSMutableArray alloc] init];
        for (UIImage *img in imgs) {
            NSData *imgData = [self resizeImage:img];
            [imgDatas addObject:imgData];
        }
        [NetworkService uploadWithURL:URL(kRequestUpLoadFile) parameters:nil fileData:imgDatas fileNames:nil mimeType:nil progress:nil success:^(id  _Nonnull responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
    });
}

/// 图片压缩
- (NSData *)resizeImage:(UIImage *)img {
    if (!img) return nil;
    CGFloat maxLength = 1024.0 * 1024.0;
    CGFloat resizeRate = 1.0f;
    NSData *imageData = UIImageJPEGRepresentation(img, resizeRate);
    if (imageData.length < maxLength) return imageData;
    CGFloat max = 1;
    CGFloat min = 0;
    for (NSInteger i = 0; i < 6; i++) {
        resizeRate = (max + min) / 2;
        imageData = UIImageJPEGRepresentation(img, resizeRate);
        
        if (imageData.length < maxLength * 0.9) {
            min = resizeRate;
        } else if (imageData.length > maxLength * 1.5) {
            max = resizeRate;
        } else {
            break;
        }
    }
    return imageData;
}

@end
