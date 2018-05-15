//
//  TDOperatorAndModel.h
//  TDCacheFMDB
//
//  Created by DAA on 16/1/26.
//  Copyright © 2016年 DAA. All rights reserved.
//

#import "TDPerformer.h"




@interface TDOperator : TDPerformer{
    NSString *_tablePath;
}
//主键ID
@property (nonatomic) NSInteger ID;
//todo
@property (nonatomic, strong) NSString *todo;


//@property (nonatomic,strong)NSString *name;

/*
 获取TDCacheObject实例
 固定表名和路径 
 表名 todolist
 路径 /Documents/test.sqlite
 */
+ (id)sharedCache;

/*
 获取TDCacheObject实例
 自定义表名和路径
 通过- (NSDictionary *)getTableInstance获取
 例如：@{@"tableName":@"cache",@"tablePath":path};
*/
+ (id)instanceWhithModel:(id)obj;
//返回字段名称
+(NSString *) ID;

//插入单个模型
-(NSInteger)insert;

//插入单个模型
-(NSInteger)insertWithModel:(NSObject *)obj;

//返回所有数据
- (NSArray *)returnAllData;

//根据主键，获取一条记录
-(BOOL)findOneWithPrimaryId:(NSInteger) primaryId;
//根据一对键值查找数据
- (NSArray *)findOneWithValue:(NSString *)value forKey:(NSString *)key;

- (BOOL)deleteIntervalPrimartId:(NSInteger)start end:(NSInteger)end;
- (NSArray *)findIntervalPrimartId:(NSInteger)start end:(NSInteger)end;

//删除数据库
- (BOOL)deleteSql;
@end
