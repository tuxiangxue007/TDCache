//
//  NSObject+TDAttribute.m
//  TDCacheFMDB
//
//  Created by DAA on 16/3/24.
//  Copyright © 2016年 DAA. All rights reserved.
//

#import "NSObject+TDAttribute.h"
#import <objc/runtime.h>

@implementation NSObject (TDAttribute)


//返回所有属性名
- (NSArray *)getProperyNameListWhitObj:(id)obj{
    
    NSMutableArray *attributeArr = [NSMutableArray array];
    
    unsigned int outCount;
    objc_property_t *propertys = class_copyPropertyList([obj class], &outCount);
    for (int i = 0; i < outCount; i++) {
        
        const char *char_f = property_getName(propertys[i]);
        NSString *properyName = [NSString stringWithUTF8String:char_f];
        if ([properyName isEqualToString:@"obj"]) {
            break;
        }
        [attributeArr addObject:properyName];
    }
    return attributeArr;
}
- (NSArray *)getProperyAttributerListWhitObj:(id)obj{
    
    NSMutableArray *attributeArr = [NSMutableArray array];
    
    unsigned int outCount;
    objc_property_t *propertys = class_copyPropertyList([obj class], &outCount);
    for (int i = 0; i < outCount; i++) {
        const char *char_f = property_getAttributes(propertys[i]);
        NSString *properyName = [NSString stringWithUTF8String:char_f];
        
        if ([properyName isEqualToString:@"obj"]) {
            break;
        }
        [attributeArr addObject:properyName];
        
        
    }
    return attributeArr;
}
- (NSDictionary *)getProperyValueListWhitObj:(id)obj{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([obj class], &outCount);
    
    for (i = 0; i<outCount; i++)
        
    {
        
        objc_property_t property = properties[i];
        
        const char* char_f =property_getName(property);
        
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        if ([propertyName isEqualToString:@"obj"]) {
            break;
        }
        
        NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
        
        
        [mDic setObject:propertyName forKey:@"propertyName"];
        id propertyValue = [obj valueForKey:propertyName];
        if (propertyValue) [mDic setObject:propertyValue forKey:@"propertyValue"];
        
        const char *charProperty = property_getAttributes(property);
        NSString *propertyType = [NSString stringWithUTF8String:charProperty];
        if (propertyType) {
            [mDic setObject:propertyType forKey:@"propertyName"];
            [mDic setObject:[COMMONLY_ATTBUTE_TYPE objectForKey:[[propertyType componentsSeparatedByString:@","] firstObject]] forKey:@"propertyType"];
        }
        
        
        
        if (mDic) [props setObject:mDic forKey:propertyName];
        
    }
    
    free(properties);
    
    return props;
}

- (NSDictionary *)getSimpleProperyValueListWhitObj:(id)obj{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([obj class], &outCount);
    
    for (i = 0; i<outCount; i++)
        
    {
        
        objc_property_t property = properties[i];
        
        const char* char_f =property_getName(property);
        
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        if ([propertyName isEqualToString:@"obj"]) {
            break;
        }
        
        
        NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
        
        
        [mDic setObject:propertyName forKey:@"propertyName"];
        
        const char *charProperty = property_getAttributes(property);
        NSString *propertyType = [NSString stringWithUTF8String:charProperty];
        if (propertyType) {
            [mDic setObject:propertyType forKey:@"propertyName"];
            [mDic setObject:[COMMONLY_ATTBUTE_TYPE objectForKey:[[propertyType componentsSeparatedByString:@","] firstObject]] forKey:@"propertyType"];
        }
        
        
        
        if (mDic) [props setObject:mDic forKey:propertyName];
        
    }
    
    free(properties);
    
    return props;
}

- (SEL)creatGetWithPropertyName:(NSString *)propertName{
    
    NSString *d = @"az";
    char ca = [d characterAtIndex:0];
    char cz = [d characterAtIndex:1];
    
    char c = [propertName characterAtIndex:0];
    
    if (c >= ca && c <= cz) {
        c -= 32;
    }
    
    propertName = [NSString stringWithFormat:@"get%c%@",c,[propertName substringFromIndex:1]];
    return NSSelectorFromString(propertName);
}


- (SEL)creatSetWithPropertyName:(NSString *)propertName{
    
    NSString *d = @"az";
    char ca = [d characterAtIndex:0];
    char cz = [d characterAtIndex:1];
    
    char c = [propertName characterAtIndex:0];
    
    if (c >= ca && c <= cz) {
        c -= 32;
    }
    
    propertName = [NSString stringWithFormat:@"set%c%@:",c,[propertName substringFromIndex:1]];
    return NSSelectorFromString(propertName);
}

@end
