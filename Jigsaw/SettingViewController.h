//
//  SettingViewController.h
//  Jigsaw
//
//  Created by Ever on 15/1/31.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kGameEasy,
    kGameMedium,
    kGameHard,
} GameLevel;

@interface SettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;



@end
