//
//  PicManagerViewController.h
//  Jigsaw
//
//  Created by Ever on 15/2/26.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicManagerViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;


@end
