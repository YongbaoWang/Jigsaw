//
//  GameView.m
//  Jigsaw
//
//  Created by Ever on 15/2/2.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import "GameView.h"
#import "UIView+CaptureView.h"

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
            UILabel *label=[[UILabel alloc] initWithFrame:labelRect];
            [label setTextColor:[UIColor redColor]];
            [label setText:[NSString stringWithFormat:@"%d",i*3+(j+1)]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setFont:[UIFont fontWithName:@"American Typewriter" size:50]];
            [label setShadowColor:[UIColor yellowColor]];
            [label setShadowOffset:CGSizeMake(2, 1)];
            [label drawTextInRect:labelRect];
            
            if (!(i==2 && j==2)) {
                CGRect splitRect=CGRectMake(labelWidth*j, labelHeight *i, labelWidth-3, labelHeight-3);
                UIButton *btn=[[UIButton alloc] initWithFrame:splitRect];
                [btn.layer setCornerRadius:10];
                [btn.layer setShadowOffset:CGSizeMake(2, 2)];
                [btn.layer setShadowColor:[UIColor blackColor].CGColor];
                [btn.layer setShadowRadius:1];
                [btn.layer setShadowOpacity:0.8];
               
                [btn setImage:[imageView captureViewWithFrame:splitRect] forState:UIControlStateNormal];
                [btn setTitle:[NSString stringWithFormat:@"%d",i*3+(j+1)] forState:UIControlStateNormal];
                [self addSubview:btn];
            }

        }
    }
}

@end
