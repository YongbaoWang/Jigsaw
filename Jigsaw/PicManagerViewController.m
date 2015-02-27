//
//  PicManagerViewController.m
//  Jigsaw
//
//  Created by Ever on 15/2/26.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import "PicManagerViewController.h"
#import "PicCollectionViewCell.h"

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

    for (int i=0; i<30; i++) {
        [self.picArrayM addObject:[NSString stringWithFormat:@"%d.jpg",i]];
    }
    
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
    cell.image=[UIImage imageNamed:_picArrayM[indexPath.row]];
    NSString *key=[NSString stringWithFormat:@"%d",indexPath.row];
    id value= [_selectedDic objectForKey:key];
    if (value!=nil && [value boolValue]==YES) {
        cell.checked=YES;
    }
    else {
        cell.checked=NO;
    }
    [cell.contentView setBackgroundColor:[UIColor blueColor]];
    [cell setBackgroundColor:[UIColor redColor]];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PicCollectionViewCell *cell=(PicCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *key=[NSString stringWithFormat:@"%d",indexPath.row];
    id value= [self.selectedDic objectForKey:key];
    if (value!=nil && [value boolValue]==YES) {
        _selectedDic[key]=[NSNumber numberWithBool:NO];
        cell.checked=NO;
    }
    else {
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
