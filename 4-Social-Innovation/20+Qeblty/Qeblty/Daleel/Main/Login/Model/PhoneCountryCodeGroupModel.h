//
//  CountryModel.h
//  Gamfun
//
//  Created by mac on 2024/3/29.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhoneCountryCodeModel : BaseModel

@property(nonatomic,copy)NSString *nameAr;
@property(nonatomic,copy)NSString *nameEn;
@property(nonatomic,copy)NSString *countryFlags;
@property(nonatomic,copy)NSString *countryCode;
@property(nonatomic,copy)NSString *versionPlatfrom;

@end


@interface PhoneCountryCodeGroupModel : BaseModel

@property(nonatomic,copy)NSString *countrysIndex;
@property(nonatomic,copy)NSArray <PhoneCountryCodeModel *> *countrys;

@end
NS_ASSUME_NONNULL_END
