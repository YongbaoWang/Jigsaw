//
//  MainViewController.h
//  Jigsaw
//
//  Created by Ever on 15/1/31.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "CustomImagePickerController.h"
#import "ImageFilterProcessViewController.h"

@interface MainViewController : UIViewController<UIActionSheetDelegate,CustomImagePickerControllerDelegate,ImageFitlerProcessDelegate>

@property (strong, nonatomic) IBOutlet UIView *toolBg;
@property (strong, nonatomic) IBOutlet iCarousel *picCarousel;

@end
