//
//  SplitLabel.m
//  Jigsaw
//
//  Created by Abao on 15-2-2.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import "SplitLabel.h"

@implementation SplitLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initLabel];
    }
    return self;
}

-(void)initLabel
{
    [self setTextColor:[UIColor redColor]];
    [self setTextAlignment:NSTextAlignmentCenter];
    [self setFont:[UIFont fontWithName:@"American Typewriter" size:50]];
    [self setShadowColor:[UIColor yellowColor]];
    [self setShadowOffset:CGSizeMake(2, 1)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
