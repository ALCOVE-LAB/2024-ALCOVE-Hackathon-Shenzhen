//
//  UIAlertController+Extension.h
//  Gamfun
//
//  Created by mac on 2022/7/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^UIAlertControllerCompletionBlock) (UIAlertAction *action, NSInteger buttonIndex);

/// 取消按钮
extern NSInteger const UIAlertControllerBlocksCancelButtonIndex;
/// 红色的
extern NSInteger const UIAlertControllerBlocksDestructiveButtonIndex;
/// 其他
extern NSInteger const UIAlertControllerBlocksFirstOtherButtonIndex;

@interface UIAlertController (Extension)

+ (instancetype)showInViewController:(UIViewController *_Nullable)viewController
                           withTitle:(NSString *_Nullable)title
                             message:(NSString *_Nullable)message
                      preferredStyle:(UIAlertControllerStyle)preferredStyle
                   cancelButtonTitle:(NSString *_Nullable)cancelButtonTitle
              destructiveButtonTitle:(NSString *_Nullable)destructiveButtonTitle
                   otherButtonTitles:(NSArray *)otherButtonTitles
                            tapBlock:(UIAlertControllerCompletionBlock)tapBlock;

+ (instancetype)showAlertInViewController:(UIViewController *_Nullable)viewController
                                withTitle:(NSString *_Nullable)title
                                  message:(NSString *_Nullable)message
                        cancelButtonTitle:(NSString *_Nullable)cancelButtonTitle
                   destructiveButtonTitle:(NSString *_Nullable)destructiveButtonTitle
                        otherButtonTitles:(NSArray *)otherButtonTitles
                                 tapBlock:(UIAlertControllerCompletionBlock)tapBlock;


+ (instancetype)showActionSheetInViewController:(UIViewController *_Nullable)viewController
                                      withTitle:(NSString *_Nullable)title
                                        message:(NSString *_Nullable)message
                              cancelButtonTitle:(NSString *_Nullable)cancelButtonTitle
                         destructiveButtonTitle:(NSString *_Nullable)destructiveButtonTitle
                              otherButtonTitles:(NSArray *)otherButtonTitles
                                       tapBlock:(UIAlertControllerCompletionBlock)tapBlock;

@end

NS_ASSUME_NONNULL_END
