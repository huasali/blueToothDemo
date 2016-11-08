//
//  WYCircleView.h
//  weiyun
//
//  Created by taojin on 16/2/23.
//  Copyright © 2016年 Ucskype. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WYCircleStateDelegate <NSObject>

- (void)finishOneCircle;

@end

@interface WYCircleView : UIView

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, weak) id <WYCircleStateDelegate> delegate;

- (void)startAnimate;
- (void)stopAnimate;
- (void)reloadStartAnimate;
- (void)showAnimateWithCount:(int)coun;
- (void)setCCCount:(float)cccount;
@end
