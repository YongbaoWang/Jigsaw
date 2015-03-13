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
    //打印视图层次结构信息，注意：recursiveDescription 为私有API
    #define NSLogViewHierarchy(obj)   NSLog(@"recursivecDescription:\n%@",[obj performSelector:@selector(recursiveDescription)])
#else
    #define NSLog(...) {}
    #define NSLogViewHierarchy(obj) {}
#endif

#define UMengAppkey @"54f40a10fd98c551d7000b42"
#define WXAppID @"wxf5604b29b75ab8e9"
#define WXAppSecret @"3eebe428ecc99b4f9ac749be215bce16"
#define QQAppID @"1104335713"
#define QQAppSecret @"SF0qOIMAQqXHKsqy"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define SystemVersion     [UIDevice currentDevice].systemVersion.floatValue
#define PicRemoveNotification  @"PicRemoveNotification"
#define PicAddNotification  @"PicAddNotification"


#endif
