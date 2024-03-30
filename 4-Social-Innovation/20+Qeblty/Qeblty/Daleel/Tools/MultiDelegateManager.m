//
//  MultiDelegateManager.m
//  BaseDemoOC
//
//  Created by mac on 2022/5/19.
//

#import "MultiDelegateManager.h"

@interface MultiDelegateManager ()

@property (nonatomic,strong) NSMutableArray<MultiDelegateItem *> *delegateItems;

@end

@implementation MultiDelegateManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegateItems = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)addDelegate:(id)delegate {
    if (![self getMultiDelegateItem:delegate]) {
        MultiDelegateItem *item  = [[MultiDelegateItem alloc] init];
        item.delegate = delegate;
        [self.delegateItems addObject:item];
    }
}

- (void)removeDelegate:(id)delegate {
    MultiDelegateItem *item = [self getMultiDelegateItem:delegate];
    if(item) {
        [self.delegateItems removeObject:item];
    }
}

- (void)enumerateDelegate:(void (^)(id _Nonnull))block {
    [self.delegateItems enumerateObjectsUsingBlock:^(MultiDelegateItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(block) {
                block(obj.delegate);
            }
    }];
}

- (void)removeInvalideDelegate:(id)delegate {
    for (int i = 0; i < self.delegateItems.count; i++) {
        MultiDelegateItem *item = self.delegateItems[i];
        if (!item.delegate) {
            [self.delegateItems removeObject:item];
        }
    }
}

- (MultiDelegateItem *)getMultiDelegateItem:(id)delegate {
    for (MultiDelegateItem *item in self.delegateItems) {
        if (item.delegate == delegate) {
            return item;
        }
    }
    return nil;
}

@end


@implementation MultiDelegateItem

@end
