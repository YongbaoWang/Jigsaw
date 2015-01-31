//
//  UIView+CaptureView.h
//  Jigsaw
//
//  Created by Ever on 15/1/31.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CaptureView)

/**
 *  截取指定部分图案
 *
 *  @param frame 指定部分
 *
 *  @return 指定部分的截图
 */
-(UIImage*)captureViewWithFrame:(CGRect)frame;

@end
