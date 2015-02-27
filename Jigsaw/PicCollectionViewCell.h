//
//  PicCollectionViewCell.h
//  Jigsaw
//
//  Created by Ever on 15/2/26.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicCollectionViewCell : UICollectionViewCell


/**
 *  cell显示图片
 */
@property(nonatomic,strong)UIImage *image;
/**
 *  当前cell是否选中
 */
@property(nonatomic,assign)BOOL checked ;

@end
