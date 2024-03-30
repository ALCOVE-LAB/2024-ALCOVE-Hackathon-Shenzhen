//
//  UIAlertController+Extension.m
//  Gamfun
//
//  Created by mac on 2022/7/18.
//

#import "UIAlertController+Extension.h"

NSInteger const UIAlertControllerBlocksCancelButtonIndex = 0;
NSInteger const UIAlertControllerBlocksDestructiveButtonIndex = 1;
NSInteger const UIAlertControllerBlocksFirstOtherButtonIndex = 2;


@implementation UIAlertController (Extension)

+ (instancetype)showInViewController:(UIViewController *_Nullable)viewController withTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message preferredStyle:(UIAlertControllerStyle)preferredStyle cancelButtonTitle:(NSString *_Nullable)cancelButtonTitle destructiveButtonTitle:(NSString *_Nullable)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles tapBlock:(UIAlertControllerCompletionBlock)tapBlock {
    UIAlertController *controller = [self alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    if (preferredStyle == UIAlertControllerStyleActionSheet) {
        UIView *subView = controller.view.subviews.firstObject;
        UIView *v = subView.subviews.firstObject;
        UIView *v1 = v.subviews.firstObject;
        v1.backgroundColor = kWhiteColor;
    }
    if (title.length > 0) {
        NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:title];
        [alertControllerStr addAttribute:NSForegroundColorAttributeName value:RGB(0x1B1B1B) range:NSMakeRange(0, title.length)];
        [alertControllerStr addAttribute:NSFontAttributeName value:kFontRegular(18) range:NSMakeRange(0, title.length)];
        [controller setValue:alertControllerStr forKey:@"attributedTitle"];
    }
    
    if (cancelButtonTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            if (tapBlock) {
                tapBlock(action, UIAlertControllerBlocksCancelButtonIndex);
            }
        }];
        [controller addAction:cancelAction];
    }
    
    if (destructiveButtonTitle) {
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
            if (tapBlock) {
                tapBlock(action, UIAlertControllerBlocksDestructiveButtonIndex);
            }
        }];
        [controller addAction:destructiveAction];
    }
    
    for (NSUInteger i = 0; i < otherButtonTitles.count; i++) {
        NSString *otherButtonTitle = otherButtonTitles[i];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            if (tapBlock) {
                tapBlock(action, UIAlertControllerBlocksFirstOtherButtonIndex + i);
            }
        }];
        [controller addAction:otherAction];
    }
    
    if (!viewController) {
        viewController = [UIViewController rootViewController];
    }
    if (controller.popoverPresentationController != nil) {
        if (IS_IPAD && preferredStyle == UIAlertControllerStyleActionSheet) {
            controller.popoverPresentationController.sourceView = viewController.view;
            controller.popoverPresentationController.sourceRect = viewController.view.bounds;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [viewController.uacb_topmost presentViewController:controller animated:YES completion:nil];
    });
    
    return controller;
}

+ (instancetype)showAlertInViewController:(UIViewController *_Nullable)viewController withTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message cancelButtonTitle:(NSString *_Nullable)cancelButtonTitle destructiveButtonTitle:(NSString *_Nullable)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles tapBlock:(UIAlertControllerCompletionBlock)tapBlock {
    return [self showInViewController:viewController withTitle:title message:message preferredStyle:UIAlertControllerStyleAlert cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles tapBlock:tapBlock];
}

+ (instancetype)showActionSheetInViewController:(UIViewController *_Nullable)viewController withTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message cancelButtonTitle:(NSString *_Nullable)cancelButtonTitle destructiveButtonTitle:(NSString *_Nullable)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles tapBlock:(UIAlertControllerCompletionBlock)tapBlock {
    return [self showInViewController:viewController
                            withTitle:title
                              message:message
                       preferredStyle:UIAlertControllerStyleActionSheet
                    cancelButtonTitle:cancelButtonTitle
               destructiveButtonTitle:destructiveButtonTitle
                    otherButtonTitles:otherButtonTitles
                             tapBlock:tapBlock];
}

@end
