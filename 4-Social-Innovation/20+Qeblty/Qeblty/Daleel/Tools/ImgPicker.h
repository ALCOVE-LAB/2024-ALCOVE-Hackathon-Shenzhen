//
//  ImgPicker.h
//  sealLive
//
//  Created by apple on 2020/8/8.
//  Copyright © 2020 seallive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrivacyAuthorization.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ImagePickBlock) (UIImage *_Nullable img);

@interface ImgPicker : NSObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, copy) ImagePickBlock _Nullable pickBlock;

- (void)showPickInVC:(UIViewController *)vc sourceType:(UIImagePickerControllerSourceType)sourceType completion:(ImagePickBlock)completion;
- (void)showNoEditPickInVC:(UIViewController *)vc sourceType:(UIImagePickerControllerSourceType)sourceType completion:(ImagePickBlock)completion;

- (void)uploadImage:(UIImage *)img index:(NSNumber *)index success:(void (^)(id responseObject))success progress:(void (^)(NSProgress * _Nonnull progress))progressBlock failure:(void (^)(NSError *error))failure;

- (void)uploadImages:(NSArray *)imgs success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
