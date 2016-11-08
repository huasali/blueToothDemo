//
//  MasterViewController.m
//  blueToothDemo2
//
//  Created by sensology on 16/9/7.
//  Copyright © 2016年 智觅智能. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"


@interface MasterViewController ()<SensBlueToothDelegate>{
    
     NSMutableDictionary *connectDic;
    

}

@property NSMutableArray *objects;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    connectDic = [[NSMutableDictionary alloc]init];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SensBlueManaged removeObserve:self];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [SensBlueManaged addObserve:self];
    [SensBlueManaged connectWithPer:self.detailItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CBCharacteristic *characteristic = [connectDic allValues][indexPath.row];
        DetailViewController *controller = segue.destinationViewController;
        [controller setCharacteristic:characteristic];
        [controller setCharacteristic_oad_1:connectDic[BT_OAD_IMAGE_NOTIFY]];
        [controller setCharacteristic_oad_2:connectDic[BT_OAD_IMAGE_BLOCK_REQUEST]];
        [controller setCharacteristic_data_1:connectDic[BT_DATA_IMAGE_NOTIFY]];
        [controller setCharacteristic_data_2:connectDic[BT_DATA_IMAGE_BLOCK_REQUEST]];
        [controller setDetailItem:self.detailItem];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[connectDic allValues] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *nameStr = [connectDic allKeys][indexPath.row];
    CBCharacteristic *characteristic = [connectDic allValues][indexPath.row];
    cell.textLabel.text = nameStr;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",characteristic.UUID];
    return cell;
}


#pragma mark SensBlueTooth


//service.characteristics
- (void)sensBlueToothSearchCharacteristics:(CBService *)service andPer:(CBPeripheral *)peripheral{
    for (CBCharacteristic *characteristic in service.characteristics) {
        if (!connectDic) {
            connectDic = [[NSMutableDictionary alloc]init];
        }
        [connectDic setValue:characteristic forKey:characteristic.UUID.UUIDString];
        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    }
    [self.tableView reloadData];

}

@end
