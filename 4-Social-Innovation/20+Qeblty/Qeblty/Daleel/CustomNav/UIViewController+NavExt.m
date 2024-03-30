//
//  UIViewController+NavExt.m
//  NavThings
//
//  Created by mac on 2023/5/30.
//

#import "UIViewController+NavExt.h"
#import <objc/runtime.h>

@implementation UIViewController (NavExt)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL orgSel = @selector(viewDidAppear:);
        SEL hookSel = @selector(hook_viewDidAppear:);
        Method orgMe = class_getInstanceMethod(class, orgSel);
        Method hookMe = class_getInstanceMethod(class, hookSel);
        BOOL isAdded = class_addMethod(class, orgSel, method_getImplementation(hookMe), method_getTypeEncoding(hookMe));
        if (isAdded) {
            class_replaceMethod(class, hookSel, method_getImplementation(orgMe), method_getTypeEncoding(orgMe));
        } else {
            method_exchangeImplementations(orgMe, hookMe);
        }
    });
}

- (void)hook_viewDidAppear:(BOOL)animated {
    /// 移除nav自带的返回按钮title
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithTitle:@""
                                                  style:UIBarButtonItemStylePlain
                                                  target:self
                                                  action:nil];
    [self hook_viewDidAppear:animated];
}

@end
