//
//  DataBaseEngine.m
//  新浪微博
//
//  Created by qingyun on 15/12/28.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "DataBaseEngine.h"
#import "NSString+FilePath.h"
#import "FMDB.h"
#import "Status.h"

#define kDBFileName @"status.db"//数据库的文件名字
#define KStatusTable @"status"//微博表的名字

static NSArray *statusTableColumn;//保存status表中的所有字段

@implementation DataBaseEngine


+(void)initialize
{
    if (self==[DataBaseEngine self]) {
        
        //将数据库文件copy到documents下
        [DataBaseEngine copyDatabaseFileToDocuments:kDBFileName];
        //初始化表的存放所含有字段的数据
        statusTableColumn = [DataBaseEngine tableColumn:KStatusTable];
    }
}

+(void)copyDatabaseFileToDocuments:(NSString *)dbname
{
    
    NSString *source =[[NSBundle mainBundle]pathForResource:dbname ofType:nil];
    NSString *toPath =[NSString filePathInDocumentsWithFileName:dbname];
    NSError *error;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:toPath]) {
        //没有数据库文件才copy
        return;
    }
    [[NSFileManager defaultManager] copyItemAtPath:source toPath:toPath error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
}
+(NSArray *)tableColumn:(NSString *)tableName
{
    //创建DB
    FMDatabase *db =[FMDatabase databaseWithPath:[NSString filePathInDocumentsWithFileName:kDBFileName]];
    [db open];
    //执行查询表结构的命令，返回查询结果
    
    FMResultSet *result = [db getTableSchema:tableName];
    
    NSMutableArray *columns =[NSMutableArray array];
    
    while ([result next]) {
        
        //name字段对应了表的column的名字
        
        
        NSString *column =[result objectForColumnName:@"name"];
        [columns addObject:column];
    }
    [db close];
    return columns;
}

+(void)saveStatus:(NSArray *)statuses
{
    // 插入操作，首先创建db，写sql语句，执行操作
    //创建DB
    //db的创建交给queue处理
    
    FMDatabaseQueue *queue =[FMDatabaseQueue databaseQueueWithPath:[NSString filePathInDocumentsWithFileName:kDBFileName]];
    
    [queue inDatabase:^(FMDatabase *db) {
        //进行数据库的增删改查
        [statuses enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *status = obj;
           //首先，查找出所有的有效字段
            
            NSArray *allkey = status.allKeys;
            
            NSArray *contentkey =[DataBaseEngine contentkeyWith: statusTableColumn key2:allkey];
            //删除字典中多余的键值
            
            //将微博字典转化为可变字典
            NSMutableDictionary *resutDic =[NSMutableDictionary dictionaryWithDictionary:status];
            [allkey enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //如果是多余的key，则删除
                if (![contentkey containsObject:obj]) {
                    [resutDic removeObjectForKey:obj];
                }else{
                    //字典中的值转化为二进制类型（nsdata）
                    id value =[resutDic objectForKey:obj];
                    if ([value isKindOfClass:[NSDictionary class]]||[value isKindOfClass:[NSArray class]]) {
                        //如果类型为数组或者字典，转化为二进制数据替换掉
                        NSData *data =[NSKeyedArchiver archivedDataWithRootObject:value];
                        [resutDic setObject:data forKey:obj];
                    }
                }
            }];
            //根据table和字典共有的key，创建插入语句
            NSString *sqlString =[DataBaseEngine sqlStringWithKeys:contentkey];
            BOOL result =[db executeUpdate:sqlString withParameterDictionary:resutDic];
            NSLog(@"%d",result);
        }];
    }];
    
}
// 查询出两个数组中共有的方法
+(NSArray *)contentkeyWith:(NSArray *)key1 key2:(NSArray *)key2
{
    NSMutableArray *result =[NSMutableArray array];
    [key1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = obj;
        //比较一个对象是否包含在另外一个数组中
        if ([key2 containsObject:key]) {
            [result addObject:key];
            
        }
    }];
    return result;
}
+(NSString *)sqlStringWithKeys:(NSArray *)keys
{
    //创建字段的sql语句部分
    NSString *columns =[keys componentsJoinedByString:@", "];
    //占位部分sql语句部分
    NSString *values =[keys componentsJoinedByString:@", "];
    values = [@":" stringByAppendingString:values];
    return [NSString stringWithFormat:@"insert into status(%@) values(%@)",columns,values];
    
    
}

+(NSArray *)getStatusFromDB
{
    //创建数据库
    FMDatabase *db =[FMDatabase databaseWithPath:[NSString filePathInDocumentsWithFileName:kDBFileName]];
    //打开数据库
    [db open];
    
    //查询语句
    NSString *sqlString = @"select * from status order by id desc limit 20";
    //查询，并输出结果
    FMResultSet *result =[db executeQuery:sqlString];
    
    NSMutableArray *statusArray =[NSMutableArray array];
    while ([result next]) {
        //将一条记录转化为一个字典
        NSDictionary *dic =[result resultDictionary];
        NSMutableDictionary *muDic =[NSMutableDictionary dictionaryWithDictionary:dic];
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSData class]]) {
                //解档后更新可变字典
                id value =[NSKeyedUnarchiver unarchiveObjectWithData:obj];
                [muDic setObject:value forKey:key];
                
            }
            if ([obj isKindOfClass:[NSNull class]]) {
                [muDic removeObjectForKey:key];
            }
            
        }];
        //将字典转化为模型
        Status *status =[[Status alloc] initStatusWithDic:muDic];
       [statusArray addObject:status];
}
//释放资源
    [db close];
    return statusArray;
}
@end
