//
//  TDOperatorAndModel.m
//  TDCacheFMDB
//
//  Created by DAA on 16/1/26.
//  Copyright © 2016年 DAA. All rights reserved.
//

#import "TDOperator.h"
//#import "TDRuntimeAttbute.h"


@interface TDOperator (){
    NSObject *_objModel;
}

@property (nonatomic, strong)id obj;

@end
@implementation TDOperator


+ (id)sharedCache{
    static TDOperator *cache = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        FMDatabase *fmdb = [[FMDatabase alloc]init];
        
        cache = [[TDOperator alloc]initWithFMDB:fmdb];
        [cache initDatabase];
        
    });
    
    return cache;
}
+ (id)instanceWhithModel:(id)obj{
    FMDatabase *fmdb = [[FMDatabase alloc]init];
    TDOperator *cache = [[TDOperator alloc]initWithFMDB:fmdb];
    if (cache) {
        cache.obj = obj;
        if (cache.obj) {
            NSDictionary *objectClassInDict =  (NSDictionary *)[cache.obj performSelector:NSSelectorFromString(@"getTableInstance") withObject:nil];
            cache.tableName = [objectClassInDict objectForKey:@"tableName"];
            cache.fields = [self getProperyNameListWhitObj:cache.obj];
        }
        [cache initDatabase];
    }
    return cache;
}
-(id) initWithFMDB:(FMDatabase *)database{
    self = [super initWithFMDB:database];
    if(self){
        //给表名赋值
        self.tableName = @"todolist";
        //字段列表
        self.fields = [TDOperator fields];
        //主键的ID
        self.primaryField = [TDOperator ID];
        [self setDefault];
    }
    return self;
}
//初始化数据库
-(void) initDatabase{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    path = [path stringByAppendingString:@"/test.sqlite"];
    if (self.obj) {
         NSDictionary *objectClassInDict =  (NSDictionary *)[self.obj performSelector:NSSelectorFromString(@"getTableInstance") withObject:nil];
        NSLog(@"%@",objectClassInDict);
        path = [objectClassInDict objectForKey:@"tablePath"];
    }
    
    //删除现有的文件
    //    NSFileManager *fm = [NSFileManager defaultManager];
    //    [fm removeItemAtPath: path error: nil];
    
    self.database = [[FMDatabase alloc] initWithPath:path];
    self.database.traceExecution = YES;
    //建表
    [self.database open];
    [self.database executeUpdate: [self sqlForCreateTable]];
    [self.database close];
    
    //    [self insertSamples];
}


//设置默认数据
-(void) setDefault{
    
    self.ID = NSNotFound;
    
    NSMutableDictionary *propertyInfoDict = [[self getSimpleProperyValueListWhitObj:self] mutableCopy];
    if (self.obj) {
        propertyInfoDict = [[self getSimpleProperyValueListWhitObj:self.obj] mutableCopy];
    }
    [propertyInfoDict removeObjectForKey:@"ID"];
    
    for (NSString *propertyName in propertyInfoDict) {
        SEL setSel = [self creatSetWithPropertyName:propertyName];
        NSDictionary *dict = [propertyInfoDict objectForKey:propertyName];
        if ([[dict objectForKey:@"propertyType"] integerValue] == 1 || [[dict objectForKey:@"propertyType"] integerValue] == 3) {
            
            [self performSelectorOnMainThread:setSel withObject:0 waitUntilDone:YES];
        }else if ([[dict objectForKey:@"propertyType"] integerValue] == 2 ){
            [self performSelectorOnMainThread:setSel withObject:@"" waitUntilDone:YES];
        }else{
            [self performSelectorOnMainThread:setSel withObject:nil waitUntilDone:YES];
        }
    }
    
    //清除数据
    
    //  self.todo = @"";
    //  self.timestamp = nil;
}

//获取所有字段存到数据库的值
-(NSArray *) parametersWithObj:(id)obj withKeys:(NSArray *)propertyKeys{
    NSMutableDictionary *propertyInfoDict = [[self getProperyValueListWhitObj:obj] mutableCopy];
//    if (self.obj) {
//        propertyInfoDict = [[TDRuntimeAttbute getProperyValueListWhitObj:self.obj] mutableCopy];
//    }
    NSInteger ID =  [[obj valueForKey:@"ID"] integerValue];
    if (ID == NSNotFound || ID == 0) {
        [propertyInfoDict removeObjectForKey:@"ID"];
    }
    NSMutableArray *propertyArr = [NSMutableArray array];
    
    for (NSString *key in propertyKeys) {
        [propertyArr addObject:[[propertyInfoDict objectForKey:key] objectForKey:@"propertyValue"]];
    }
//    for (NSString *propertyName in propertyInfoDict) {
//        
//        [propertyArr addObject:[[propertyInfoDict objectForKey:propertyName] objectForKey:@"propertyValue"]];
//    }
    return propertyArr;
    
}

//插入数据
-(NSInteger)insert{
    NSString *sql = @"INSERT INTO %@(%@) VALUES (%@)";
    NSString *insertFields ;
    NSString *insertValues ;
    NSMutableArray *propertyArr = [[self getProperyNameListWhitObj:self] mutableCopy];
    if (self.obj) {
        propertyArr = [[self getProperyNameListWhitObj:self.obj] mutableCopy];
    }
    if (self.ID == NSNotFound) {
        [propertyArr removeObject:@"ID"];
    }
    
    for (NSString *porpertyName in propertyArr) {
        if (insertFields.length > 1) {
            insertFields = [NSString stringWithFormat:@"%@ ,%@",insertFields,porpertyName];
            insertValues = [NSString stringWithFormat:@"%@ ,?",insertValues];
        }else{
            insertFields = porpertyName;
            insertValues = @"?";
        }
        
    }
    
    
    
    sql = [NSString stringWithFormat: sql, self.tableName, insertFields, insertValues];
    NSArray *propertys;
    propertys=[self parametersWithObj:self withKeys:propertyArr];
    
    
    return [self insertWithSql:sql parameters: propertys];
}
-(NSInteger)insertWithModel:(NSObject *)obj{
    NSString *sql = @"INSERT INTO %@(%@) VALUES (%@)";
    NSString *insertFields ;
    NSString *insertValues ;
    NSMutableArray *propertyArr = [[self getProperyNameListWhitObj:self] mutableCopy];
    if (self.obj) {
        propertyArr = [[self getProperyNameListWhitObj:self.obj] mutableCopy];
        
    }
    NSInteger ID =  [[obj valueForKey:@"ID"] integerValue];
    if (ID == NSNotFound || ID == 0) {
        [propertyArr removeObject:@"ID"];
    }
    
    for (NSString *porpertyName in propertyArr) {
        if (insertFields.length > 1) {
            insertFields = [NSString stringWithFormat:@"%@ ,%@",insertFields,porpertyName];
            insertValues = [NSString stringWithFormat:@"%@ ,?",insertValues];
        }else{
            insertFields = porpertyName;
            insertValues = @"?";
        }
        
    }
    
    sql = [NSString stringWithFormat: sql, self.tableName, insertFields, insertValues];
    
    NSArray *propertys = [self parametersWithObj:obj withKeys:propertyArr];
    

    return [self insertWithSql:sql parameters: propertys];
}
//更新数据
-(BOOL)update{
    NSArray *propertys;
    if (self.obj) {
        
        NSArray *propertyArr = [self getProperyNameListWhitObj:self];
        propertys=[self parametersWithObj:self.obj withKeys:propertyArr];
    }else{
        NSArray *propertyArr = [self getProperyNameListWhitObj:self.obj];
        propertys=[self parametersWithObj:self withKeys:propertyArr];
    }
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET todo = ? WHERE id = ?",self.tableName];
    [self.database open];
    BOOL result = [self.database executeUpdate:sql withArgumentsInArray: propertys];
    [self.database close];
    return result;
}



//获取一条数据
-(BOOL) findOneWithCondition:(NSString *)cond parameters:(NSArray *)params orderBy:(NSString *)orderBy{
    BOOL result = [super findOneWithCondition:cond parameters:params orderBy:orderBy];
    //将数据填充到属性
    if(result){
        [self setAttributes:self.data];
    }else{
        //没有找到数据，还原为初始值
        [self setDefault];
    }
    return result;
}

//获取所有的字段名称
+(NSArray *) fields{
    
    return [self getProperyNameListWhitObj:self];
}

- (NSArray *)returnAllData{
    NSString *orderBy = [NSString stringWithFormat: @" ORDER BY %@ DESC", [TDOperator ID]];
    
    NSArray *list = [self findAllWithOrderBy: orderBy];
    if (self.obj) {
        return [[self.obj class]modelsWithList:list];
    }
    return [TDOperator modelsWithList:list];
}

//字段名：id
+(NSString*)ID{
    return @"id";
}

//创建数据库的sql语句
-(NSString *) sqlForCreateTable{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE if not exists %@(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT",self.tableName];
    
    NSDictionary *propertyInfoDict = [self getSimpleProperyValueListWhitObj:self];
    if (self.obj) {
        propertyInfoDict = [self getSimpleProperyValueListWhitObj:self.obj];
    }
    
    for (NSString *propertName in propertyInfoDict) {
        if (![propertName isEqualToString:@"ID"]) {
            NSDictionary *propertyDict = [propertyInfoDict objectForKey:propertName];
            NSString *propertyType = [FMDB_DATA_TYPE objectForKey:[propertyDict objectForKey:@"propertyType"]];
            sql = [NSString stringWithFormat:@"%@, %@ %@",sql,propertName,propertyType];
        }
    }
    sql = [NSString stringWithFormat:@"%@)",sql];
    
    
    return sql;
}

//根据主键，获取一条记录
-(BOOL)findOneWithPrimaryId:(NSInteger) primaryId{
    //    NSString *cond = [NSString stringWithFormat: @" AND %@ = %ld", self.primaryField, primaryId];
    NSString *sqlCmd = [NSString stringWithFormat:@"select * from %@ where 1 = 1 and %@ like '%ld'  limit   1",self.tableName,self.primaryField,primaryId];
    
    NSArray *arr = [self findWithSql:sqlCmd];
    
    [self setAttributes:[arr firstObject]];
    return YES;
}

//根据一对键值查找数据
- (NSArray *)findOneWithValue:(NSString *)value forKey:(NSString *)key{
    
    NSString *sqlCmd = [NSString stringWithFormat:@"select * from %@ where 1 = 1 and %@ like '%@'  limit   1",self.tableName,key,value];
    NSArray *arr = [self findWithSql:sqlCmd];
    NSArray *dataArr;
    if (self.obj) {
        dataArr = [[self.obj class] modelsWithList:arr];
    }else{
        dataArr = [TDOperator modelsWithList:arr];
    }
    
    return dataArr;
}

- (NSArray *)findIntervalPrimartId:(NSInteger)start end:(NSInteger)end{
    NSString *orderBy = [NSString stringWithFormat: @" ORDER BY %@ DESC", [TDOperator ID]];
    NSArray *arr = [self findAllWithOrderBy:orderBy startIndex:start  endIndex:end];
    
//    NSString *sqlCmd = [NSString stringWithFormat:@"select * from %@ where 1 = 1 and %@ like '%ld','%ld'  limit   1,'%ld'",self.tableName,self.primaryField,start,end,NSNotFound];
//    
//    NSArray *arr = [self findWithSql:sqlCmd];
//    
    NSArray *dataArr;
    if (self.obj) {
        dataArr = [[self.obj class] modelsWithList:arr];
    }else{
        dataArr= [TDOperator modelsWithList:arr];
    }
    return dataArr;
}

- (BOOL)deleteSql{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    path = [path stringByAppendingString:@"/test.sqlite"];
    if (self.obj) {
        NSDictionary *objectClassInDict =  (NSDictionary *)[self.obj performSelector:NSSelectorFromString(@"getTableInstance") withObject:nil];
        NSLog(@"%@",objectClassInDict);
        path = [objectClassInDict objectForKey:@"tablePath"];
    }
    
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL bRet = [fileMgr fileExistsAtPath:path];
    if (bRet) {
        NSError *err;
        [fileMgr removeItemAtPath:path error:&err];
        return YES;
    }
    return NO;
}

@end
