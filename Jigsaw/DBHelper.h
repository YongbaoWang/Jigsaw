//
//  DBHelper.h
//  Jigsaw
//
//  Created by Ever on 15/2/4.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameView.h"

@interface DBHelper : NSObject

/**
 *  保存游戏进度
 *
 *  @param gameView 当前游戏面板
 */
+(void)saveData:(GameView *)gameView;

/**
 *  加载游戏进度
 *
 *  @param gameView 当前游戏面板
 */
+(void)loadData:(GameView *)gameView;

@end
