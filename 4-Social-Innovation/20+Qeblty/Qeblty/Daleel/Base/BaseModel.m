//
//  BaseModel.m
//  Daleel
//
//  Created by mac on 2022/11/28.
//

#import "BaseModel.h"

@implementation BaseModel

- (void)encodeWithCoder:(NSCoder *)encoder {
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(propertyList[i])];
        [encoder encodeObject:[self valueForKey:key] forKey:key];
    }
    Class superClass = [[[[self class] alloc] superclass] class];
    do {
        if (superClass) {
            propertyList = class_copyPropertyList(superClass, &count);
            for (unsigned int i = 0; i < count; i++) {
                NSString *key = [NSString stringWithUTF8String:property_getName(propertyList[i])];
                [encoder encodeObject:[self valueForKey:key] forKey:key];
            }
        }
        superClass = [[[superClass alloc] superclass] class];
    } while (superClass && superClass != [NSObject class]);
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) {
        [self setValuesWithDecoder:decoder];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    id newModel = [[[self class] allocWithZone:zone] init];
    [newModel setValuesWithDecoder:nil];
    
    return newModel;
}

- (void)setValuesWithDecoder:(NSCoder *)decoder {
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(propertyList[i])];
        if ([BaseModel isPropertyReadOnly:[self class] propertyName:key]) {
            continue;
        }
        id value = decoder ? [decoder decodeObjectForKey:key] : [self valueForKey:key];
        if (value != [NSNull null] && value != nil) {
            [self setValue:value forKey:key];
        }
    }
    Class superClass = [[[[self class] alloc] superclass] class];
    do {
        if (superClass) {
            propertyList = class_copyPropertyList(superClass, &count);
            for (unsigned int i = 0; i < count; i++) {
                NSString *key = [NSString stringWithUTF8String:property_getName(propertyList[i])];
                if ([superClass isPropertyReadOnly:[self class] propertyName:key]) {
                    continue;
                }
                id value = decoder ? [decoder decodeObjectForKey:key] : [self valueForKey:key];
                if (value != [NSNull null] && value != nil) {
                    [self setValue:value forKey:key];
                }
            }
        }
        superClass = [[[superClass alloc] superclass] class];
    } while (superClass && superClass != [NSObject class]);
}

+ (BOOL)isPropertyReadOnly:(Class)klass propertyName:(NSString*)propertyName {
    const char *type = property_getAttributes(class_getProperty(klass, [propertyName UTF8String]));
    NSString *typeString = [NSString stringWithUTF8String:type];
    NSArray *attributes = [typeString componentsSeparatedByString:@","];
    NSString *typeAttribute = [attributes objectAtIndex:1];
    return [typeAttribute rangeOfString:@"R"].length > 0;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    DLog(@"Class: %@  UndefinedKey: %@", [self class], key );
}

@end
