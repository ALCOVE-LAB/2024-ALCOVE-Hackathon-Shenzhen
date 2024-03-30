//
//  TimerTaskManager.h
//  Daleel
//
//  Created by mac on 2022/11/26.
//

/**
 定时器中心化管理
 适用范围  正计数  倒计数   暂停/继续任务   开始任/结束任务
 精度 0.1 s  要求更高的精度此管理器不适用
 虽然是单例  任务不存在 自动销毁
 子线程执行不受主线程卡顿影响
 */

#import <Foundation/Foundation.h>

@interface TimerTask : NSObject

///  初始化task
/// - Parameters:
///   - taskId: 任务id  可以nil  内部自动生成
///   - startTime:  任务计时起始 eg:10
///   - endTime: 任务计时结束 eg:40
///   - interval: 任务计时间隔  eg: 1升序  / -1 降序
///   - handle: 处理执行任务的回调
- (instancetype)initWithTaskId:(NSString *)taskId StartTime:(float)startTime endTime:(float)endTime timerInterval:(float)interval handleBlock:(void(^)(NSString *taskId, float currentTime))handler;

/// 任务id
@property (nonatomic,strong,readonly) NSString *taskId;

/// 任务回调
@property (nonatomic,copy) void(^handler)(NSString *taskId, float currentTime);

/// 任务重要程度 normal  程序退出了就不存在了  程序退出了在进来 之前没执行完的任务继续执行
//@property (nonatomic,assign) NSInteger taskPriority;

@end



@interface TimerTaskManager : NSObject

+ (instancetype)sharedInstance;

/// 添加并开始任务 （存在同名的任务则删除之前的任务 开始新的任务）
- (void)runTimeTask:(TimerTask *)task;

/// 移除任务
- (void)stopTask:(TimerTask *)task;

/// 通过taskId 获取任务
- (TimerTask *)getTimerTaskWithTaskId:(NSString *)taskId;

//- (void)pauseTimeTask:(TimerTask *)task;
//
//- (void)resumeTask:(TimerTask *)task;

@end
