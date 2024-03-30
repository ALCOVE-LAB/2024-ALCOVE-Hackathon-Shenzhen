//
//  DownloadSoundManager.m
//  Daleel
//
//  Created by mac on 2022/12/12.
//

#import "DownloadSoundManager.h"
#import <AVFoundation/AVFoundation.h>
#import "AVAudioManager.h"

static DownloadSoundManager *downloadManger;

@interface DownloadSoundManager (){
    NSString *audioFileDirPath_;
}

// 文件处理
@property (nonatomic, strong)NSFileManager *fileManager;
@property (nonatomic,strong)NSURL *filePath;

@end

@implementation DownloadSoundManager

+ (DownloadSoundManager *) sharedInstance {
    static dispatch_once_t push_handle_once;
    dispatch_once(&push_handle_once, ^{
        downloadManger = [[DownloadSoundManager alloc] init];
    });
    return downloadManger;
}

- (NSURLSessionDownloadTask *)dl_beginDownLoadSoundsResourceWithUrl:(NSString *)url andWithProgress:(void(^)(NSProgress *downloadProgress))progressBlock andWithCallBack:(CallbackBlock)callBack{
    NSString *musictr = [[url componentsSeparatedByString:@"/"] lastObject];
    if ([[DownloadSoundManager sharedInstance] judgeFileExist:musictr]) {
        return nil;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if ([url hasPrefix:@"https://"]) {
        manager.securityPolicy.allowInvalidCertificates = YES; // 允许自签名的ssl证书
        manager.securityPolicy.validatesDomainName = NO;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

    @weakify(self);
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        CGFloat f = (float)downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        DLog(@"+++++++++%f",f);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        // 下载的临时文件路径
        NSString *fileName = [[url componentsSeparatedByString:@"/"] lastObject];
        NSString *storePath = nil;
        storePath = [[self tmp] stringByAppendingPathComponent:fileName];
        // 判断临时文件是否存在，存在则删除
        if ([self.fileManager fileExistsAtPath:storePath]) {
            [self.fileManager removeItemAtPath:storePath error:nil];
        }
        return [NSURL fileURLWithPath:storePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        @strongify(self);
//        [self writeMusicDataWithUrl:filePath.path andWithSubFile:@"" callback:^(BOOL success, NSString *fileName) {
        if ([self.filePath.path isEqualToString:filePath.path]) {
            return;
        }
        if (filePath) {
            [self dl_cutDownMp3FileWithFile:filePath.path andWithMp3File:[NSHomeDirectory() stringByAppendingString:@"/Library"] andWithFileName:[filePath.path lastPathComponent]];
        }
        self.filePath = filePath;
//            NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Library"];
//            [self dl_cutDownMp3FileWithFile:[NSString stringWithFormat:@"%@%@",path,fileName] andWithMp3File:@"" andWithFileName:fileName];
        callBack(filePath.path,YES);
//        }];
    }];
    [task resume];
    return task;
}

// 获取沙盒tmp路径
- (NSString *)tmp {
    return NSTemporaryDirectory();
}

- (NSFileManager *)fileManager{
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

/**
 *  获取资源文件所在的沙盒文件夹路径
 *  @return 文件夹路径
 */

// 获取沙盒document路径
- (NSString *)document {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (NSArray *)getAllFileByName:(NSString *)path {
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSArray *array = [defaultManager contentsOfDirectoryAtPath:path error:nil];
    return array;
}

#pragma mark -- 判断是否存在文件
- (BOOL)judgeFileExist:(NSString *)fileName {
    //获取文件路径
    NSString *filepath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Library/Sounds/%@",fileName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filepath]) {
        DLog(@"file is exists");
        return YES;
    } else{
        DLog(@"file is not exists");
        return NO;
    };
}

#pragma mark -- 往声音目录/Library/Sounds/写入音频文件
- (void)writeMusicDataWithUrl:(NSString*)filePath andWithSubFile:(NSString *)subFile
                     callback:(void(^)(BOOL success,NSString * fileName))blockCallback {
    NSString *bundlePath = filePath;
    NSString *libPath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Library/%@/",subFile]];

    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:libPath]) {
        NSError *error;
        [manager createDirectoryAtPath:libPath withIntermediateDirectories:YES attributes:nil error:&error];
    }

    NSData *data = [NSData dataWithContentsOfFile:bundlePath];
    
    BOOL flag = [data writeToFile:[libPath stringByAppendingString:[filePath lastPathComponent]] atomically:YES];
    if (flag) {
        DLog(@"文件写成功");
        if (blockCallback) {
            blockCallback(YES,[filePath lastPathComponent]);
        }
    }else{
        DLog(@"文件写失败");
        if (blockCallback) {
            blockCallback(NO,nil);
        }
    }
}

#pragma mark -- 音频截取
- (void)dl_cutDownMp3FileWithFile:(NSString *)filePath andWithMp3File:(NSString *)exitPath andWithFileName:(NSString *)fileName {
    //获取MP3的路径
    NSURL *url = [NSURL fileURLWithPath:filePath];
    //1.创建AVURLAsset，可以获取里面的文件里面的信息
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    //2.创建音频文件(NSDocumentDirectory 是指程序中对应的Documents路径，而NSDocumentionDirectory对应于程序中的Library/Documentation路径，这个路径是没有读写权限的，所以看不到文件生成)
    //    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取数组里面的路径，iOS开发这里只有一个，但是Mac开发有两个
    //    NSString *documentsDirectoryPath = [dirs objectAtIndex:0];
    
    //这里我选取桌面的路径，上面的路径是沙盒路径，一般用于真实开发中
    NSString *exportPath = exitPath;
    //导出音频的路径+导出音频名字
    //因为iOS输出格式不知道.mp3,只能设置为.m4a
    NSString *usePath = [[fileName componentsSeparatedByString:@"."] firstObject];
    NSString *tempMusicPath = [NSString stringWithFormat:@"%@/%@.m4a",exportPath,usePath];
    
    //判断是否存在这个文件，如果存在，就删除这个文件
    if ([self.fileManager fileExistsAtPath:tempMusicPath]) {
        [self.fileManager removeItemAtPath:tempMusicPath error:nil];
        //            DLog(@"删除成功");
    }
    
    //3.创建音频输出会话
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:songAsset presetName:AVAssetExportPresetAppleM4A];
    
    //4.设置音频截取时间区域(CMTime在Core Medio框架中)
    CMTime startTime = CMTimeMake(0.f, 1);
    CMTime stopTime = CMTimeMake(28.f, 1);
    CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(startTime, stopTime);
    
    //5.设置音频输出会话并执行
    exportSession.outputURL = [NSURL fileURLWithPath:tempMusicPath];
    exportSession.outputFileType = AVFileTypeAppleM4A;
    exportSession.timeRange = exportTimeRange;
    @weakify(self);
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        @strongify(self);
        if (AVAssetExportSessionStatusCompleted == exportSession.status) {
            DLog(@"AVAssetExportSessionStatusCompleted");
            [self writeMusicDataWithUrl:tempMusicPath andWithSubFile:@"Sounds" callback:^(BOOL success, NSString *fileName) {
                DLog(@"%@",fileName);
                NSString *str = [NSHomeDirectory() stringByAppendingString:@"/Library/Sounds"];
                DLog(@"+++%@+++",[self getAllFileByName:str]);
            }];
        } else if (AVAssetExportSessionStatusFailed == exportSession.status) {
            // a failure may happen because of an event out of your control
            // for example, an interruption like a phone call comming in
            // make sure and handle this case appropriately
            DLog(@"AVAssetExportSessionStatusFailed");
        } else {
            DLog(@"Export Session Status: %ld", (long)exportSession.status);
        }
    }];
}

@end
