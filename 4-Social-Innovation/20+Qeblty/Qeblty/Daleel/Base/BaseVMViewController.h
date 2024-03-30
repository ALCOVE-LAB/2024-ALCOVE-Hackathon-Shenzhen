//
//  VCVMForBase.h
//  BaseDemoOC
//
//  Created by mac on 2022/5/19.
//

// MVVM

#import "BaseViewController.h"
#import "BaseVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseVMViewController : BaseViewController <VMMessageDelegate>

/// 绑定VM
-(void)bindVM:(BaseVM *)vm;


@end

NS_ASSUME_NONNULL_END
