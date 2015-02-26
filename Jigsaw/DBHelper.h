//
//  DBHelper.h
//  Jigsaw
//
//  Created by Ever on 15/2/4.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameView.h"
#import "GameStateModel.h"
#import "Enum.h"

@interface DBHelper : NSObject

/**
 *  保存游戏进度
 *
 *  @param gameView 当前游戏面板
 *  @param model  游戏实体
 */
+(void)saveData:(GameView *)gameView andGameStateModel:(GameStateModel *)model;

/**
 *  加载游戏进度
 *
 *  @param gameView 当前游戏面板
 *  @param picName  图片名称
 */
+(GameStateModel *)loadData:(GameView *)gameView andPicName:(NSString *)picName;

/**
 *  保存游戏难度
 *
 *  @param gameLevel 游戏难度等级
 */
+(void)saveGameLevel:(GameLevel)gameLevel;

/**
 *  获取游戏难度
 *
 *  @return 游戏难度
 */
+(GameLevel)loadGameLevel;

@end
