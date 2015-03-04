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
        NSString *sql =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' INTEGER, '%@' INTEGER, '%@' TEXT,'%@' TEXT, '%@' INTEGER )",TABLENAME_Progress,GameProgress_ID,GameProgress_BtnTag,GameProgress_ViewTag,GameProgress_ViewFrame,GameProgress_PicName,GameProgress_Type];
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"error when creating db table_cell");
        } else {
            //保存数据
            sql=[NSString stringWithFormat:@"select count(0) from %@ where %@='%@'",TABLENAME_Progress,GameProgress_PicName,model.picName];
            int result=[db intForQuery:sql];
            for (SplitView *splitView in gameView.splitViewArrayM) {
                if (result==0) {
                    sql= [NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@', '%@', '%@','%@') VALUES ('%@', '%@', '%@', '%@','%@')",
                          TABLENAME_Progress,GameProgress_BtnTag,GameProgress_ViewTag,GameProgress_ViewFrame,GameProgress_PicName,GameProgress_Type, [NSNumber numberWithInteger:splitView.btn.tag], [NSNumber numberWithInteger:splitView.tag],NSStringFromCGRect(splitView.frame),model.picName, @1];
                }
                else {
                    sql =[NSString stringWithFormat:@"update %@ set %@='%@',%@='%@' where %@='%@' and %@='%@'",TABLENAME_Progress,GameProgress_ViewTag,[NSNumber numberWithInteger:splitView.tag],GameProgress_ViewFrame,NSStringFromCGRect(splitView.frame),GameProgress_PicName,model.picName,GameProgress_BtnTag,[NSNumber numberWithInteger:splitView.btn.tag]];
                }
                [db executeUpdate:sql];
            }
        }
        //保存游戏状态信息
        sql =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' INTEGER, '%@' TEXT, '%@' INTEGER, '%@' INTEGER ,'%@' TEXT)",TABLENAME_STATE,GameState_ID,GameState_BlankNum,GameState_BlankRect,GameState_GameLevel,GameState_GameSteps,GameState_PicName];
        res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"error when creating db table_state");
        } else {
            //保存数据
            sql=[NSString stringWithFormat:@"select count(0) from %@ where %@='%@'",TABLENAME_STATE,GameState_PicName,model.picName];
            int result=[db intForQuery:sql];
            if (result==0) {
                sql= [NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@', '%@', '%@','%@') VALUES ('%@', '%@', '%@', '%@','%@')",
                      TABLENAME_STATE,GameState_BlankNum,GameState_BlankRect,GameState_GameLevel,GameState_GameSteps,GameState_PicName,[NSNumber numberWithInteger:model.blankNum],model.blankRect,[NSNumber numberWithInteger:model.gameLevel],[NSNumber numberWithInteger:model.gameSteps],model.picName];
            }
            else {
                sql =[NSString stringWithFormat:@"update %@ set %@='%@',%@='%@',%@='%@',%@='%@' where %@='%@' ",TABLENAME_STATE,GameState_BlankNum,[NSNumber numberWithInteger:model.blankNum],GameState_BlankRect,model.blankRect,GameState_GameLevel,[NSNumber numberWithInteger:model.gameLevel],GameState_GameSteps,[NSNumber numberWithInteger:model.gameSteps],GameState_PicName,model.picName];
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
           sql=[NSString stringWithFormat:@"select * from %@ where %@='%@' and %@='%@' and %@='1' ",TABLENAME_Progress,GameProgress_PicName,picName,GameProgress_BtnTag,[NSNumber numberWithInteger:splitView.btn.tag],GameProgress_Type];
            FMResultSet *rs=[db executeQuery:sql];
            if ([rs next]) {
                NSInteger targetTag=[rs intForColumn:GameProgress_ViewTag];
                CGRect targetRect=CGRectFromString([rs stringForColumn:GameProgress_ViewFrame]) ;
                NSLog(@"viewTag:%d,btnTag:%d",(int)targetTag,(int)splitView.btn.tag);
                [UIView animateWithDuration:0.3 animations:^{
                    splitView.frame=targetRect;
                    splitView.tag=targetTag;
                }];
            }
        }
        //读取游戏状态信息
        sql=[NSString stringWithFormat:@"select * from %@ where %@='%@'",TABLENAME_STATE,GameState_PicName,picName];
        FMResultSet *set=[db executeQuery:sql];
        if ([set next]) {
            model=[[GameStateModel alloc] init];
            model.blankNum=[set intForColumn:GameState_BlankNum];
            model.blankRect=[set stringForColumn:GameState_BlankRect];
            model.gameLevel=[set intForColumn:GameState_GameLevel];
            model.gameSteps=[set intForColumn:GameState_GameSteps];
            model.picName=picName;
        }
        
        [db close];
    }
    return model;
}

+(void)saveGameLevel:(GameLevel)gameLevel
{
    NSString *path=[NSTemporaryDirectory() stringByAppendingPathComponent:@"data.db"];
    FMDatabase *db= [FMDatabase databaseWithPath:path];
    if (db && [db open]) {
        //保存游戏单元格位置
        NSString *sql =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' INTEGER, '%@' TEXT)",TABLENAME_AppInfo,AppInfo_ID,AppInfo_GameLevel,AppInfo_AppVersion];
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"error when creating db table_appinfo");
        } else {
            //保存数据
            sql=[NSString stringWithFormat:@"select count(0) from %@ ",TABLENAME_AppInfo];
            int result=[db intForQuery:sql];
            if (result==0) {
                sql= [NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@') VALUES ('%d', '%@')",
                      TABLENAME_AppInfo,AppInfo_GameLevel,AppInfo_AppVersion, gameLevel, @"1.0.0"];
            }
            else {
                sql =[NSString stringWithFormat:@"update %@ set %@='%d' ",TABLENAME_AppInfo,AppInfo_GameLevel,gameLevel];
            }
            [db executeUpdate:sql];
        }
        [db close];
    }
    
}

+(GameLevel)loadGameLevel
{
    GameLevel gameLevel;
    NSString *path=[NSTemporaryDirectory() stringByAppendingPathComponent:@"data.db"];
    FMDatabase *db= [FMDatabase databaseWithPath:path];
    if (db && [db open]) {
        NSString *sql =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' INTEGER, '%@' TEXT)",TABLENAME_AppInfo,AppInfo_ID,AppInfo_GameLevel,AppInfo_AppVersion];
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"error when creating db table_appinfo");
        } else {
            //加载数据
            sql=[NSString stringWithFormat:@"select * from %@ ",TABLENAME_AppInfo];
            FMResultSet *set=[db executeQuery:sql];
            if ([set next]) {
                gameLevel=[set intForColumn:AppInfo_GameLevel];
            }
            else {
                gameLevel=kGameEasy;
            }
        }
        [db close];
    }
    return gameLevel;
}
@end
