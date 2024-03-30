//
//  CacheManager.m
//  Daleel
//
//  Created by mac on 2023/5/10.
//

#import "CacheManager.h"

@implementation CacheManager
/// 存方法
+ (void)setCacheObject:(id)object forKey:(NSString *)cacheKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [defaults setObject:data forKey:cacheKey];
    [defaults synchronize];
}

/// 取方法
+ (id)getCacheWithKey:(NSString *)cacheKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:cacheKey];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

/// 删除
+ (void)deleteCacheWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}
@end
