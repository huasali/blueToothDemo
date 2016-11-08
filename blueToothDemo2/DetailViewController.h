//
//  DetailViewController.h
//  blueToothDemo2
//
//  Created by sensology on 16/9/7.
//  Copyright © 2016年 智觅智能. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SensBlueToothManager.h"
#import "WYCircleView.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) CBPeripheral *detailItem;

@property (nonatomic, strong) CBCharacteristic *characteristic;
@property (nonatomic, strong) CBCharacteristic *characteristic_oad_1;
@property (nonatomic, strong) CBCharacteristic *characteristic_oad_2;
@property (nonatomic, strong) CBCharacteristic *characteristic_data_1;
@property (nonatomic, strong) CBCharacteristic *characteristic_data_2;

@property (weak, nonatomic) IBOutlet UITextField *sendText;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
- (IBAction)sendAction:(id)sender;

@property (weak, nonatomic) IBOutlet WYCircleView *textView;



@end

