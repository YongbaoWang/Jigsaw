//
//  PicManagerViewController.m
//  Jigsaw
//
//  Created by Ever on 15/2/26.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import "PicManagerViewController.h"
#import "PicCollectionViewCell.h"
#import "UIImage+Cut.h"

@interface PicManagerViewController ()

@property(nonatomic,strong)NSMutableArray *selectedArray;
@property(nonatomic,strong)NSMutableArray *picArrayM;

@end

@implementation PicManagerViewController

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
    self.navigationItem.title=NSLocalizedString(@"pictureManage", nil);
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView registerClass:[PicCollectionViewCell class] forCellWithReuseIdentifier:@"myCollectionCell"];
    
    UIBarButtonItem *deleteBarBtn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deletePicture)];
    self.navigationItem.rightBarButtonItem=deleteBarBtn;

//    for (int i=0; i<30; i++) {
//        [self.picArrayM addObject:[NSString stringWithFormat:@"%d.jpg",i]];
//    }
    
    NSString *userPicPath=[NSTemporaryDirectory() stringByAppendingPathComponent:@"userPic"];
    NSArray *picUserArray= [[NSFileManager defaultManager] contentsOfDirectoryAtPath:userPicPath error:nil];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF ENDSWITH[cd] 'png' or SELF ENDSWITH[cd] 'jpg'"];
    picUserArray= [picUserArray filteredArrayUsingPredicate:predicate];
    
    _picArrayM=[[NSMutableArray alloc] initWithCapacity:0];
    [_picArrayM addObjectsFromArray:picUserArray];
    
    
    NSArray *picNamesArray= [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"photos"] error:nil];
    [_picArrayM addObjectsFromArray:picNamesArray];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //收到内存警告时，释放图片缓存池
    [self.imageMemoryPool removeAllObjects];
}

-(void)deletePicture
{
    for (NSString *picName in _selectedArray) {
        [self.imageMemoryPool  removeObjectForKey:picName];
        [_picArrayM removeObject:picName];

        [[NSNotificationCenter defaultCenter] postNotificationName:PicRemoveNotification object:picName];
        
        NSString *filePath= [[NSBundle mainBundle].resourcePath stringByAppendingString:[NSString stringWithFormat:@"/photos/%@",picName]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]==NO) {
            filePath=[NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"/userPic/%@",picName]];
        }
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    [self.selectedArray removeAllObjects];
    [self.collectionView reloadData];
}

#pragma mark - lazy loading
-(NSMutableArray *)selectedArray
{
    if (_selectedArray==nil) {
        _selectedArray=[[NSMutableArray alloc] initWithCapacity:0];
    }
    return _selectedArray;
}

-(NSMutableArray *)picArrayM
{
    if (_picArrayM==nil) {
        _picArrayM=[[NSMutableArray alloc] initWithCapacity:0];
    }
    return _picArrayM;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _picArrayM.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity=@"myCollectionCell";
    PicCollectionViewCell *cell=(PicCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identity forIndexPath:indexPath];
    [self refreshCell:cell forItemAtIndexPath:indexPath];
    return cell;
}

-(void)refreshCell:(PicCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key=_picArrayM[indexPath.row];
    if (self.imageMemoryPool[key]!=nil) {
//        cell.image=[((UIImage *)self.imageMemoryPool[key]) clipImageWithScaleWithsize:CGSizeMake(100, 100)];//影响效率
        cell.image=self.imageMemoryPool[key];
    }
    else
    {
        NSString *filePath= [[NSBundle mainBundle].resourcePath stringByAppendingString:[NSString stringWithFormat:@"/photos/%@",_picArrayM[indexPath.row]]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]==NO) {
            filePath=[NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"/userPic/%@",_picArrayM[indexPath.row]]];
        }
        UIImage *image= [[UIImage alloc] initWithContentsOfFile:filePath];
//        image=[image clipImageWithScaleWithsize:CGSizeMake(100, 100)];//影响效率
        cell.image=image;
        self.imageMemoryPool[key]=image;
    }
    if ([self.selectedArray containsObject:_picArrayM[indexPath.row]]) {
        cell.checked=YES;
    }
    else {
        cell.checked=NO;
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PicCollectionViewCell *cell=(PicCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    if ([self.selectedArray containsObject:_picArrayM[indexPath.row]])
    {
        [self.selectedArray removeObject:_picArrayM[indexPath.row]];
        cell.checked=NO;
    }
    else
    {
        [self.selectedArray addObject:_picArrayM[indexPath.row]];
        cell.checked=YES;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

@end
