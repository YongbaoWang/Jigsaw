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
#import "SplitView.h"
#import "DBHelper.h"
#import "GameStateModel.h"

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

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  初始化页面数据
 */
-(void)initView
{
    _gameState=kGameNormal;
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_game"]]];
    
    UIButton *backBtn=[self createToolBtnWithTitle:@"Back"];
    UIButton *saveBtn=[self createToolBtnWithTitle:@"Save"];
    UIButton *loadBtn=[self createToolBtnWithTitle:@"Load"];
    UIButton *resetBtn=[self createToolBtnWithTitle:@"Reset"];
    
    NSDictionary *views=NSDictionaryOfVariableBindings(self.view,saveBtn,backBtn,loadBtn);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[backBtn(==saveBtn)]-10-[saveBtn(==loadBtn)]-10-[loadBtn(==backBtn)]-20-|" options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[backBtn(30)]" options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[saveBtn(==backBtn)]" options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[loadBtn(==backBtn)]" options:0 metrics:0 views:views]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:saveBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:backBtn attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loadBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:backBtn attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    _stepsLbl=[[UILabel alloc] init];
    [_stepsLbl setText:@"点击图片开始游戏..."];
    [_stepsLbl setTextColor:color(195, 116, 65, 1)];
    [_stepsLbl setFont:[UIFont systemFontOfSize:22]];
    [_stepsLbl setTextAlignment:NSTextAlignmentCenter];
    [_stepsLbl setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_stepsLbl];
    NSDictionary *viewsLabel=NSDictionaryOfVariableBindings(self.view,_stepsLbl,backBtn);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_stepsLbl]-5-|" options:0 metrics:0 views:viewsLabel]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[backBtn]-20-[_stepsLbl(20)]" options:0 metrics:0 views:viewsLabel]];
    
    _gameView=[[GameView alloc] init];
    _gameView.picName=self.picName;
    __weak typeof(self) weakSelf=self;
    _gameView.splitAction=^(UIButton *sender){
        [weakSelf splitBtnAction:sender];
    };
    [_gameView setBackgroundColor:color(255, 255, 255, 0.3)];
    [_gameView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_gameView];
    
    NSDictionary *gameViewDict=NSDictionaryOfVariableBindings(self.view,_gameView,_stepsLbl);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_gameView]-15-|" options:0 metrics:0 views:gameViewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_stepsLbl]-20-[_gameView(290)]" options:0 metrics:0 views:gameViewDict]];
    
    NSDictionary *resetViews=NSDictionaryOfVariableBindings(self.view,_gameView,resetBtn);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[resetBtn]-15-|" options:0 metrics:0 views:resetViews]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_gameView]-20@700-[resetBtn(30)]-(>=20)-|" options:0 metrics:0 views:resetViews]];
    [self.view addSubview:resetBtn];
    
    _gameLevel=[DBHelper loadGameLevel];
    _stepsCount=0;
}

/**
 *  工厂方法：创建工具栏按钮
 *
 *  @param title 工具栏按钮标题
 *
 *  @return 工具栏按钮
 */
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

/**
 *  返回
 *
 *  @param sender
 */
-(void)backAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  保存游戏进度
 *
 *  @param sender
 */
-(void)saveAction:(UIButton *)sender
{
    GameStateModel *model=[[GameStateModel alloc] initWithBlankRect:_blankRect andBlankNum:_blankNum andGameLevel:_gameLevel andGameSteps:_stepsCount andPicName:_picName];
    [DBHelper saveData:_gameView andGameStateModel:model];
    NSLog(@"save finish");
}

/**
 *  加载游戏进度
 *
 *  @param sender
 */
-(void)loadAction:(UIButton *)sender
{
    GameStateModel *model=[DBHelper loadData:_gameView andPicName:_picName];
    _blankNum=model.blankNum;
    _blankRect=CGRectFromString(model.blankRect);
    _gameLevel=model.gameLevel;
    _stepsCount=model.gameSteps;
    [_stepsLbl setText:[NSString stringWithFormat:@"Your steps:%d",_stepsCount]];
    NSLog(@"load finish");
}

/**
 *  重置游戏
 *
 *  @param sender
 */
-(void)resetAction:(UIButton *)sender
{
    [UIView transitionWithView:_gameView duration:0.6 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        [_gameView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_gameView setNeedsDisplay];
    } completion:^(BOOL finished) {
        _blankRect=_gameView.blankRect;
        _blankNum=9;
        _gameState=kGameReset;
        [_stepsLbl setText:@"点击图片开始游戏..."];
    }];

    
}

/**
 *  单元格点击事件
 *
 *  @param sender UIButton
 */
-(void)splitBtnAction:(UIButton *)sender
{
    if (kGameNormal==_gameState||kGameReset==_gameState) {
        //开始游戏
        [self _outOfOrderInit];
        [_gameView.splitViewArrayM makeObjectsPerformSelector:@selector(showTitle:) withObject:@1];
        
        [_stepsLbl setText:@"Your steps:0"];
        
        _gameState=kGamePlaying;
        _blankRect=_gameView.blankRect;
        _blankNum=9;
    }
    else if(kGamePlaying==_gameState)
    {
         // 正在游戏
        if (_gameLevel==kGameEasy) {
            
        }
        else if(_gameLevel==kGameMedium)
        {
            if (![self _isValidMove:sender.superview.tag])
            {
                return;
            }
        }
        else if(_gameLevel==kGameHard)
        {
            
        }
        _stepsCount++;
        [_stepsLbl setText:[NSString stringWithFormat:@"Your steps:%d",_stepsCount]];
        CGRect tmp=sender.superview.frame;
        [UIView animateWithDuration:0.2 animations:^{
            sender.superview.frame=_blankRect;
        }];
        _blankRect=tmp;
        NSInteger tag=sender.superview.tag;
        sender.superview.tag=_blankNum;
        _blankNum=tag;
    }
}

/**
 *  乱序排列图片
 */
-(void)_outOfOrderInit
{
    NSMutableArray *splitViewArray=_gameView.splitViewArrayM;
    NSArray *randomArray=[self randomArray];
    for (int i=0; i<randomArray.count; i++) {
        int transform=[randomArray[i] integerValue];
        SplitView *target=(SplitView *)splitViewArray[transform];
        SplitView *origin=(SplitView *)splitViewArray[i];
        int tag=origin.tag;
        origin.tag=target.tag;
        target.tag=tag;
        
        CGRect rect=origin.frame;
        [UIView animateWithDuration:0.3 animations:^{
            origin.frame= target.frame;
            target.frame=rect;
        }];
    }
}

/**
 *  产生不重复随机数组
 *
 *  @return 随机数组结果
 */
-(NSArray *)randomArray
{
    //随机数从这里边产生
    NSMutableArray *startArray=[[NSMutableArray alloc] initWithObjects:@0,@1,@2,@3,@4,@5,@6,@7, nil];
    //随机数产生结果
    NSMutableArray *resultArray=[[NSMutableArray alloc] initWithCapacity:0];
    //随机数个数
    NSInteger m=8;
    for (int i=0; i<m; i++) {
        int t=arc4random()%startArray.count;
        resultArray[i]=startArray[t];
        startArray[t]=[startArray lastObject]; //为更好的乱序，故交换下位置
        [startArray removeLastObject];
    }
    return resultArray;
}

/**
 *  是否是有效移动（只有和空格紧邻的单元格，才是有效移动）
 *
 *  @param tag 点击的btn tag
 *
 *  @return 是否为有效移动
 */
-(BOOL)_isValidMove:(NSInteger)tag
{
    return (_blankNum-1==tag || _blankNum+1==tag ||
    _blankNum-3==tag || _blankNum+3==tag);
}

@end
