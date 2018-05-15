//
//  NSObject＋TDKeyValue.h
//  TDCacheFMDB
//
//  Created by DAA on 16/3/24.
//  Copyright © 2016年 DAA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(TDKeyValue)


/*
 传进一个数组，可以返回一个包含指定模型类的数组
 
 */

+ (NSArray *)modelsWithList:(NSArray *)list;


/*
 通过nsdictiongary 给model赋值
 */
- (void) setAttributes:(NSDictionary *)dataDic;
@end
