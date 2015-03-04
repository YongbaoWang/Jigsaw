//
//  SplitView.m
//  Jigsaw
//
//  Created by Ever on 15/2/3.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import "SplitView.h"
#import "ViewMacro.h"

@implementation SplitView

-(id)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView
{
    self.layer.shadowRadius=2;
    self.layer.shadowOpacity=0.8;
    self.layer.shadowOffset=CGSizeMake(2, 2);
    self.layer.shadowColor=[UIColor blackColor].CGColor;
    
    _btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [_btn.layer setCornerRadius:4];
    [_btn.layer setMasksToBounds:YES];

    [self addSubview:_btn];
}

-(void)setTitle:(NSString *)title
{
    [_btn setTitle:title forState:UIControlStateNormal];
    [_btn setTitleColor:color(101, 109, 115, 0.7) forState:UIControlStateNormal];
    [_btn.titleLabel setFont:[UIFont systemFontOfSize:36]];
}

-(void)setImage:(UIImage *)image
{
    [_btn setBackgroundImage:image forState:UIControlStateNormal];
}

-(void)showTitle:(NSNumber *)value
{
    if (value.integerValue==0) {
        [_btn setTitle:@"" forState:UIControlStateNormal];
    }
    else {
        [_btn setTitle:[NSString stringWithFormat:@"%d",(int)_btn.tag] forState:UIControlStateNormal];
    }
}

@end
