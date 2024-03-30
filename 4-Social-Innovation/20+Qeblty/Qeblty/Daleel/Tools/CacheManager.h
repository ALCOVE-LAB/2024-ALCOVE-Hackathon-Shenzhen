//
//  CacheManager.h
//  Daleel
//
//  Created by mac on 2023/5/10.
//

#import <Foundation/Foundation.h>
/**
 缓存累
 */

NS_ASSUME_NONNULL_BEGIN

@interface CacheManager : NSObject

///取缓存方法
+ (id)getCacheWithKey:(NSString *)cacheKey;
///缓存方法
+ (void)setCacheObject:(id)object forKey:(NSString *)cacheKey;
///删除缓存方法
+ (void)deleteCacheWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
