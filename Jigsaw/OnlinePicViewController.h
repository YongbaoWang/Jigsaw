//
//  OnlinePicViewController.h
//  Jigsaw
//
//  Created by Ever on 15/3/5.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlinePicViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *picWebView;

- (IBAction)backAction:(id)sender;
- (IBAction)forwardAction:(id)sender;
- (IBAction)refreshAction:(id)sender;
- (IBAction)loadPicAction:(id)sender;


@end
