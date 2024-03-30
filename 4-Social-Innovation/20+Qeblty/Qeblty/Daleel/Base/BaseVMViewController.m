//
//  VCVMForBase.m
//  BaseDemoOC
//
//  Created by mac on 2022/5/19.
//

#import "BaseVMViewController.h"

@interface BaseVMViewController ()

@end

@implementation BaseVMViewController

#pragma mark - mvvm 相关

-(void)bindVM:(BaseVM *)vm {
    [vm addVMMessageReceiver:self];
}

- (void)vmMessage:(NSString *)messageId data:(id)data {
    
}

@end
