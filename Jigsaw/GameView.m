//
//  GameView.m
//  Jigsaw
//
//  Created by Ever on 15/2/2.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import "GameView.h"
#import "UIView+CaptureView.h"
#import "SplitButton.h"
#import "SplitLabel.h"

@implementation GameView

-(void)drawRect:(CGRect)rect
{
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [imageView setImage:[UIImage imageNamed:_picName]];
    
    NSInteger labelWidth=rect.size.width/3;
    NSInteger labelHeight=rect.size.height/3;
    for (int i=0; i<3; i++) { //行
        for (int j=0; j<3; j++) {  //列
            CGRect labelRect=CGRectMake(labelWidth*j, labelHeight *i, labelWidth, labelHeight);
            SplitLabel *label=[[SplitLabel alloc] initWithFrame:labelRect];
            [label setText:[NSString stringWithFormat:@"%d",i*3+(j+1)]];
            [label drawTextInRect:labelRect];
            
            if (!(i==2 && j==2)) {
                CGRect splitRect=CGRectMake(labelWidth*j+1, labelHeight *i+1, labelWidth-3, labelHeight-3);
                SplitButton *btn=[[SplitButton alloc] initWithFrame:splitRect];
                [btn setBackgroundImage:[imageView captureViewWithFrame:splitRect] forState:UIControlStateNormal];
                btn.tag=i*3+(j+1);
                [btn setTitle:[NSString stringWithFormat:@"%d",i*3+(j+1)] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
            }

        }
    }
}

-(void)btnAction:(UIButton *)sender
{
    _splitAction(sender.tag);
}

@end
