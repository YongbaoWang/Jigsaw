//
//  MainViewController.m
//  Jigsaw
//
//  Created by Ever on 15/1/31.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import "MainViewController.h"
#import "ViewMacro.h"
#import "PicTableViewCell.h"
#import "GameViewController.h"
#import "AppMacro.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"拼图";
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
    if (SystemVersion>=7.0) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    [self.toolBg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
//    [_myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _picArrayM=[[NSMutableArray alloc] initWithObjects:@"a",@"b",@"c",@"d",@"e", nil];
    UILabel *label=[[UILabel alloc] init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:@"点击图片开始游戏。。。"];
    [label setTextColor:[UIColor blueColor]];
    [label setFont:[UIFont boldSystemFontOfSize:20.0]];
    [_toolBg addSubview:label];

    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *views=NSDictionaryOfVariableBindings(_toolBg,label);
    [_toolBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[label]-10-|" options:0 metrics:0 views:views]];
    [_toolBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label(30)]-2-|" options:0 metrics:0 views:views]];
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MainCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GameViewController *gameVC=[[GameViewController alloc] init];
    gameVC.picName=_picArrayM[indexPath.row];
    [self.navigationController pushViewController:gameVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _picArrayM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity=@"myCell";
    PicTableViewCell *cell=(PicTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identity];
    if (cell==nil) {
        cell=[[PicTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identity];
    }
    cell.pic.image=[UIImage imageNamed:_picArrayM[indexPath.row]];
    
    return cell;
}


@end
