//
//  WYCircleView.m
//  weiyun
//
//  Created by taojin on 16/2/23.
//  Copyright © 2016年 Ucskype. All rights reserved.
//

#import "WYCircleView.h"

@implementation WYCircleView{
    int count;
    NSTimer *myTime;
    CGFloat ccx;
    CGFloat ccy;
    CGFloat ccr;
    CGFloat ccs;//起始位置
}


- (void)awakeFromNib{
    count = 0;
    ccx = self.frame.size.width/2.0f;
    ccy = self.frame.size.height/2.0f;
    ccr = self.frame.size.width/2.0f-7;
    ccs = 270;
    self.backgroundColor = [UIColor clearColor];
    self.titleL = [[UILabel alloc]initWithFrame:CGRectMake(ccx - 50, ccy - 15, 100, 30)];
    self.titleL.text = @"";
    self.titleL.textColor = [UIColor orangeColor];
    self.titleL.font = [UIFont systemFontOfSize:17.0];
    self.titleL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleL];
    //[self startAnimate];
}

- (void)setCCCount:(float)cccount{
    count = (int)(360*cccount);
    [self setNeedsDisplay];
}

- (void)changeCount:(NSTimer *)t{
    count ++;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    self.layer.backgroundColor = [[UIColor clearColor]CGColor] ;

    if (count >360) {
        count = 1;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(finishOneCircle)]) {
            [self.delegate finishOneCircle];
        }
    }

    if (ccx > 0 && ccy > 0 && ccr > 0) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 5.0);
        [[[UIColor whiteColor] colorWithAlphaComponent:0.2] setStroke];
        CGContextAddArc(context,ccx, ccy, ccr, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathStroke);
        
        [[UIColor orangeColor] setStroke];
        CGContextSetLineWidth(context, 2.0);
        CGContextAddArc(context, ccx, ccy, ccr, ccs*2*M_PI/360, (count + ccs)*2*M_PI/360, 0);
        CGContextDrawPath(context, kCGPathStroke);
        
        [[UIColor orangeColor] setFill];
        CGContextAddArc(context, ccx + ccr*cosf((count + ccs)*2*M_PI/360), ccy + ccr*sinf((count + ccs)*2*M_PI/360), 3, 0, 2*M_PI, 1);
        CGContextFillPath(context);
    }
    
}

- (void)startAnimate{
    if (myTime == nil) {
        myTime = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeCount:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:myTime forMode:NSRunLoopCommonModes];
    }
}

- (void)stopAnimate{
    if (myTime) {
        [myTime invalidate];
        myTime = nil;
    }

}
- (void)reloadStartAnimate{
    if (myTime == nil) {
        count = 360;
        myTime = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(changeCount:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:myTime forMode:NSRunLoopCommonModes];
    }
}
- (void)showAnimateWithCount:(int)coun{
    count = coun;
    [self setNeedsDisplay];
}

- (void)removeFromSuperview{
    [super removeFromSuperview];
    [myTime invalidate];
    myTime = nil;
}

- (void)dealloc{
    [myTime invalidate];
    myTime = nil;
}


@end
