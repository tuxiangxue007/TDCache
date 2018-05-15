//
//  NSObject+TDAttribute.h
//  TDCacheFMDB
//
//  Created by DAA on 16/3/24.
//  Copyright © 2016年 DAA. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSObject (TDAttribute)

//返回所有属性名
- (NSArray *)getProperyNameListWhitObj:(id)obj;
//返回所有属性类型
- (NSArray *)getProperyAttributerListWhitObj:(id)obj;


//不包含属性值的属性字典propertyName = ( propertyName propertyType)
- (NSDictionary *)getSimpleProperyValueListWhitObj:(id)obj;


//包含属性值的属性字典propertyName = (propertyValue propertyName propertyType)
- (NSDictionary *)getProperyValueListWhitObj:(id)obj;

//传入属性名生产get方法
- (SEL)creatGetWithPropertyName:(NSString *)propertName;

//传入属性名生产set方法
- (SEL)creatSetWithPropertyName:(NSString *)propertName;
@end
