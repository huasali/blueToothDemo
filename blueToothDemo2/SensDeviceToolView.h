//
//  SensDeviceToolView.h
//  sensologyHome
//
//  Created by sensology on 16/8/23.
//  Copyright © 2016年 李建华. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Device;

typedef void(^ResultBlock)(NSInteger row ,id infoDic);

@interface SensDeviceToolView : UIView


@property (nonatomic, copy) ResultBlock resultBlock;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *detailL;

- (void)setInfoValue:(Device *)value;

@end
