//
//  GameViewController.h
//  Jigsaw
//
//  Created by Ever on 15/1/31.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameView.h"

@interface GameViewController : UIViewController
{
    GameView *_gameView;
}

/**
 *  选中的图片
 */
@property(nonatomic,copy)NSString *picName;

@end
