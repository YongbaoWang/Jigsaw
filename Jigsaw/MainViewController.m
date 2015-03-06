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
#import "TagMacro.h"
#import "OnlinePicViewController.h"

@interface MainViewController ()<iCarouselDataSource,iCarouselDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *_picArrayM;
}

@property(nonatomic,strong)NSMutableDictionary *imageMemoryPool ;

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
    
    [self initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePicWhenNotification:) name:PicRemoveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPicWhenNotification:) name:PicAddNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [_picCarousel reloadData];
    _picCarousel.currentItemIndex=0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //收到内存警告时，释放图片缓存池
    [self.imageMemoryPool removeAllObjects];
}

-(void)dealloc
{
    //ARC 下，不再调用 [super dealloc]
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PicRemoveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PicAddNotification object:nil];


}

#pragma mark - NSNotificationCenter Method
-(void)removePicWhenNotification:(NSNotification *)notification
{
    [_picArrayM removeObject:notification.object];
}

-(void)addPicWhenNotification:(NSNotification *)notification
{
    [_picArrayM insertObject:notification.object atIndex:0];
    [_picCarousel reloadData];
}

#pragma mark - lazy loading
-(NSMutableDictionary *)imageMemoryPool
{
    if (_imageMemoryPool==nil) {
        _imageMemoryPool=[[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _imageMemoryPool;
}

-(void)initView
{
    UILabel * title=[[UILabel alloc]initWithFrame:CGRectMake(0.0f,0.0f, 120.0f, 36.0f)];
    title.text=NSLocalizedString(@"mainTitle", @"");
    [title setTextAlignment:NSTextAlignmentCenter];
    self.navigationItem.titleView=title;
    
    UIBarButtonItem *settingBtn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shezhi"] style:UIBarButtonItemStyleBordered target:self action:@selector(settingAction:)];
    self.navigationItem.rightBarButtonItem=settingBtn;
    
    UIBarButtonItem *cameraBtn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraAction:)];
    self.navigationItem.leftBarButtonItem=cameraBtn;
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor grayColor]];
    
    [_picCarousel setHidden:NO];
    if (SystemVersion>=7.0) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    [self.view setBackgroundColor:color(232, 232, 232, 1)];
    [self.toolBg setBackgroundColor:color(232, 232, 232, 1)];
    
    UILabel *label=[[UILabel alloc] init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:NSLocalizedString(@"startGame", nil)];
    [label setTextColor:[UIColor blueColor]];
    [label setFont:[UIFont boldSystemFontOfSize:18.0]];
    [_toolBg addSubview:label];

    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *views=NSDictionaryOfVariableBindings(_toolBg,label);
    [_toolBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[label]-10-|" options:0 metrics:0 views:views]];
    [_toolBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label(30)]-2-|" options:0 metrics:0 views:views]];
    
    
    UIButton *picStyleBtn=[[UIButton alloc] init];
    [picStyleBtn setImage:[UIImage imageNamed:@"style"] forState:UIControlStateNormal] ;
    [picStyleBtn setContentMode:UIViewContentModeScaleAspectFit];
    [_toolBg addSubview:picStyleBtn];
    [picStyleBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *picStyleDic=NSDictionaryOfVariableBindings(_toolBg,picStyleBtn);
    [_toolBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[picStyleBtn(40)]-8-|" options:0 metrics:0 views:picStyleDic]];
    [_toolBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[picStyleBtn(40)]-2-|" options:0 metrics:0 views:picStyleDic]];
    [picStyleBtn addTarget:self action:@selector(changePicBrowseStyle) forControlEvents:UIControlEventTouchUpInside];
    
    _picCarousel.delegate=self;
    _picCarousel.dataSource=self;
    
    _picCarousel.type=iCarouselTypeCoverFlow;
  
    NSString *userPicPath=[NSTemporaryDirectory() stringByAppendingPathComponent:@"userPic"];
    NSArray *picUserArray= [[NSFileManager defaultManager] contentsOfDirectoryAtPath:userPicPath error:nil];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF ENDSWITH[cd] 'png' or SELF ENDSWITH[cd] 'jpg'"];
    picUserArray= [picUserArray filteredArrayUsingPredicate:predicate];
    
    _picArrayM=[[NSMutableArray alloc] initWithCapacity:0];
    [_picArrayM addObjectsFromArray:picUserArray];

    
    NSArray *picNamesArray= [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"photos"] error:nil];
    [_picArrayM addObjectsFromArray:picNamesArray];
    

}

-(void)settingAction:(id)sender
{
    SettingViewController *settingVC=[[SettingViewController alloc] init];
    settingVC.imageMemoryPool=self.imageMemoryPool;
    [self.navigationController pushViewController:settingVC animated:YES];
}

-(void)cameraAction:(id)sender
{
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"select", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"camera", nil),NSLocalizedString(@"browser", nil), nil];
    sheet.tag=kTagCameraBrower;
    [sheet showInView:self.view];
}

- (void)cameraPhoto:(UIImage *)image  //选择完图片
{
    ImageFilterProcessViewController *fitler = [[ImageFilterProcessViewController alloc] init];
    [fitler setDelegate:self];
    fitler.currentImage = image;
    [self presentViewController:fitler animated:YES completion:nil];
}

- (void)imageFitlerProcessDone:(UIImage *)image //图片处理完
{
    NSDate *date=[NSDate new];
    NSTimeInterval interval=[date timeIntervalSince1970];
    NSString *path=[NSTemporaryDirectory() stringByAppendingPathComponent:@"userPic"];
    
    NSString *fileName=[NSString stringWithFormat:@"%ld.png",(long)interval];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filePath=[path stringByAppendingPathComponent:fileName];
    NSData *imageData= UIImagePNGRepresentation(image);
    [imageData writeToFile:filePath atomically:YES];

    [_picArrayM insertObject:fileName atIndex:0];
    [_picCarousel reloadData];
}

-(void)changePicBrowseStyle
{
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"selectPicStyle", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) destructiveButtonTitle:nil otherButtonTitles:@"Linear",@"Rotary",@"InvertedRotary",@"Cylinder",@"InvertedCylinder",@"Wheel",@"InvertedWheel",@"CoverFlow",@"CoverFlow2",@"TimeMachine",@"InvertedTimeMachine", nil];
    actionSheet.tag=kTagPicStyle;
    [actionSheet showInView:self.view];
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
    NSString *key= _picArrayM[index];
    if(self.imageMemoryPool[key] !=nil )
    {
        ((UIImageView *)view).image=self.imageMemoryPool[key];
    }
    else {
        NSString *filePath= [[NSBundle mainBundle].resourcePath stringByAppendingString:[NSString stringWithFormat:@"/photos/%@",_picArrayM[index]]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]==NO) {
            filePath=[NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"/userPic/%@",_picArrayM[index]]];
        }
        UIImage *image=[[UIImage alloc] initWithContentsOfFile:filePath];
        ((UIImageView *)view).image=image;
        self.imageMemoryPool[key]=image;
    }
    
    return view;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return 240;
}

#pragma mark - iCarouselDelegate
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    GameViewController *gameBoardVC=[[GameViewController alloc] init];
    gameBoardVC.picName=_picArrayM[index];
    [self.navigationController pushViewController:gameBoardVC animated:YES];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==kTagPicStyle) {
        if (buttonIndex!=11) {
            _picCarousel.type=buttonIndex;
        }
    }
    else if(actionSheet.tag==kTagCameraBrower)
    {
        if (buttonIndex==0) { //camera
            CustomImagePickerController *picker = [[CustomImagePickerController alloc] init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
            }else{
                [picker setIsSingle:YES];
                [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            }
            [picker setCustomDelegate:self];
            [self presentViewController:picker animated:YES completion:nil];
        }
        else if(buttonIndex==1) //online picture
        {
            OnlinePicViewController *onlineVC=[[OnlinePicViewController alloc] init];
            [self.navigationController pushViewController:onlineVC animated:YES];
        }
    }

}
@end
