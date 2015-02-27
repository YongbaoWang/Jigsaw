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
        UIImageView *_imageView=[[UIImageView alloc] initWithFrame:self.bounds];
        [_imageView setContentMode:UIViewContentModeScaleToFill];
        [_imageView setBackgroundColor:[UIColor yellowColor]];
        _imageView.tag=1000;
        [self.contentView addSubview:_imageView];
        
        UIButton *selectInditorView=[[UIButton alloc] init];
        [selectInditorView setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [selectInditorView setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
        selectInditorView.tag=1001;
        selectInditorView.selected=NO;
        [selectInditorView addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [selectInditorView setUserInteractionEnabled:NO];
        [selectInditorView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:selectInditorView];
        
        NSDictionary *views=NSDictionaryOfVariableBindings(self.contentView,selectInditorView);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[selectInditorView(22)]-2-|" options:0 metrics:0 views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[selectInditorView(22)]-2-|" options:0 metrics:0 views:views]];

    }
    return self;
}

-(void)setImage:(UIImage *)image
{
    UIImageView * _imageView=(UIImageView *)[self.contentView viewWithTag:1000];
    _imageView.image=image;
}

-(void)setChecked:(BOOL)checked
{
    UIButton *selectInditorView=(UIButton *)[self.contentView viewWithTag:1001];
    selectInditorView.selected=checked;
}

-(void)btnAction:(UIButton *)sender
{
    NSLog(@"btn");
    

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
