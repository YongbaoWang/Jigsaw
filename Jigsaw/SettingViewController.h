//
//  SettingViewController.h
//  Jigsaw
//
//  Created by Ever on 15/1/31.
//  Copyright (c) 2015年 Ever. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enum.h"

@interface SettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end
