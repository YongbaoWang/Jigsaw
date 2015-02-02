//
//  SplitButton.m
//  Jigsaw
//
//  Created by Abao on 15-2-2.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import "SplitButton.h"

@implementation SplitButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        [self initView];
    }
    return self;
}

-(void)initView
{
    [self setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont systemFontOfSize:30]];
    
    UIView *superView=self.superview;
    [self removeFromSuperview];
    
    [self.layer setCornerRadius:4];
    [self.layer setMasksToBounds:YES];
    
    UIView *shadowView=[[UIView alloc] initWithFrame:self.frame];
    shadowView.layer.shadowOffset=CGSizeMake(2, 2);
    shadowView.layer.shadowRadius=1;
    shadowView.layer.shadowOpacity=0.8;
    shadowView.layer.shadowColor=[UIColor blackColor].CGColor;
    
    [superView addSubview:shadowView];
    [shadowView addSubview:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
}
*/
@end
