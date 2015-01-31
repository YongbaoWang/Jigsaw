//
//  GameViewController.m
//  Jigsaw
//
//  Created by Ever on 15/1/31.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import "GameViewController.h"
#import "UIView+CaptureView.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

-(void)initView
{
    [self.view setBackgroundColor:[UIColor yellowColor]];
    UIImageView *imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"a.png"]];
    [imageView setFrame:CGRectMake(0, 0, 230, 350)];
    UIImage *image=[imageView captureViewWithFrame:CGRectMake(100, 180, 60, 60)];
    [imageView setImage:image];
    [imageView setFrame:CGRectMake(100, 100, 60, 60)];
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
