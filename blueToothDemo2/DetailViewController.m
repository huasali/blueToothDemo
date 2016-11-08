//
//  DetailViewController.m
//  blueToothDemo2
//
//  Created by sensology on 16/9/7.
//  Copyright © 2016年 智觅智能. All rights reserved.
//

#import "DetailViewController.h"
#import "AlertShowView.h"

@interface DetailViewController ()<UITextFieldDelegate>{
    NSData *oad_A_Data;
    NSData *oad_B_Data;
    NSData *seleData;
    NSData *oadData;
    NSDate *countTime;
    NSTimer *sendTime;
    long x;
    long maxCount;
    
}

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
    }
}

- (void)configureView {
    if (self.detailItem) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"%@",self.characteristic.UUID];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [SensBlueManaged addObserve:self];
    NSString *filePathA = [[NSBundle mainBundle] pathForResource:@"ImageA1013"    ofType:@"bin"];
    NSString *filePathB = [[NSBundle mainBundle] pathForResource:@"ImageB1012"   ofType:@"bin"];
    NSString *filePathD = [[NSBundle mainBundle] pathForResource:@"Myos_Private" ofType:@"bin"];

    oad_A_Data = [NSData dataWithContentsOfFile:filePathA];
    oad_B_Data = [NSData dataWithContentsOfFile:filePathB];
    seleData   = [NSData dataWithContentsOfFile:filePathD];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SensBlueManaged removeObserve:self];
}

//WriteValue
- (void)didWriteValueWithCharacteristic:(CBCharacteristic *)characteristic andPer:(CBPeripheral *)peripheral{
    NSLog(@"\ndidWrite%@",characteristic.value);
    //self.detailDescriptionLabel.text = [characteristic.value description];
//    [self.detailItem readValueForCharacteristic:characteristic];
}
//UpdateNotification
- (void)didUpdateNotificationWithCharacteristic:(CBCharacteristic *)characteristic andPer:(CBPeripheral *)peripheral{
    NSLog(@"\nUpdateNotification-%@",characteristic.value);
    //self.detailDescriptionLabel.text = [characteristic.value description];
}

//[characteristic.value bytes]
- (void)readValueWithCharacteristics:(CBCharacteristic *)characteristic andPer:(CBPeripheral *)peripheral{
    NSLog(@"\nreadValue-%@",characteristic.value);
    if (self.sendText.text.length > 0&&[self.characteristic.UUID.UUIDString isEqualToString:characteristic.UUID.UUIDString]) {
        [[AlertShowView sharedInstance] showInView:self.view andMessage:[NSString stringWithFormat:@"%@",characteristic.value] andTime:10.0];
    }
    else{
        if ([characteristic.UUID.UUIDString isEqualToString:BT_OAD_IMAGE_NOTIFY]) {
            if (characteristic.value) {
                [self compareVerWithCharacteristics:characteristic];
            }
        }
        else if ([characteristic.UUID.UUIDString isEqualToString:BT_OAD_IMAGE_BLOCK_REQUEST]){
            if (characteristic.value) {
                [self.detailItem setNotifyValue:NO forCharacteristic:characteristic];
                [self startSendData];
                //[self sendDataWithCharacteristics:characteristic];
            }
        }
        else if ([characteristic.UUID.UUIDString isEqualToString:BT_DATA_IMAGE_NOTIFY]){
            if (characteristic.value) {
                
            }
        }
        else if ([characteristic.UUID.UUIDString isEqualToString:BT_DATA_IMAGE_BLOCK_REQUEST]){
            if (characteristic.value) {
                //[self.detailItem setNotifyValue:NO forCharacteristic:characteristic];
                //[self startSendData];
                [self sendDataWithCharacteristics:characteristic];
            }
        }

    }
   
}

- (void)compareVerWithCharacteristics:(CBCharacteristic *)characteristic{
    Byte *Cvalue = (Byte *)[characteristic.value bytes];
    Byte *Dvalue = (Byte *)[oadData bytes];
    if ((Cvalue[0] & 0x01) != ( Dvalue[4] & 0x01)) {
        NSLog(@"可以升级");
        x = 0;
        
        Byte byte[] = {Dvalue[4],Dvalue[5],Dvalue[6],Dvalue[7],Dvalue[8],Dvalue[9],Dvalue[10],Dvalue[11]};
        NSData *sendData = [NSData dataWithBytes:byte length:sizeof(byte)];
        NSLog(@"%@",sendData);

        [self.detailItem writeValue:sendData forCharacteristic:self.characteristic_oad_1 type:CBCharacteristicWriteWithResponse];
    }
    else{
        [[AlertShowView sharedInstance] showInView:self.view andMessage:@"版本相同"];
    }
}

- (void)sendDataWithCharacteristics:(CBCharacteristic *)characteristic{
    Byte *Dvalue = (Byte *)[seleData bytes];
    Byte *Cvalue = (Byte *)[characteristic.value bytes];

    
    if ((Cvalue[0] + Cvalue[1]) == 0) {
        long length = maxCount*16;
        Byte byte[] = {0x00,0x00,length%256,(long)(length/256),(long)(length/(256*256)),(long)(length/(256*256*256)),0x00,0x01,0x01,0x01,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
        NSData *data = [NSData dataWithBytes:byte length:sizeof(byte)];
        NSLog(@"发的数据-%@",data);
        [self.detailItem writeValue:data forCharacteristic:self.characteristic_data_2 type:CBCharacteristicWriteWithResponse];
    }
    else{
        Byte byte[18];
        //            byte[i] = Dvalue[i - 2 + x*16];
        for (int i = 0; i < 18; i++) {
            if (i <= 1 ) {
                byte[0] = Cvalue[0];
                byte[1] = Cvalue[1];
            }
            else{
                
                if (i - 2 + x*16 < seleData.length) {
                    byte[i] = Dvalue[i - 2 + x*16];
                }
                else{
                    byte[i] = 0xFF;
                }
                
            }
            
        }
        NSData *sendData = [NSData dataWithBytes:byte length:sizeof(byte)];
        NSLog(@"\n%ld - %@",x,sendData);
        x++;
        float sendValue = (float)x/(float)maxCount;
        self.textView.titleL.text = [NSString stringWithFormat:@"%.2f%%",sendValue*100];
        [self.textView setCCCount:sendValue];

        [self.detailItem writeValue:sendData forCharacteristic:self.characteristic_data_2 type:CBCharacteristicWriteWithResponse];
        
        if (x >= maxCount) {
            NSString *timeStr = [NSString stringWithFormat:@"升级完毕 时间%f",[[NSDate date] timeIntervalSinceDate:countTime]];
            NSLog(@"%@",timeStr);
            self.textView.titleL.text = [NSString stringWithFormat:@"%.2fS",[[NSDate date] timeIntervalSinceDate:countTime]];
            [self.textView setCCCount:1.0];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendAction:(id)sender {
    
    if (self.sendText.text.length > 0) {
        int leng = (int)self.sendText.text.length/2;
        Byte byte[leng];
        for (int i = 0; i < leng; i++) {
            NSString *subStr = [self.sendText.text substringWithRange:NSMakeRange(2*i,2)];
            byte[i] = [self getCharWithStr:subStr];
        }
        NSData *data = [NSData dataWithBytes:byte length:sizeof(byte)];
        [self.detailItem writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    }
    else{
        
        countTime = [NSDate date];
        [[AlertShowView sharedInstance] showSheetWithTitle:@"TYPE" andButton:@[@"OAD",@"DATA"] andEnventBlock:^(NSInteger row, NSString *title) {
            if (row == 1) {
                [[AlertShowView sharedInstance] showSheetWithTitle:@"TYPE" andButton:@[@"A",@"B"] andEnventBlock:^(NSInteger row, NSString *title) {
                    if (row == 1) {
                        oadData = oad_A_Data;
                        [self sendBlueToothUP];
                    }
                    else if (row == 2) {
                        oadData = oad_B_Data;
                        [self sendBlueToothUP];
                    }
                }];
            }
            else if (row == 2) {
                [self sendDataUP];
            }
        }];
    }
}


- (void)sendBlueToothUP{
    
    if (!self.characteristic_oad_1||!self.characteristic_oad_2) {
        [[AlertShowView sharedInstance] showMessage:@"通道错误"];
        return;
    }
    
    NSString *sendStr = self.sendText.text;
    NSData *data;
    if (sendStr.length > 0) {
        int leng = (int)self.sendText.text.length/2;
        Byte byte[leng];
        for (int i = 0; i < leng; i++) {
            NSString *subStr = [sendStr substringWithRange:NSMakeRange(2*i,2)];
            byte[i] = [self getCharWithStr:subStr];
        }
        data = [NSData dataWithBytes:byte length:sizeof(byte)];
    }
    else{
        Byte byte[] = {};
        data = [NSData dataWithBytes:byte length:sizeof(byte)];
    }
    NSLog(@"%@",data);
    [self.detailItem writeValue:data forCharacteristic:self.characteristic_oad_1 type:CBCharacteristicWriteWithResponse];
}

- (void)sendDataUP{
    if (!self.characteristic_data_1||!self.characteristic_data_2) {
        [[AlertShowView sharedInstance] showMessage:@"通道错误"];
        return;
    }
    x = 0;
    maxCount = (long)(seleData.length/16);
    
    if (seleData.length%16 != 0) {
        maxCount = maxCount + 1;
    }
    long length = maxCount*16;
    Byte byte[] = {length%256,(long)(length/256),(long)(length/(256*256)),(long)(length/(256*256*256)),0x00,0x01,0x01,0x01,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
    NSData *data = [NSData dataWithBytes:byte length:sizeof(byte)];
    NSLog(@"发的数据-%@",data);
    [self.detailItem writeValue:data forCharacteristic:self.characteristic_data_1 type:CBCharacteristicWriteWithResponse];

}


- (void)startSendData{
    if (!sendTime) {
        x = 0;
        sendTime = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(sendData:) userInfo:nil repeats:YES];
    }
}

- (void)sendData:(NSTimer *)t{
    
    Byte *Dvalue = (Byte *)[oadData bytes];
    Byte byte[18];
    for (int i = 0; i < 18; i++) {
        if (i <= 1 ) {
            byte[0] = x%256;
            byte[1] = x/256;
        }
        else{
            if (i - 2 + x*16 < oadData.length) {
                byte[i] = Dvalue[i - 2 + x*16];
            }
            else{
                byte[i] = 0xFF;
            }
            
        }
    }
    
    NSData *sendData = [NSData dataWithBytes:byte length:sizeof(byte)];
    NSLog(@"\n%ld - \n%@",x,sendData);
    [self.detailItem writeValue:sendData forCharacteristic:self.characteristic_oad_2 type:CBCharacteristicWriteWithoutResponse];
    x++;
    
    float sendValue = (float)x*16/(float)oadData.length;
    self.textView.titleL.text = [NSString stringWithFormat:@"%.2f%%",sendValue*100];
    [self.textView setCCCount:sendValue];
    
   // self.detailDescriptionLabel.text = [NSString stringWithFormat:@"数据传输%.6f",(float)x*16/(float)oadData.length];
    if (x*16 >= oadData.length) {
        [sendTime invalidate];
        self.textView.titleL.text = [NSString stringWithFormat:@"%.2fS",[[NSDate date] timeIntervalSinceDate:countTime]];
        [self.textView setCCCount:1.0];
        NSString *timeStr = [NSString stringWithFormat:@"升级完毕 时间%f",[[NSDate date] timeIntervalSinceDate:countTime]];
        NSLog(@"%@",timeStr);
       // self.detailDescriptionLabel.text = timeStr;
    }
    

}

- (char)getCharWithStr:(NSString *)str
{
    int s = [str intValue];
    if (s>= 0 && s < 10)
    {
        return 48 + s;
    }else if (s >= 10 && s <37)
    {
        return 55 + s;
    }else if (s >= 38 && s< 65)
    {
        return 59 + s;
    }else
    {
        return 0;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
