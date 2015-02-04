//
//  AppMacro.h
//  Jigsaw
//
//  Created by Ever on 15/2/2.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#ifndef Jigsaw_AppMacro_h
#define Jigsaw_AppMacro_h

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define SystemVersion     [UIDevice currentDevice].systemVersion.floatValue


#endif
