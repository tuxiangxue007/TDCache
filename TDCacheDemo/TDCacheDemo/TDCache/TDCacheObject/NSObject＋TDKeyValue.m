//
//  NSObject＋TDKeyValue.m
//  TDCacheFMDB
//
//  Created by DAA on 16/3/24.
//  Copyright © 2016年 DAA. All rights reserved.
//

#import "NSObject＋TDKeyValue.h"
#import <objc/runtime.h>

@implementation NSObject(TDKeyValue)


- (NSDictionary *)objectClassInArray{
    return @{};
}



- (void)setAttributes:(NSDictionary *)dataDic obj:(id)object{
    NSDictionary *objectClassInDict =  (NSDictionary *)[object performSelector:NSSelectorFromString(@"objectClassInArray") withObject:nil];
    
    unsigned int outCount;
    objc_property_t *propertys = class_copyPropertyList([object class], &outCount);
    
    for (int i = 0; i < outCount; i++) {
        
        const char *char_f = property_getName(propertys[i]);
        NSString *properyName = [NSString stringWithUTF8String:char_f];
        
        objc_property_t property = propertys[i];
        const char *charProperty = property_getAttributes(property);
        NSString *propertyType = [NSString stringWithUTF8String:charProperty];
        
        
        
        if ([propertyType rangeOfString:@"NSString"].location != NSNotFound) {//设置字符串的默认值
            SEL setSel = [self creatSetWithPropertyName:properyName];
            [object performSelectorOnMainThread:setSel withObject:@"" waitUntilDone:YES];
            
        }
        
        
        [dataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:properyName] || [[NSString stringWithFormat:@"%@_mStr",key]isEqualToString:properyName]) {
                if ([[dataDic objectForKey:key] isKindOfClass:[NSDictionary class]]||[[dataDic objectForKey:key]isKindOfClass:[NSArray class]]) {
                    
                    if ([[dataDic objectForKey:key]isKindOfClass:[NSArray class]]){
                        
                        NSMutableArray *arr = [NSMutableArray array];
                        NSMutableArray *dataArr = [dataDic objectForKey:key];
                        NSString *classNameStr = [objectClassInDict objectForKey:key];
                        for (int i = 0 ; i < dataArr.count; i ++) {
                            
                            id objc = [[NSClassFromString(classNameStr) alloc]init];
                            if (!objc) {
                                break;
                            }
                            [arr addObject:objc];
                        }
                        
                        for (int i = 0; i < outCount; i++) {
                            
                            const char *char_f = property_getName(propertys[i]);
                            NSString *properyName = [NSString stringWithUTF8String:char_f];
                            
                            
                            if ([key isEqualToString:properyName]) {
                                
                                [object setValue:arr forKey:properyName];
                                [self dealWithObjArr:arr DataArr:dataArr];
                                
                                break;
                            }
                        }
                        
                        
                        
                    }else if ([[dataDic objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                        
                        id objc = [[NSClassFromString(key) alloc]init];
                        
                        
                        for (int i = 0; i < outCount; i++) {
                            
                            const char *char_f = property_getName(propertys[i]);
                            NSString *properyName = [NSString stringWithUTF8String:char_f];
                            
                            
                            if ([key isEqualToString:properyName]) {
                                
                                [object setValue:objc forKey:properyName];
                                [self setAttributes:[dataDic objectForKey:key] obj:objc];
                                
                                break;
                            }
                        }
                        
                        [object setValue:objc forKey:properyName];
                        [self setAttributes:[dataDic objectForKey:key] obj:objc];
                    }
                }else{
                    if ([dataDic objectForKey:key]) {
                        [object setValue:[dataDic objectForKey:key] forKey:properyName];
                        
                    }
                    
                    
                }
            }
            if ([properyName isEqualToString:@"ID"] && [key isEqualToString:@"id"]) {
                [object setValue:[dataDic objectForKey:key] forKey:properyName];
            }
            
        }];
    }
}
- (void)dealWithObjArr:(NSArray *)objs DataArr:(NSArray *)dataArr{
    
    for (int num = 0; num < objs.count; num ++) {
        id obj = [objs objectAtIndex:num];
        NSDictionary *dataDict = [dataArr objectAtIndex:num];
        [self setAttributes:dataDict obj:obj];
    }
}
+ (NSArray *)modelsWithList:(NSArray *)list{
    NSMutableArray *models = [NSMutableArray array];
    
    for (NSDictionary *infoDic in list) {
        id obj = [[[self class]alloc]init];
        [obj setAttributes:infoDic obj:obj];
        [models addObject:obj];
    }
    
    return models;
}
- (void) setAttributes:(NSDictionary *)dataDic{
    [self setAttributes:dataDic obj:self];
}
@end
