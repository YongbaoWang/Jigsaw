//
//  IphoneScreen.h
//  MeiJiaLove
//
//  Created by Wu.weibin on 13-5-25.
//  Copyright (c) 2013年 Wu.weibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#define IS_IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//#define ScreenHeightWithCamera (IS_IPHONE5 ? 548.0 : 460.0)
#define ScreenHeightWithCamera ([UIScreen mainScreen].bounds.size.height )

@interface IphoneScreen : NSObject
 
@end
