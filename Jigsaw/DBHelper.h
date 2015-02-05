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

@interface DBHelper : NSObject

/**
 *  保存游戏进度
 *
 *  @param gameView 当前游戏面板
 *  @param picName  图片名称
 */
+(void)saveData:(GameView *)gameView andGameStateModel:(GameStateModel *)model;

/**
 *  加载游戏进度
 *
 *  @param gameView 当前游戏面板
 *  @param picName  图片名称
 */
+(GameStateModel *)loadData:(GameView *)gameView andPicName:(NSString *)picName;

@end
