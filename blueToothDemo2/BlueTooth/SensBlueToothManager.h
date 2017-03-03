//
//  SensBlueToothManager.h
//  sensologyHome
//
//  Created by sensology on 16/8/25.
//  Copyright © 2016年 李建华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonHead.h"
#import <CoreBluetooth/CoreBluetooth.h>

#define SensBlueManaged [SensBlueToothManager sharedSensBlueToothManager]

#define BT_OAD_SERVICE										@"F000FFC0-0451-4000-B000-000000000000"
#define BT_OAD_IMAGE_NOTIFY									@"F000FFC1-0451-4000-B000-000000000000"
#define BT_OAD_IMAGE_BLOCK_REQUEST							@"F000FFC2-0451-4000-B000-000000000000"
#define BT_DATA_IMAGE_NOTIFY							    @"F000FFA1-0451-4000-B000-000000000000"
#define BT_DATA_IMAGE_BLOCK_REQUEST							@"F000FFA2-0451-4000-B000-000000000000"
#define BLE_SEND_MAX_LEN 20


@protocol SensBlueToothDelegate <NSObject>

@optional

//peripheral
- (void)sensBlueToothSearchPeripheral:(CBPeripheral *)peripheral;
//peripheral.services
- (void)sensBlueToothSearchService:(CBPeripheral *)peripheral;
//service.characteristics
- (void)sensBlueToothSearchCharacteristics:(CBService *)service andPer:(CBPeripheral *)peripheral;
//characteristic.descriptors
- (void)sensBlueToothSearchDescriptors:(CBCharacteristic *)characteristic andPer:(CBPeripheral *)peripheral;
//[characteristic.value bytes]
- (void)readValueWithCharacteristics:(CBCharacteristic *)characteristic andPer:(CBPeripheral *)peripheral;
//[descriptor value]
- (void)readValueWithDescriptors:(CBDescriptor *)descriptor andPer:(CBPeripheral *)peripheral;
//WriteValue
- (void)didWriteValueWithCharacteristic:(CBCharacteristic *)characteristic andPer:(CBPeripheral *)peripheral;
//UpdateNotification
- (void)didUpdateNotificationWithCharacteristic:(CBCharacteristic *)characteristic andPer:(CBPeripheral *)peripheral;

//连接成功
- (void)sensBlueToothConnectSuccessWithPeripheral:(CBPeripheral *)peripheral;
//连接失败
- (void)sensBlueToothConnectFailWithPeripheral:(CBPeripheral *)peripheral;
//连接断开
- (void)sensBlueToothConnectDisWithPeripheral:(CBPeripheral *)peripheral;

@end

@interface SensBlueToothManager : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>{
    
    //主设备
    CBCentralManager *centralManager;
}

single_interface(SensBlueToothManager)

@property (nonatomic, strong) NSMutableArray *observeArr;
@property (nonatomic, weak) id <SensBlueToothDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *connectArr;
@property (nonatomic, strong) NSMutableDictionary *canConnectDic;

/**
 *  初始化参数,增加代理
 */
- (void)initBlueTooth;
/**
 *  增加事件监听
 *
 *  @param observe 代理
 */
- (void)addObserve:(id)observe;
/**
 *  移除事件监听
 *
 *  @param observe 代理
 */
- (void)removeObserve:(id)observe;
/**
 *  开始扫描
 */
- (void)startScan;
- (BOOL)isScaning;
/**
 *  停止扫描
 */
- (void)stopScan;
/**
 *  断开全部
 */
- (void)disConnectAll;
/**
 *  断开指定的蓝牙
 *
 */
- (void)disConnectWithPer:(CBPeripheral *)peripheral;
/**
 *  连接指定的蓝牙,包括读
 *
 */
- (void)connectWithPer:(CBPeripheral *)peripheral;
- (void)readWithPer:(CBPeripheral *)peripheral;
@end


