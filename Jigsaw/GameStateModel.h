//
//  GameState.h
//  Jigsaw
//
//  Created by Ever on 15/2/5.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameStateModel : NSObject
/**
 *  空格所在位置
 */
@property(nonatomic,copy)NSString *blankRect;
/**
 *  空格所在位置编号
 */
@property(nonatomic,assign)NSInteger blankNum ;
/**
 *  游戏难度
 */
@property(nonatomic,assign)NSInteger gameLevel;
/**
 *  游戏所用步数
 */
@property(nonatomic,assign)NSInteger gameSteps ;
/**
 *  游戏所选图片
 */
@property(nonatomic,copy)NSString *picName;

@end
