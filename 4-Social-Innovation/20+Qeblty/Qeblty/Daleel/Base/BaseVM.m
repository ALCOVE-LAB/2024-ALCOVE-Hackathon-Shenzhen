//
//  BaseVM.m
//  BaseDemoOC
//
//  Created by mac on 2022/5/19.
//

#import "BaseVM.h"
#import "MultiDelegateManager.h"

@interface BaseVM ()

@property (nonatomic,strong) MultiDelegateManager *delegateManager;

@end

@implementation BaseVM

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegateManager = [[MultiDelegateManager alloc] init];
    }
    return self;
}

- (void)addVMMessageReceiver:(id<VMMessageDelegate>)receiver {
    [self.delegateManager addDelegate:receiver];
}

- (void)removeVMMessageReceiver:(id<VMMessageDelegate>)receiver {
    [self.delegateManager removeDelegate:receiver];
}

- (void)sendVMMessage:(NSString *)messageId data:(id)data {
    [self.delegateManager enumerateDelegate:^(id  _Nonnull delegate) {
        if (delegate) {
            [delegate vmMessage:messageId data:data];
        }
    }];
}

@end
