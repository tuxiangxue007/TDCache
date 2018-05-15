//
//  TDPerformer.m
//  TDCacheFMDB
//
//  Created by DAA on 16/1/26.
//  Copyright © 2016年 DAA. All rights reserved.
//

#import "TDPerformer.h"


@implementation TDPerformer

//初始化
-(id) initWithFMDB:(FMDatabase *)database{
    self = [super init];
    if(self){
        self.primaryId = NSNotFound;
        self.primaryField = @"id";
        self.database = database;
    }
    return self;
}
#pragma mark 类方法
//获取字符串，如果是nil，则返回一个空字符串
+(NSString *) getString: (NSString *) text{
    return text == nil ? @"" : text;
}

#pragma mark - 增

//插入数据，并返回最后插入的ID
-(NSInteger) insertWithSql:(NSString *)sql parameters:(NSArray *)params
{
    NSInteger lastId = -1;
    [self.database open];
    if([self.database executeUpdate:sql withArgumentsInArray:params]){
        lastId = [self.database lastInsertRowId];
    }
    [self.database close];
    return lastId;
}

#pragma mark - 删
//根据主键删除
-(BOOL) deleteWithPrimary:(NSInteger)primaryId
{
    NSString *condition = [NSString stringWithFormat: @" %@ = %ld", self.primaryField, primaryId];
    return [self deleteWithCondition:condition parameters:nil];
}

//根据一对键值删除
-(BOOL) deleteOneWithValue:(NSString *)value forKey:(NSString *)key
{
    NSString *condition = [NSString stringWithFormat: @" %@ = '%@'", key, value];
    return [self deleteWithCondition:condition parameters:nil];
}

//根据条件删除某个表的数据
-(BOOL) deleteWithCondition:(NSString *)cond parameters:(NSArray *)params
{
    
    NSString *sql = [NSString stringWithFormat: @"DELETE FROM %@ WHERE %@",
                     self.tableName,
                     [TDPerformer getString: cond]];
    //    sql = [NSString stringWithFormat: @"DELETE FROM %@ WHERE %@",
    //           self.tableName,
    //           cond];
    [self.database open];// withArgumentsInArray:params
    BOOL result = [self.database executeUpdate:sql];
    //    NSLog(@"%@",@"DELETE FROM todolist WHERE todo = Todo 1");
    //    BOOL result = [self.database executeUpdate:@"DELETE FROM todolist WHERE todo = ?",@"Todo 1"];
    [self.database close];
    return result;
}

#pragma mark - 查


//根据Sql搜索，并返回结果集
-(NSArray *) findWithSql:(NSString *)sql{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [self.database open];
    FMResultSet *rs = [self.database executeQuery:sql withArgumentsInArray:nil];
    while ([rs next]) {
        [result addObject: [rs resultDictionary]];
    };
    [rs close];
    [self.database close];
    return [NSArray arrayWithArray: result];
}

//获取当前表的所有数据
-(NSArray *) findAllWithOrderBy: (NSString *) orderBy{
    return [self findAllWithOrderBy:orderBy startIndex:0 endIndex:NSIntegerMax];
}

//根据条件查询，可以进行分页
-(NSArray *) findWithCondition: (NSString *) cond parameters:(NSArray *)params orderBy:(NSString *)orderBy startIndex: (NSInteger) start endIndex: (NSInteger) end{
    NSString *fields = [self.fields componentsJoinedByString: @","];
    NSString *sql = [NSString stringWithFormat:
                     @"SELECT %@ FROM %@ WHERE 1 = 1 %@ %@",
                     fields,
                     self.tableName,
                     [TDPerformer getString: cond],
                     [TDPerformer getString: orderBy]];
    return [self findWithSql:sql parameters:params startIndex:start endIndex:end];
}



//查询所有数据，并可以分页
-(NSArray *) findAllWithOrderBy: (NSString *) orderBy startIndex: (NSInteger) start endIndex: (NSInteger) end{
    return [self findWithCondition:nil parameters:nil orderBy:orderBy startIndex:start endIndex:end];
}

//根据Sql搜索，并返回结果集
-(NSArray *) findWithSql:(NSString *)sql parameters:(NSArray *)params{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [self.database open];
    FMResultSet *rs = [self.database executeQuery:sql withArgumentsInArray:params];
    while ([rs next]) {
        [result addObject: [rs resultDictionary]];
    };
    [rs close];
    [self.database close];
    return [NSArray arrayWithArray: result];
}

//根据sql查询数据，并可以设置起止范围
-(NSArray *) findWithSql: (NSString *) sql parameters:(NSArray *)params startIndex: (NSInteger) start endIndex: (NSInteger) end{
    sql = [sql stringByAppendingFormat:@" LIMIT %ld, %ld", start, end];
    return [self findWithSql:sql parameters:params];
}
#pragma mark
//插入或者更新数据，根据ID来判断
-(BOOL) save{
    //插入
    if (self.primaryId == NSNotFound) {
        return [self insert] != NSNotFound;
    };
    
    //更新
    return [self update];
}

//插入当前实例，并返回最后插入的ID
-(BOOL) update{
    NSLog(@"子类必需实现此方法");
    return NO;
}

//更新数据
-(NSInteger) insert{
    NSLog(@"子类必需实现此方法");
    return NSNotFound;
}


//获取一条记录
-(BOOL) findOneWithCondition:(NSString *)cond parameters:(NSArray *)params orderBy:(NSString *)orderBy
{
    NSString *fields = [self.fields componentsJoinedByString:@","];
    NSString *sql = [NSString stringWithFormat:
                     @"SELECT %@ FROM %@ WHERE 1 = 1 %@ %@ LIMIT 1",
                     fields,
                     self.tableName,
                     [TDPerformer getString: cond],
                     [TDPerformer getString: orderBy]];
    
    //sql = [sql stringByAppendingString: cond];
    //if(orderBy != nil) sql = [sql stringByAppendingFormat:@" ORDER BY %@", sort];
    //sql = [sql stringByAppendingString: @" LIMIT 1"];
    
    FMResultSet *rs = [self.database executeQuery:sql withArgumentsInArray: params];
    self.data = rs.resultDictionary;
    [rs close];
    [self.database close];
    return self.data != nil;
}
@end
