//
//  GameViewController.m
//  Jigsaw
//
//  Created by Ever on 15/1/31.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import "GameViewController.h"
#import "UIView+CaptureView.h"
#import "ViewMacro.h"
#import "GameView.h"
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initView
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_game"]]];
    
    UIButton *loadBtn=[self createToolBtnWithTitle:@"Back"];
    UIButton *saveBtn=[self createToolBtnWithTitle:@"Save"];
    UIButton *clearBtn=[self createToolBtnWithTitle:@"Clear"];
    
    NSDictionary *views=NSDictionaryOfVariableBindings(self.view,saveBtn,loadBtn,clearBtn);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[loadBtn(==saveBtn)]-10-[saveBtn(==clearBtn)]-10-[clearBtn(==loadBtn)]-20-|" options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[loadBtn(30)]" options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[saveBtn(==loadBtn)]" options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[clearBtn(==loadBtn)]" options:0 metrics:0 views:views]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:saveBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:loadBtn attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:clearBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:loadBtn attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    UILabel *stepsLbl=[[UILabel alloc] init];
    [stepsLbl setText:@"Your steps:"];
    [stepsLbl setTextColor:color(195, 116, 65, 1)];
    [stepsLbl setFont:[UIFont systemFontOfSize:22]];
    [stepsLbl setTextAlignment:NSTextAlignmentCenter];
    [stepsLbl setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:stepsLbl];
    NSDictionary *viewsLabel=NSDictionaryOfVariableBindings(self.view,stepsLbl,loadBtn);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[stepsLbl]-10-|" options:0 metrics:0 views:viewsLabel]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[loadBtn]-20-[stepsLbl(30)]" options:0 metrics:0 views:viewsLabel]];
    
    _gameView=[[GameView alloc] init];
    _gameView.picName=self.picName;
    [_gameView setBackgroundColor:color(255, 255, 255, 0.3)];
    [_gameView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_gameView];
    
    NSDictionary *gameViewDict=NSDictionaryOfVariableBindings(self.view,_gameView,stepsLbl);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_gameView]-15-|" options:0 metrics:0 views:gameViewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[stepsLbl]-25-[_gameView(290)]" options:0 metrics:0 views:gameViewDict]];
    
}

-(UIButton *)createToolBtnWithTitle:(NSString *)title
{
    UIButton *btn=[[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.layer setBorderWidth:1];
    [btn.layer setBorderColor:[UIColor grayColor].CGColor];
    NSString *actionName=[[title lowercaseString] stringByAppendingString:@"Action:"];
    [btn addTarget:self action:NSSelectorFromString(actionName) forControlEvents:UIControlEventTouchUpInside];
    [btn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:btn];
    
    return btn;
}

-(void)backAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveAction:(UIButton *)sender
{

}

-(void)clearAction:(UIButton *)sender
{
    
}

//-(void)splitImageInBg:(UIView*)bgView
//{
//    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 290, 290)];
//    [imageView setImage:[UIImage imageNamed:self.picName]];
// 
//    CGRect rect=bgView.frame;
//    NSInteger btnWidth=rect.size.width/3;
//    NSInteger btnHeight=rect.size.height/3;
//    for (int i=0; i<3; i++) {
//        for (int j=0; j<3; j++) {
//            CGRect btnRect=CGRectMake(btnWidth*j, btnHeight *i, btnWidth, btnHeight);
//            UIButton *btn=[[UIButton alloc] initWithFrame:btnRect];
//            [btn setImage:[imageView captureViewWithFrame:btnRect] forState:UIControlStateNormal];
//            [btn setTitle:[NSString stringWithFormat:@"%d",i*3+(j+1)] forState:UIControlStateNormal];
//            [bgView addSubview:btn];
//        }
//    }
//}

@end
