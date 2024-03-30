//
//  ProfileModel.m
//  Daleel
//
//  Created by mac on 2024/3/29.
//

#import "ProfileModel.h"

@implementation ProfileModel

- (NSArray *)cellArr {
    if (!_cellArr) {
        _cellArr = @[kLocalize(@"favorite"),kLocalize(@"notes"),kLocalize(@"highlights")];
    }
    return _cellArr;
}

@end

@implementation SettingModel

- (NSMutableArray *)settingArr {
    if (!_settingArr) {
        _settingArr = [NSMutableArray array];
        [_settingArr addObjectsFromArray:@[@{@"title":kLocalize(@"edit_profile"),@"image":@"profile_setting_editProfile"},
         @{@"title":kLocalize(@"account_and_security"),@"image":@"profile_setting_security"},
                                           @{@"title":kLocalize(@"feature_prayer"), @"image":@"profile_setting_prayer"},
                                           @{@"title":kLocalize(@"language"), @"image":@"profile_setting_language"},
                                           @{@"title":kLocalize(@"clear_cache") , @"image":@"profile_setting_clearCache"},
                                           @{@"title":kLocalize(@"about_daleel"), @"image":@"profile_setting_about"}]];
    }
    return _settingArr;
}

- (NSArray *)sectionFourArr {
    if(!_sectionFourArr){
        _sectionFourArr = @[@{
            @"title":@[kLocalize(@"sign_out")]},@{@"image":@[@"profile_setting_signOut"]}];
    }
    return _sectionFourArr;
}

- (NSArray *)headerArr {
    if(!_headerArr){
        _headerArr = @[kLocalize(@"account"),kLocalize(@"feature"),kLocalize(@"general"),@""];
    }
    return _headerArr;
}

@end
