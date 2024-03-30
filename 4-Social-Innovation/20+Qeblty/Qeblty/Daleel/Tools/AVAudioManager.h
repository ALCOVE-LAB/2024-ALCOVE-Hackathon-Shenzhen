//
//  AVAudioManager.h
//  Daleel
//
//  Created by mac on 2022/12/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVAudioManager : NSObject

+ (AVAudioManager *) sharedInstance;

/// 播放声音
- (void)dl_playSoundWithUrl:(NSString *)soundUrl;

/// 暂停播放
- (void)dl_soundPause;

/// 播放
- (void)dl_soundPlay;

/// 停止播放
- (void)dl_soundStop;
@end

NS_ASSUME_NONNULL_END
