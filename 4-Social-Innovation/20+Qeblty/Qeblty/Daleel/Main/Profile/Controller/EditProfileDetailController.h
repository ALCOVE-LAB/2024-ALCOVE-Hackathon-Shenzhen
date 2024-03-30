//
//  EditProfileDetailController.h
//  Daleel
//
//  Created by mac on 2024/3/31.
//

#import "BaseViewController.h"

typedef enum{
    kEditName,
    kEditIntroduce
}EditProfileType;

NS_ASSUME_NONNULL_BEGIN

@interface EditProfileDetailController : BaseViewController

@property(nonatomic,assign)EditProfileType type;

@end

NS_ASSUME_NONNULL_END
