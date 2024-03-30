//
//  TimerTaskManager.m
//  Daleel
//
//  Created by mac on 2022/11/26.
//

#import "TimerTaskManager.h"

@interface TimerTask ()

@property (nonatomic,assign) float startTime;
@property (nonatomic,assign) float curentTime;
@property (nonatomic,assign) float endTime;
@property (nonatomic,assign) float interval;
@property (nonatomic,assign) BOOL isNeedRelease;

@end

@implementation TimerTask

- (instancetype)initWithTaskId:(NSString *)taskId StartTime:(float)startTime endTime:(float)endTime timerInterval:(float)interval handleBlock:(void (^)(NSString *taskId, float currentTime))handler {
    self = [super init];
    if (self) {
        _taskId = taskId;
        _startTime = _curentTime = startTime;
        _endTime = endTime;
        _interval = interval;
        _handler = handler;
    }
    return self;
}

- (void)updateTimer {
    _curentTime += _interval;
    if(_interval > 0) {
        // 增
        if(_curentTime >= _startTime && _curentTime <= _endTime) {
            if(self.handler){ self.handler(_taskId,_curentTime);}
        }else {
            self.isNeedRelease = YES;
        }
    }else if(_interval < 0) {
        // 减
        if(_curentTime <= _startTime && _curentTime >= _endTime) {
            if(self.handler){ self.handler(_taskId,_curentTime);}
        }else {
            self.isNeedRelease = YES;
        }
    }
}

- (void)dealloc {
    DLog(@"TimerTask - dealloc")
}

@end



@interface TimerTaskManager ()

@property (nonatomic,strong) NSMutableArray <TimerTask *> *tasks;
@property (nonatomic,strong) NSThread *timerThread;
@property (nonatomic,assign) BOOL isStopedTimerThread; // 控制是否关闭线程
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) float currentTimeIndex;

@end

static TimerTaskManager *instance = nil;
static dispatch_once_t onceToken;

@implementation TimerTaskManager

+ (instancetype)sharedInstance {
    if (!instance) {
        instance = [[self alloc] init];
        instance.tasks = [NSMutableArray arrayWithCapacity:0];
    }
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (id)copy {
    NSLog(@"这是一个单例对象，copy将不起任何作用");
    return self;
}

- (id)copyWithZone:(struct _NSZone *)zone {
 return self;
}

- (id)mutableCopyWithZone:(struct _NSZone *)zone {
 return self;
}

- (void)invalidateInstance {
    onceToken = 0;
    instance = nil;
    [self performSelector:@selector(terminateLoop) onThread:_timerThread withObject:nil waitUntilDone:YES]; // 退出线程
    _timerThread = nil;
    [_timer invalidate]; //销毁timer
    _timer = nil;
}

- (void)dealloc {
    DLog(@"TimerTaskManager - dealloc");
}

#pragma mark - 创建定时器子线程 并保活
- (void)creatTimerThread { // 线程
    if(!_timerThread) {
        DLog(@"创建Timer子线程");
        __weak typeof(self) weakSelf = self;

        NSThread *timerThread = [[NSThread alloc] initWithBlock:^{
            DLog(@"开启线程保活")
            NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
            [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
            // [runLoop run]; //想要线程可以控制 则不要使用run
            while (!weakSelf.isStopedTimerThread) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            DLog(@"结束线程保活");
        }];
        timerThread.name = @"TimerTaskManagerCenterTimerTread";
        _timerThread = timerThread;
        DLog(@"开启Timer子线程");
        [timerThread start];
    }
}

/// 关闭线程
- (void)terminateLoop {
    self.isStopedTimerThread = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());   // 退出当前runloop
}

/// 添加timer 到子线程
- (void)startTimerOnTimerThread {
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)creatTimerAndStart { // 开始timer
    if(!_timer){
        [self performSelector:@selector(startTimerOnTimerThread) onThread:_timerThread withObject:nil waitUntilDone:NO];
    }
}


- (void)timerRun {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.currentTimeIndex += 0.1;
        if(self.tasks.count == 0) {[self invalidateInstance];}
        
        NSArray *temArr = self.tasks.mutableCopy;
        for (int i = 0; i < temArr.count; i++) {
            TimerTask *t = temArr[i];
            if ((int)(self.currentTimeIndex * 10) % (int)(t.interval * 10) == 0) {
                if(t.isNeedRelease){
                    [self.tasks removeObject:t];
                }else {
                    [t updateTimer];
                }
            }
        }
    });
}

- (void)runTimeTask:(TimerTask *)task {
    NSArray *temArr = self.tasks.mutableCopy;
    for (int i = 0; i < temArr.count; i++) {
        TimerTask *t = temArr[i];
        if(task.taskId != nil && ![task.taskId isEqualToString:@""] && [t.taskId isEqualToString:task.taskId] && t.interval != 0) {
            // 移除同名的task
            DLog(@"TimerTaskMamager - 存在相同的taskId的任务 已经移除已经存在的相同的任务")
            [self.tasks removeObject:t];
        }
    }
    [self.tasks addObject:task];
    
    // 开启timer线程
    [self creatTimerThread];
    // 开启timer
    [self creatTimerAndStart];
}

- (void)stopTask:(TimerTask *)task {
    [self.tasks removeObject:task];
}

- (TimerTask *)getTimerTaskWithTaskId:(NSString *)taskId {
    for (TimerTask *t in self.tasks) {
        if(t.taskId != nil && ![t.taskId isEqualToString:@""] && [t.taskId isEqualToString:taskId]) {
            return t;
        }
    }
    return nil;
}


- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    }
    return _timer;
}

@end
