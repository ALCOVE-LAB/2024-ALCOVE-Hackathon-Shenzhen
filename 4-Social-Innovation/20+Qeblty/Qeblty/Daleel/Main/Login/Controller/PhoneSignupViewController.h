//
//  PhoneSignupViewController.h
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "BaseVMViewController.h"
#import "LoginVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhoneSignupViewController : BaseVMViewController

@property (nonatomic,strong) NSString *phoneNum;
@property (nonatomic,strong) NSString *phoneCountryCode;
@property (nonatomic,strong) LoginVM *vm;

@end

NS_ASSUME_NONNULL_END
