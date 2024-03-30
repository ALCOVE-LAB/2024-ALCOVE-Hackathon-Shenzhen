//
//  GuideViewSubView.h
//  Daleel
//
//  Created by mac on 2024/3/31.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GuideViewSubView : BaseView

- (instancetype)initWithTopLabelText:(NSString *)topText andWithSecondText:(NSString *)secondText andWithLimitImg:(NSString *)limitImg andWithLimitDiscribe:(NSString *)limitDiscribe andWithSwitchTag:(NSInteger )pageNum;

@end

NS_ASSUME_NONNULL_END
