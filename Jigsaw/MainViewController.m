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

@interface MainViewController ()<iCarouselDataSource,iCarouselDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *_picArrayM;
}
@end

@implementation MainViewController

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
    UILabel * title=[[UILabel alloc]initWithFrame:CGRectMake(0.0f,0.0f, 120.0f, 36.0f)];
    title.text=@"拼图游戏";
    [title setTextAlignment:NSTextAlignmentCenter];
    self.navigationItem.titleView=title;
    
    UIBarButtonItem *settingBtn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shezhi"] style:UIBarButtonItemStyleBordered target:self action:@selector(settingAction:)];
    self.navigationItem.rightBarButtonItem=settingBtn;
    
    UIBarButtonItem *cameraBtn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraAction:)];
    self.navigationItem.leftBarButtonItem=cameraBtn;
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor grayColor]];
    
    [_picCarousel setHidden:YES];
    if (SystemVersion>=7.0) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    [self.toolBg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    
    UILabel *label=[[UILabel alloc] init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:@"点击图片开始游戏。。。"];
    [label setTextColor:[UIColor blueColor]];
    [label setFont:[UIFont boldSystemFontOfSize:18.0]];
    [_toolBg addSubview:label];

    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *views=NSDictionaryOfVariableBindings(_toolBg,label);
    [_toolBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[label]-10-|" options:0 metrics:0 views:views]];
    [_toolBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label(30)]-2-|" options:0 metrics:0 views:views]];
    
    
    _picCarousel.delegate=self;
    _picCarousel.dataSource=self;
    
    _picCarousel.type=iCarouselTypeCoverFlow;
    _picArrayM=[[NSMutableArray alloc] init];
    for (int i=0; i<20; i++) {
        _picArrayM[i]=[NSString stringWithFormat:@"%d",i];
    }
    [_picCarousel reloadData];
}

-(void)settingAction:(id)sender
{
    SettingViewController *settingVC=[[SettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

-(void)cameraAction:(id)sender
{
    UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing=YES;
    picker.sourceType=sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)selectPicture:(UIImage *)image
{
    
}

#pragma mark - iCarouselDataSource
-(NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return _picArrayM.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view==nil) {
        view=[[UIImageView alloc] init];
        view.frame=CGRectMake(0, 0, carousel.frame.size.width-100, carousel.frame.size.height-20);
    }
    UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",_picArrayM[index]]];
    ((UIImageView *)view).image=image;
    
    return view;
}

#pragma mark - iCarouselDelegate
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"%d",index);
    GameViewController *gameBoardVC=[[GameViewController alloc] init];
    gameBoardVC.picName=[NSString stringWithFormat:@"%d.jpg",index];
    [self.navigationController pushViewController:gameBoardVC animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage * image=[info objectForKey:UIImagePickerControllerEditedImage];
        [self selectPicture:image];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
