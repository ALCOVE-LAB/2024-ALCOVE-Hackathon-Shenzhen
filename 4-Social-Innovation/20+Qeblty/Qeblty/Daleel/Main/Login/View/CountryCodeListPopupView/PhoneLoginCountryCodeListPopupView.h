//
//  PhoneLoginCountryCodeListPopupView.h
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "BasePopupView.h"
#import "PhoneCountryCodeGroupModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhoneLoginCountryCodeListPopupView : BasePopupView

- (void)setCountryCodeListData:(NSArray <PhoneCountryCodeGroupModel *>*)data;

@property (nonatomic,copy) void(^selectCountryCode)(PhoneCountryCodeModel *codeModel);

@end

NS_ASSUME_NONNULL_END
