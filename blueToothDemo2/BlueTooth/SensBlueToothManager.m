//
//  SensBlueToothManager.m
//  sensologyHome
//
//  Created by sensology on 16/8/25.
//  Copyright © 2016年 李建华. All rights reserved.
//

#import "SensBlueToothManager.h"
#import "AlertShowView.h"

@interface SensBlueToothManager (){
    BOOL isScan;
    NSTimer *stateTime;
}

@end

@implementation SensBlueToothManager

single_implementation(SensBlueToothManager)

- (void)initBlueTooth{

    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             //蓝牙power没打开时alert提示框
                             [NSNumber numberWithBool:YES],CBCentralManagerOptionShowPowerAlertKey,
                             //重设centralManager恢复的IdentifierKey
                             @"babyBluetoothRestore",CBCentralManagerOptionRestoreIdentifierKey,
                             nil];
    NSArray *backgroundModes = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"UIBackgroundModes"];
    if ([backgroundModes containsObject:@"bluetooth-central"]) {
        //后台模式
        centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil options:options];
    }else{
        //非后台模式
        centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    }
    isScan = NO;

}

- (void)startScan{
    isScan = YES;
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    [centralManager scanForPeripheralsWithServices:nil options:scanForPeripheralsWithOptions];
}

- (BOOL)isScaning{
    return [centralManager isScanning];
}

- (void)stopScan{
    isScan = NO;
    [centralManager stopScan];
}

- (void)disConnectAll{
    for (int i=0;i<self.connectArr.count;i++) {
        [centralManager cancelPeripheralConnection:self.connectArr[i]];
    }
}
-(void)disConnectWithPer:(CBPeripheral *)peripheral{
    [centralManager cancelPeripheralConnection:peripheral];
}

- (void)connectWithPer:(CBPeripheral *)peripheral{
    if (peripheral) {
        [centralManager connectPeripheral:peripheral options:nil];
    }
}

- (void)readWithPer:(CBPeripheral *)peripheral{
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

- (void)addObserve:(id)observe{
    if (!observe) {
        return;
    }
    if (![self.observeArr containsObject:observe]) {
        [self.observeArr addObject:observe];
    }
}

- (void)removeObserve:(id)observe{
    if (!observe) {
        return;
    }
    if ([self.observeArr containsObject:observe]) {
        [self.observeArr removeObject:observe];
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@">>>CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@">>>CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@">>>CBCentralManagerStateUnsupported");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@">>>CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@">>>CBCentralManagerStatePoweredOff");
            [[AlertShowView sharedInstance] showMessage:@"蓝牙已断开"];
            break;
        case CBCentralManagerStatePoweredOn:{
            NSLog(@">>>CBCentralManagerStatePoweredOn");
            if (isScan) {
                [self startScan];
            }
        }
            break;
        default:
            break;
    }

}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict{
    
}

//扫描到Peripherals
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI{
    if (peripheral.name.length <= 0) {
        NSLog(@"peripheral = %@",peripheral);
        return;
    }
    for (id delegate in self.observeArr) {
        if (delegate&&[delegate respondsToSelector:@selector(sensBlueToothSearchPeripheral:)]) {
            [delegate sensBlueToothSearchPeripheral:peripheral];
        }
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(sensBlueToothSearchPeripheral:)]) {
        [self.delegate sensBlueToothSearchPeripheral:peripheral];
    }
}

//连接到Peripherals-成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    if (![self.connectArr containsObject:peripheral]) {
        [self.connectArr addObject:peripheral];
    }
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
    NSLog(@"%@---连接成功",peripheral.name);
    for (id delegate in self.observeArr) {
        if (delegate&&[delegate respondsToSelector:@selector(sensBlueToothConnectSuccessWithPeripheral:)]) {
            [delegate sensBlueToothConnectSuccessWithPeripheral:peripheral];
        }
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(sensBlueToothConnectSuccessWithPeripheral:)]) {
        [self.delegate sensBlueToothConnectSuccessWithPeripheral:peripheral];
    }
}

//连接到Peripherals-失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(sensBlueToothConnectFailWithPeripheral:)]) {
        [self.delegate sensBlueToothConnectFailWithPeripheral:peripheral];
    }
}

//Peripherals断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    NSLog(@"%@断开连接",peripheral.name);
    [[AlertShowView sharedInstance] showMessage:[NSString stringWithFormat:@"%@-连接断开",peripheral.name]];
    if ([self.connectArr containsObject:peripheral]) {
        [self.connectArr removeObject:peripheral];
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(sensBlueToothConnectDisWithPeripheral:)]) {
        [self.delegate sensBlueToothConnectDisWithPeripheral:peripheral];
    }
    for (id delegate in self.observeArr) {
        if (delegate&&[delegate respondsToSelector:@selector(sensBlueToothConnectDisWithPeripheral:)]) {
            [delegate sensBlueToothConnectDisWithPeripheral:peripheral];
        }
    }
}

//扫描到服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error{
    for (id delegate in self.observeArr) {
        if (delegate&&[delegate respondsToSelector:@selector(sensBlueToothSearchService:)]) {
            [delegate sensBlueToothSearchService:peripheral];
        }
    }
    for (CBService *ser in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:ser];
    }

}

//发现服务的Characteristics
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error{
    NSLog(@"\n\n\n%@",service.characteristics);
    for (id delegate in self.observeArr) {
        if (delegate&&[delegate respondsToSelector:@selector(sensBlueToothSearchCharacteristics:andPer:)]) {
            [delegate sensBlueToothSearchCharacteristics:service andPer:peripheral];
        }
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(sensBlueToothSearchCharacteristics:andPer:)]) {
        [self.delegate sensBlueToothSearchCharacteristics:service andPer:peripheral];
    }
}

//读取Characteristics的值
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    for (id delegate in self.observeArr) {
        if (delegate&&[delegate respondsToSelector:@selector(readValueWithCharacteristics:andPer:)]) {
            [delegate readValueWithCharacteristics:characteristic andPer:peripheral];
        }
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(readValueWithCharacteristics:andPer:)]) {
        [self.delegate readValueWithCharacteristics:characteristic andPer:peripheral];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    for (id delegate in self.observeArr) {
        if (delegate&&[delegate respondsToSelector:@selector(didWriteValueWithCharacteristic:andPer:)]) {
            [delegate didWriteValueWithCharacteristic:characteristic andPer:peripheral];
        }
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didWriteValueWithCharacteristic:andPer:)]) {
        [self.delegate didWriteValueWithCharacteristic:characteristic andPer:peripheral];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    //[peripheral readValueForCharacteristic:characteristic];
    for (id delegate in self.observeArr) {
        if (delegate&&[delegate respondsToSelector:@selector(didUpdateNotificationWithCharacteristic:andPer:)]) {
            [delegate didUpdateNotificationWithCharacteristic:characteristic andPer:peripheral];
        }
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didUpdateNotificationWithCharacteristic:andPer:)]) {
        [self.delegate didUpdateNotificationWithCharacteristic:characteristic andPer:peripheral];
    }
}




- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral NS_AVAILABLE(NA, 6_0){
    
}

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray<CBService *> *)invalidatedServices NS_AVAILABLE(NA, 7_0){
    
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(nullable NSError *)error NS_DEPRECATED(NA, NA, 5_0, 8_0){
    
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error NS_AVAILABLE(NA, 8_0){
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(nullable NSError *)error{
    
}

//发现Characteristics的Descriptors
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    for (id delegate in self.observeArr) {
        if (delegate&&[delegate respondsToSelector:@selector(sensBlueToothSearchDescriptors:andPer:)]) {
            [delegate sensBlueToothSearchDescriptors:characteristic andPer:peripheral];
        }
    }
}

//读取Characteristics的Descriptors的值
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error{
    for (id delegate in self.observeArr) {
        if (delegate&&[delegate respondsToSelector:@selector(sensBlueToothSearchService:)]) {
            [delegate sensBlueToothSearchService:peripheral];
        }
    }
}


- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error{
    
}
- (NSMutableArray *)observeArr{
    if (!_observeArr) {
        _observeArr = [[NSMutableArray alloc]init];
    }
    return _observeArr;
}

- (NSMutableArray *)connectArr{
    if (!_connectArr) {
        _connectArr = [[NSMutableArray alloc]init];
    }
    return _connectArr;
}

- (NSMutableDictionary *)canConnectDic{
    if (!_canConnectDic) {
        _canConnectDic = [[NSMutableDictionary alloc]init];
    }
    return _canConnectDic;
}

@end



