//
//  PicCollectionViewCell.m
//  Jigsaw
//
//  Created by Ever on 15/2/26.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import "PicCollectionViewCell.h"

@implementation PicCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

-(void)setImage:(UIImage *)image
{
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:self.bounds];
    imageView.image=image;
    [self.contentView addSubview:imageView];
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
