//
//  SplitView.h
//  Jigsaw
//
//  Created by Ever on 15/2/3.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplitView : UIView

@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)UIImage *image ;
/**
 *  使用View.Tag 记录当前位置；使用 btn.Tag 记录正确位置
 */
@property(nonatomic,strong)UIButton *btn ;

/**
 *  title 是否显示
 *
 *  @param value 0 不显示；1 显示
 */
-(void)showTitle:(NSNumber *)value;

@end
