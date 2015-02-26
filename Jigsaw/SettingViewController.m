//
//  SettingViewController.m
//  Jigsaw
//
//  Created by Ever on 15/1/31.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import "SettingViewController.h"
#import "DBHelper.h"
#import "PicManagerViewController.h"

#define PHOTO_HEIGHT 100

@interface SettingViewController ()
{
    NSMutableArray *_picArrayM;
}

@end

@implementation SettingViewController

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
    [self.view setBackgroundColor:[UIColor grayColor]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) { //游戏难度、图片管理
        return 2;
    }
    else if(section==1) //分析、在线反馈、检查更新
    {
        return 3;
    }
    else if(section==2) //赞助作者
    {
        return 1;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity=@"myCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identity];
    }
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row==0) { //游戏难度
                cell.textLabel.text=@"游戏难度";
                NSString *text;
                NSInteger dbLevel=[DBHelper loadGameLevel];
                if (dbLevel==kGameEasy) {
                    text=@"Easy";
                }
                else if (dbLevel==kGameMedium) {
                    text=@"Medium";
                }
                else if (dbLevel==kGameHard) {
                    text=@"Hard";
                }
                cell.detailTextLabel.text=text;
            }
            else if(indexPath.row==1) //图片管理
            {
                cell.textLabel.text=@"图片管理";
            }
        }
            break;
        case 1:
        {
            if (indexPath.row==0) { //分享
                cell.textLabel.text=@"分享";
            }
            else if(indexPath.row==1) //在线反馈
            {
                cell.textLabel.text=@"在线反馈";

            }
            else if(indexPath.row==2) //检查更新
            {
                cell.textLabel.text=@"检查更新";
                cell.detailTextLabel.text=@"当前版本:1.0.0";
            }
        }
            break;
        case 2:
        {
            if (indexPath.row==0) { //赞助作者
                cell.textLabel.text=@"赞助作者";
            }
        }
            break;
        default:
            break;
    }
    cell.textLabel.font=[UIFont systemFontOfSize:16.0];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:14.0];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        return 60;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==2) {
        UILabel *label=[[UILabel alloc] init];
        label.textAlignment=NSTextAlignmentCenter;
        label.text= @"Stay foolish.Stay hungry!";
        return label;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row==0) { //游戏难度
                UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"简单模式",@"一般模式",@"难度模式", nil];
                [actionSheet showInView:self.view];
            }
            else if(indexPath.row==1) //图片管理
            {
                PicManagerViewController *picManaVC=[[PicManagerViewController alloc] init];
                [self.navigationController pushViewController:picManaVC animated:YES];
                
            }
        }
            break;
        case 1:
        {
            if (indexPath.row==0) { //分享
               
            }
            else if(indexPath.row==1) //在线反馈
            {
                
                
            }
            else if(indexPath.row==2) //检查更新
            {
               
            }
        }
            break;
        case 2:
        {
            if (indexPath.row==0) { //赞助作者
                
            }
        }
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",buttonIndex);
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell=[_myTableView cellForRowAtIndexPath:indexPath];
    GameLevel gameLevel;
    if (buttonIndex==0) { //简单模式
        cell.detailTextLabel.text=@"Easy";
        gameLevel=kGameEasy;
    }
    else if(buttonIndex==1) //一般模式
    {
        cell.detailTextLabel.text=@"Medium";
        gameLevel=kGameMedium;
    }
    else if(buttonIndex==2) //难度模式
    {
        cell.detailTextLabel.text=@"Hard";
        gameLevel=kGameHard;
    }
    [DBHelper saveGameLevel:gameLevel];
}

@end
