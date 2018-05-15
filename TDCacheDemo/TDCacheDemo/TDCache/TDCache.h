//
//  TDCache.h
//  TDCacheDemo
//
//  Created by DAA on 2018/5/10.
//  Copyright © 2018年 DAA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+TDAttribute.h"
#import "NSObject＋TDKeyValue.h"
#import <objc/runtime.h>
#import "TDOperator.h"


/*
 分别对应 int string float bool 类型
 目前仅支持这4种常用类型
 */
#define FMDB_DATA_TYPE @{@"1":@"INTEGER",@"2":@"TEXT",@"3":@"FLOAT",@"4":@"BOOLEAN"}

/*
 分别对应 int string float bool 类型
 目前仅支持这4种常用类型
 如需支持更多类型，可以自行添加(需与上面的字典对应)
 */
#define COMMONLY_ATTBUTE_TYPE @{@"Ti":@"1",@"Tq":@"1",@"T@\"NSString\"":@"2",@"Tf":@"3",@"TB":@"4"}


#ifdef DEBUG
#define NSLog(format, ...) printf("[%s] %s [%d] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif
@interface TDCache : NSObject

@end
