//
//  BlueDeviceTableViewController.m
//  blueToothDemo2
//
//  Created by sensology on 16/9/7.
//  Copyright © 2016年 智觅智能. All rights reserved.
//

#import "BlueDeviceTableViewController.h"
#import "SensBlueToothManager.h"
#import "DetailViewController.h"
#import "MasterViewController.h"


@interface BlueDeviceTableViewController ()<SensBlueToothDelegate,UISplitViewControllerDelegate>{
    
}

@property NSMutableArray *objects;

@end



@implementation BlueDeviceTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    SensBlueManaged.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [SensBlueManaged disConnectAll];
    [SensBlueManaged startScan];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SensBlueManaged stopScan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.objects count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    CBPeripheral *peripheral = self.objects[indexPath.row];
    cell.textLabel.text = peripheral.name;
    cell.detailTextLabel.text = peripheral.identifier.UUIDString;
    return cell;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showSplit"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CBPeripheral *peripheral = self.objects[indexPath.row];
        MasterViewController *controller = segue.destinationViewController;
        [controller setDetailItem:peripheral];
    }
}

#pragma mark SensBlueTooth


//peripheral
- (void)sensBlueToothSearchPeripheral:(CBPeripheral *)peripheral{
    
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    if (![self.objects containsObject:peripheral]) {
        [self.objects insertObject:peripheral atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}


@end
