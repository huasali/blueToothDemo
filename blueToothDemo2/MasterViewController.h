//
//  MasterViewController.h
//  blueToothDemo2
//
//  Created by sensology on 16/9/7.
//  Copyright © 2016年 智觅智能. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SensBlueToothManager.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) CBPeripheral *detailItem;

@property (strong, nonatomic) DetailViewController *detailViewController;


@end

