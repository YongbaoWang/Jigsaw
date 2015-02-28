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

@property(nonatomic,strong)NSMutableDictionary *selectedDic;
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
    self.navigationItem.title=@"图片管理";
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
}

-(void)deletePicture
{
    NSArray *deleteIndex=[_selectedDic allKeys];
    for (NSString *picIndex in deleteIndex) {
        [_picArrayM removeObjectAtIndex:picIndex.integerValue];
        NSNumber *key=[NSNumber numberWithInteger:picIndex.integerValue];
#warning 删除的图片不对,  写个例子，来验证一下数组和字典，删除后，各个元素的排列顺序。
        [self.imageMemoryPool removeObjectForKey:key];
    }
    [_selectedDic removeAllObjects];
    [self.collectionView reloadData];
}

#pragma mark - lazy loading
-(NSMutableDictionary *)selectedDic
{
    if (_selectedDic==nil) {
        _selectedDic=[[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _selectedDic;
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
    NSNumber *key=[NSNumber numberWithInteger:indexPath.row];
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
    id value= self.selectedDic[key];
    if (value!=nil && [value boolValue]==YES) {
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
    NSNumber *key=[NSNumber numberWithInteger:indexPath.row];
    id value= self.selectedDic[key];
    if (value!=nil && [value boolValue]==YES) {
        _selectedDic[key]=[NSNumber numberWithBool:NO];
        cell.checked=NO;
    }
    else
    {
        _selectedDic[key]=[NSNumber numberWithBool:YES];
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
