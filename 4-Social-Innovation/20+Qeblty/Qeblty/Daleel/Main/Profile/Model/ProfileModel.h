//
//  ProfileModel.h
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileModel : NSObject

@property (nonatomic,strong)NSArray *cellArr;

@end

@interface SettingModel : BaseModel

@property (nonatomic,strong)NSArray *sectionOneArr;
@property (nonatomic,strong)NSArray *sectionTwoArr;
@property (nonatomic,strong)NSArray *sectionThreeArr;
@property (nonatomic,strong)NSArray *sectionFourArr;
@property (nonatomic,strong)NSArray *headerArr;
@property(nonatomic,strong)NSMutableArray *settingArr;

@end


NS_ASSUME_NONNULL_END
