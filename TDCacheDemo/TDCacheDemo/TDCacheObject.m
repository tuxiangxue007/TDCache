//
//  TDCacheObject.m
//  TDCacheDemo
//
//  Created by DAA on 2018/4/18.
//  Copyright © 2018年 DAA. All rights reserved.
//

#import "TDCacheObject.h"

@implementation TDCacheObject
- (NSDictionary *)getTableInstance{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    path = [path stringByAppendingString:@"/cache.sqlite"];
    
    
    return @{@"tableName":@"cache",@"tablePath":path};
}

@end
