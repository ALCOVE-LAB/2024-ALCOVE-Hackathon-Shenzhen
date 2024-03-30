//
//  NSDictionary+Extension.h
//  Gamfun
//
//  Created by mac on 2022/6/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Extension)

//将Json字符串转化为字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSDictionary *)dictionaryForJsonData:(NSData *)jsonData;

@end

NS_ASSUME_NONNULL_END
