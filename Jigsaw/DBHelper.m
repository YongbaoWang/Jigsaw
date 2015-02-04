//
//  DBHelper.m
//  Jigsaw
//
//  Created by Ever on 15/2/4.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import "DBHelper.h"
#import "FMDB.h"
#import "DatabaseMacro.h"
#import "SplitView.h"

@implementation DBHelper

+(void)saveData:(GameView *)gameView
{
    NSString *path=[NSTemporaryDirectory() stringByAppendingPathComponent:@"data.db"];
    FMDatabase *db= [FMDatabase databaseWithPath:path];
    if (db && [db open]) {
        NSString *sql =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' INTEGER, '%@' INTEGER, '%@' TEXT,'%@' INTEGER )",TABLENAME,ID,BtnTag,ViewTag,ViewFrame,Type];
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            //保存数据
            for (SplitView *splitView in gameView.splitViewArrayM) {
                sql= [NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@')",
                      TABLENAME,BtnTag,ViewTag,ViewFrame,Type, [NSNumber numberWithInteger:splitView.btn.tag], [NSNumber numberWithInteger:splitView.tag],NSStringFromCGRect(splitView.frame), @1];
                [db executeUpdate:sql];
            }
        }
        [db close];
    }
}

+(void)loadData:(GameView *)gameView
{
    
}

@end
