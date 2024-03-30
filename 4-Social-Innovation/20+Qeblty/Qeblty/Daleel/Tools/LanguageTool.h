//
//  LanguageTool.h
//  Daleel
//
//  Created by mac on 2022/11/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LanguageTool : NSObject

+ (NSString *)currentLanguageName;

+ (BOOL)isArabic;

@end

NS_ASSUME_NONNULL_END
