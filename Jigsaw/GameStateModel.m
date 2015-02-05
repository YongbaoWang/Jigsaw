//
//  GameState.m
//  Jigsaw
//
//  Created by Ever on 15/2/5.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import "GameStateModel.h"

@implementation GameStateModel

-(id)initWithBlankRect:(CGRect)rect andBlankNum:(NSInteger)blankNum andGameLevel:(NSInteger)gameLevel andGameSteps:(NSInteger)gameSteps andPicName:(NSString *)picName
{
    self=[super init];
    if (self) {
        _blankRect=NSStringFromCGRect(rect);
        _blankNum=blankNum;
        _gameLevel=gameLevel;
        _gameSteps=gameSteps;
        _picName=picName;
    }
    return self;
}

@end
