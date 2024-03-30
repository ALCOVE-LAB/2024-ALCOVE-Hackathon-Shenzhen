//
//  DownloadSoundManager.h
//  Daleel
//
//  Created by mac on 2022/12/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^CallbackBlock)(NSString * _Nullable path, BOOL success);
@interface DownloadSoundManager : NSObject

+ (DownloadSoundManager *) sharedInstance;

/**
 开始下载资源的方法
 */
- (NSURLSessionDownloadTask *)dl_beginDownLoadSoundsResourceWithUrl:(NSString *)url andWithProgress:(void(^)(NSProgress *downloadProgress))progressBlock andWithCallBack:(CallbackBlock)callBack;

/// 获取相关路径下的所有文件
- (NSArray *)getAllFileByName:(NSString *)path;

/// 判断文件是否存在
- (BOOL)judgeFileExist:(NSString *)fileName;
@end

NS_ASSUME_NONNULL_END
