//
//  GameViewController.h
//  Jigsaw
//
//  Created by Ever on 15/1/31.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameView.h"
#import "SettingViewController.h"
#import "Enum.h"

@interface GameViewController : UIViewController
{
    GameView *_gameView;//游戏面板
    GameState _gameState;//游戏状态
    CGRect _blankRect; //空格所在位置
    NSInteger _blankNum; //空格标号
    GameLevel _gameLevel;//当前游戏难度
    NSInteger _stepsCount; //游戏所用步数
    UILabel *_stepsLbl;
}

/**
 *  选中的图片
 */
@property(nonatomic,copy)NSString *picName;

@end
