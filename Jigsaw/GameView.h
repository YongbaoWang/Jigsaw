//
//  GameView.h
//  Jigsaw
//
//  Created by Ever on 15/2/2.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^splitBlock)(UIButton *sender);

@interface GameView : UIView

/**
 *  准备拼图的图片
 */
@property(nonatomic,copy)NSString *picName;
@property(nonatomic,copy)splitBlock splitAction;
@property(nonatomic,strong)NSMutableArray *splitViewArrayM;
@property(nonatomic,assign)CGRect blankRect ;

@end
