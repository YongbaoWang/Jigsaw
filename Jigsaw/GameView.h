//
//  GameView.h
//  Jigsaw
//
//  Created by Ever on 15/2/2.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^splitBlock)(NSInteger btnTag);

@interface GameView : UIView

/**
 *  准备拼图的图片
 */
@property(nonatomic,copy)NSString *picName;
@property(nonatomic,copy)splitBlock splitAction;

@end
