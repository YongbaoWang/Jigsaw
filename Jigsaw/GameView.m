//
//  GameView.m
//  Jigsaw
//
//  Created by Ever on 15/2/2.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import "GameView.h"
#import "UIView+CaptureView.h"
#import "SplitLabel.h"
#import "SplitView.h"
#import "UIImage+Cut.h"

@implementation GameView

-(void)drawRect:(CGRect)rect
{
    _splitViewArrayM=[[NSMutableArray alloc] initWithCapacity:0];
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    NSString *filePath= [[NSBundle mainBundle].resourcePath stringByAppendingString:[NSString stringWithFormat:@"/photos/%@",_picName]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]==NO) {
        filePath=[NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"/userPic/%@",_picName]];
    }
    UIImage *image=[UIImage imageWithContentsOfFile:filePath];
    image=[image clipImageWithScaleWithsize:CGSizeMake(290, 290)];
    [imageView setImage:image];
    
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
                SplitView *splitView=[[SplitView alloc] initWithFrame:splitRect];
                [splitView setImage:[imageView captureViewWithFrame:splitRect]];
                splitView.tag=i*3+(j+1);
                splitView.btn.tag=splitView.tag;
                [splitView setTitle:[NSString stringWithFormat:@"%d",i*3+(j+1)] ];
                [splitView.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:splitView];
                [_splitViewArrayM addObject:splitView];
            
            }
            else {
                _blankRect=CGRectMake(labelWidth*j+1, labelHeight *i+1, labelWidth-3, labelHeight-3);
            }
        }
    }
}

-(void)btnAction:(UIButton *)sender
{
    _splitAction(sender);
}

@end
