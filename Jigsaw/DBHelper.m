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

+(void)saveData:(GameView *)gameView andGameStateModel:(GameStateModel *)model;
{
    NSString *path=[NSTemporaryDirectory() stringByAppendingPathComponent:@"data.db"];
    FMDatabase *db= [FMDatabase databaseWithPath:path];
    if (db && [db open]) {
        //保存游戏单元格位置
        NSString *sql =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' INTEGER, '%@' INTEGER, '%@' TEXT,'%@' TEXT, '%@' INTEGER )",TABLENAME_Cell,ID,BtnTag,ViewTag,ViewFrame,PicName,Type];
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"error when creating db table_cell");
        } else {
            //保存数据
            sql=[NSString stringWithFormat:@"select count(0) from %@ where %@='%@'",TABLENAME_Cell,PicName,model.picName];
            int result=[db intForQuery:sql];
            for (SplitView *splitView in gameView.splitViewArrayM) {
                if (result==0) {
                    sql= [NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@', '%@', '%@','%@') VALUES ('%@', '%@', '%@', '%@','%@')",
                          TABLENAME_Cell,BtnTag,ViewTag,ViewFrame,PicName,Type, [NSNumber numberWithInteger:splitView.btn.tag], [NSNumber numberWithInteger:splitView.tag],NSStringFromCGRect(splitView.frame),model.picName, @1];
                }
                else {
                    sql =[NSString stringWithFormat:@"update %@ set %@='%@',%@='%@' where %@='%@' and %@='%@'",TABLENAME_Cell,ViewTag,[NSNumber numberWithInteger:splitView.tag],ViewFrame,NSStringFromCGRect(splitView.frame),PicName,model.picName,BtnTag,[NSNumber numberWithInteger:splitView.btn.tag]];
                }
                [db executeUpdate:sql];
            }
        }
        //保存游戏状态信息
        sql =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' INTEGER, '%@' TEXT, '%@' INTEGER, '%@' INTEGER ,'%@' TEXT)",TABLENAME_STATE,ID,BlankNum,BlankRect,GameLevel,GameSteps,PicName];
        res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"error when creating db table_state");
        } else {
            //保存数据
            sql=[NSString stringWithFormat:@"select count(0) from %@ where %@='%@'",TABLENAME_STATE,PicName,model.picName];
            int result=[db intForQuery:sql];
            if (result==0) {
                sql= [NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@', '%@', '%@','%@') VALUES ('%@', '%@', '%@', '%@','%@')",
                      TABLENAME_STATE,BlankNum,BlankRect,GameLevel,GameSteps,PicName,[NSNumber numberWithInteger:model.blankNum],model.blankRect,[NSNumber numberWithInteger:model.gameLevel],[NSNumber numberWithInteger:model.gameSteps],model.picName];
            }
            else {
                sql =[NSString stringWithFormat:@"update %@ set %@='%@',%@='%@',%@='%@',%@='%@' where %@='%@' ",TABLENAME_STATE,BlankNum,[NSNumber numberWithInteger:model.blankNum],BlankRect,model.blankRect,GameLevel,[NSNumber numberWithInteger:model.gameLevel],GameSteps,[NSNumber numberWithInteger:model.gameSteps],PicName,model.picName];
            }
            [db executeUpdate:sql];
        }

        [db close];
    }
}

+(GameStateModel *)loadData:(GameView *)gameView andPicName:(NSString *)picName
{
    NSString *path=[NSTemporaryDirectory() stringByAppendingPathComponent:@"data.db"];
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    GameStateModel *model=nil;
    if (db && [db open]) {
        NSString *sql;
        //读取游戏单元格坐标信息
        for (SplitView *splitView in gameView.splitViewArrayM) {
           sql=[NSString stringWithFormat:@"select * from %@ where %@='%@' and %@='%@' and %@='1' ",TABLENAME_Cell,PicName,picName,BtnTag,[NSNumber numberWithInteger:splitView.btn.tag],Type];
            FMResultSet *rs=[db executeQuery:sql];
            if ([rs next]) {
                NSInteger targetTag=[rs intForColumn:ViewTag];
                CGRect targetRect=CGRectFromString([rs stringForColumn:ViewFrame]) ;
                NSLog(@"viewTag:%d,btnTag:%d",targetTag,splitView.btn.tag);
                [UIView animateWithDuration:0.3 animations:^{
                    splitView.frame=targetRect;
                    splitView.tag=targetTag;
                }];
            }
        }
        //读取游戏状态信息
        sql=[NSString stringWithFormat:@"select * from %@ where %@='%@'",TABLENAME_STATE,PicName,picName];
        FMResultSet *set=[db executeQuery:sql];
        if ([set next]) {
            model=[[GameStateModel alloc] init];
            model.blankNum=[set intForColumn:BlankNum];
            model.blankRect=[set stringForColumn:BlankRect];
            model.gameLevel=[set intForColumn:GameLevel];
            model.gameSteps=[set intForColumn:GameSteps];
            model.picName=picName;
        }
        
        [db close];
    }
    return model;
}

@end
