//
//  Enum.h
//  Jigsaw
//
//  Created by Ever on 15/2/26.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#ifndef Jigsaw_Enum_h
#define Jigsaw_Enum_h

typedef enum : NSUInteger {
    kGameNormal,
    kGamePlaying,
    kGameEnd,
    kGameReset
} GameState;

typedef enum : NSUInteger {
    kGameEasy=0,
    kGameMedium=1,
    kGameHard=2,
} GameLevel;

#endif
