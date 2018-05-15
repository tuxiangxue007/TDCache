//
//  ViewController.m
//  TDCacheDemo
//
//  Created by DAA on 2018/4/18.
//  Copyright © 2018年 DAA. All rights reserved.
//

#import "ViewController.h"
#import "TDCacheObject.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    TDCacheObject *chcheObject = [[TDCacheObject alloc]init];
    
    
    
    TDOperator *operator;
    NSInteger TDInteger = 2;
    
    if (TDInteger == 1) {//使用默认的模型操作默认的sql
//        operator = [TDOperator sharedCache];
        
//        for (int i = 0; i < 5; i++) {
//
//
//            //给模型赋值
//            operator.ID = i;
//            operator.todo = [NSString stringWithFormat:@"hello--%d",i];
//
//            //插入数据库
//            [operator insert];
//        }
        
        
    }else{
        //创建sqlite模型类
        TDCacheObject *cacheModel = [[TDCacheObject alloc]init];
        //通过模型生产操作者
        operator = [TDOperator instanceWhithModel:cacheModel];
        
        
        for (int i = 0; i < 5; i++) {
            
            
            TDCacheObject *cacheModel = [[TDCacheObject alloc]init];
            
            //给模型赋值
            cacheModel.name = [NSString stringWithFormat:@"name - %d",i];
            cacheModel.ID = i;
            cacheModel.age = [NSString stringWithFormat:@"age--%d", 20 +i];
            
            //插入数据库
            [operator insertWithModel:cacheModel];
        }
        
        
        
    }
    
    //打印操作者所控制的数据库里的所有数据
    NSLog(@"%@",[operator returnAllData]);
    
    //删除主键为1 的数据
    [operator deleteWithPrimary:1];
    
    //打印操作者所控制的数据库里的所有数据
    NSLog(@"%@",[operator returnAllData]);
    
    //返回所有的key为age 值为age--24的数据
    NSArray *dataArr = [operator findOneWithValue:@"age--24" forKey:@"age"];
    for (TDCacheObject *m in dataArr) {
        NSLog(@"ID:%d --- age:%@ -- name :%@",m.ID,m.age,m.name);
    }
    
    NSArray *dataArr1 = [operator findIntervalPrimartId:1 end:3];
    for (TDCacheObject *m in dataArr1) {
        NSLog(@"ID:%d --- age:%@ -- name :%@",m.ID,m.age,m.name);
    }
    NSLog(@"%d",[operator deleteSql]); //删除数据库
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
