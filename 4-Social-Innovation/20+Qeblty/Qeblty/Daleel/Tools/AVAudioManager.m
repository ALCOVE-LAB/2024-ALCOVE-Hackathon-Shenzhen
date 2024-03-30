//
//  AVAudioManager.m
//  Daleel
//
//  Created by mac on 2022/12/21.
//

#import "AVAudioManager.h"
#import <AVFoundation/AVFoundation.h>

static AVAudioManager *avAudioManager;

@interface AVAudioManager ()

@property(nonatomic,strong)AVAudioPlayer *audioplayer;

@end

@implementation AVAudioManager

+ (AVAudioManager *) sharedInstance {
    static dispatch_once_t push_handle_once;
    dispatch_once(&push_handle_once, ^{
        avAudioManager = [[AVAudioManager alloc] init];
    });
    return avAudioManager;
}

- (void)dl_playSoundWithUrl:(NSString *)soundUrl {
    
    /// 先让播放的音乐停止
    [self dl_soundStop];
    
    //1.创建播放器（注意：一个AVAudioPlayer只能播放一个url）
    self.audioplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:soundUrl] error:Nil];
    
    /// 设置静音模式播放声音
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    //2.缓冲
    [self.audioplayer prepareToPlay];
    
    //3.播放
    [self.audioplayer play];
}

- (void)dl_soundPause {
    [self.audioplayer pause];
}

- (void)dl_soundPlay {
    [self.audioplayer play];
}

- (void)dl_soundStop {
    //停止
    //注意：如果点击了stop,那么一定要让播放器重新创建，否则会出现一些莫名其面的问题
    if (self.audioplayer) {
        [self.audioplayer stop];
        self.audioplayer = nil;
    }
    
    ///如果有注册remote得把remote也注销
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

@end
