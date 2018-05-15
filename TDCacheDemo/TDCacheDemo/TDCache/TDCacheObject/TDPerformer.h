//
//  TDPerformer.h
//  TDCacheFMDB
//
//  Created by DAA on 16/1/26.
//  Copyright © 2016年 DAA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"


@interface TDPerformer : NSObject

@property (nonatomic, strong) FMDatabase *database;
//查询出来的一条数据
@property (nonatomic, strong) NSDictionary *data;
//表名
@property(nonatomic, strong) NSString *tableName;
//字段列表
@property(nonatomic, strong) NSArray *fields;
//主键
@property (nonatomic) NSInteger primaryId;

//主键名称
@property(nonatomic, strong) NSString *primaryField;

//获取当前表的所有数据
-(NSArray *) findAllWithOrderBy: (NSString *) orderBy;
//初始化
-(id) initWithFMDB: (FMDatabase *) database;
//插入数据，并返回最后插入的ID
-(NSInteger) insertWithSql:(NSString *)sql parameters:(NSArray *)params;


//根据主键删除
-(BOOL) deleteWithPrimary:(NSInteger)primaryId;
//根据一对键值删除
-(BOOL) deleteOneWithValue:(NSString *)value forKey:(NSString *)key;

//获取一条记录
-(BOOL) findOneWithCondition:(NSString *)cond parameters:(NSArray *)params orderBy:(NSString *)orderBy;

//根据Sql搜索，并返回结果集
-(NSArray *) findWithSql:(NSString *)sql;

//获取制定范围的数据
-(NSArray *) findAllWithOrderBy: (NSString *) orderBy startIndex: (NSInteger) start endIndex: (NSInteger) end;
@end
