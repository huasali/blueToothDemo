//
//  SensDeviceToolView.m
//  sensologyHome
//
//  Created by sensology on 16/8/23.
//  Copyright © 2016年 李建华. All rights reserved.
//

#import "SensDeviceToolView.h"
#import "Device.h"

@interface SensDeviceToolView (){
    Device *infoDic;
}

@end

@implementation SensDeviceToolView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *deviceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 80)];
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 70, 70)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.layer.borderColor = [SensHBack CGColor];
        _imageView.layer.borderWidth = 0.5;
        _imageView.layer.cornerRadius = 2.0;
        _imageView.layer.masksToBounds = YES;
        
        _titleL = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, frame.size.width - 160, 30)];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _detailL = [[UILabel alloc]initWithFrame:CGRectMake(80, 40, frame.size.width - 160, 30)];
        _detailL.textAlignment = NSTextAlignmentCenter;
        _detailL.font = [UIFont systemFontOfSize:16.0];
        _detailL.textColor = SensText2;
        
        UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width - 80, 0, 80, 80)];
        shareBtn.tag = 3001;
        UIImageView *shareImage = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width - 54, 20, 22,22)];
        [shareImage setImage:[UIImage imageNamed:@"device_share"]];
        
        UILabel *shareL = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width - 80, 45, 80, 20)];
        shareL.text = @"分享得优惠";
        shareL.textAlignment = NSTextAlignmentCenter;
        shareL.textColor = SensText1;
        shareL.font = [UIFont systemFontOfSize:11.0];
        
        
        [deviceView addSubview:_imageView];
        [deviceView addSubview:_titleL];
        [deviceView addSubview:_detailL];
        [deviceView addSubview:shareBtn];
        [deviceView addSubview:shareImage];
        [deviceView addSubview:shareL];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, frame.size.width, 1.0)];
        lineView.backgroundColor = SensMain;
        
        UIButton *zdBtn = [[UIButton alloc]initWithFrame:CGRectMake(40,  81, frame.size.width - 40, 49)];
        UIButton *ggBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, 130, frame.size.width - 40, 50)];
        UIButton *deBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, 180, frame.size.width - 40, 50)];
        
        zdBtn.tag = 3002;
        ggBtn.tag = 3003;
        deBtn.tag = 3004;
        
        [zdBtn setTitle:@"置顶设备" forState:UIControlStateNormal];
        [zdBtn setTitleColor:SensText3 forState:UIControlStateNormal];
        [ggBtn setTitle:@"更改设备名称" forState:UIControlStateNormal];
        [ggBtn setTitleColor:SensText3 forState:UIControlStateNormal];
        [deBtn setTitle:@"删除设备" forState:UIControlStateNormal];
        [deBtn setTitleColor:SensText3 forState:UIControlStateNormal];
        
        [zdBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [ggBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [deBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 130, frame.size.width, 0.5)];
        lineView1.backgroundColor = SensHBack;
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 180, frame.size.width, 0.5)];
        lineView2.backgroundColor = SensHBack;

        [self addSubview:deviceView];
        [self addSubview:lineView];
        [self addSubview:zdBtn];
        [self addSubview:ggBtn];
        [self addSubview:deBtn];
        [self addSubview:lineView1];
        [self addSubview:lineView2];
        
        
        [shareBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [zdBtn    addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [ggBtn    addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [deBtn    addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)setInfoValue:(Device *)value{
    infoDic = value;
    NSString *onLineStr = [value.online isEqualToString:@"1"]?@"在线":@"离线";
    NSString *titleStr = value.title?value.title:@"";
    NSString *detailStr = value.detail?value.detail:@"";
    NSString *imageStr = value.image?value.image:@"";
    
    [self.imageView setImage:[UIImage imageNamed:imageStr]];
    self.detailL.text = detailStr;
    
    NSString *readStr = [NSString stringWithFormat:@"%@  状态%@",titleStr,onLineStr];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:readStr];
    NSRange range1 = [readStr rangeOfString:titleStr];
    NSRange range2 = [readStr rangeOfString:onLineStr];
    
    [str addAttribute:NSForegroundColorAttributeName value:SensText2 range:NSMakeRange(0, str.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, str.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:range1];
    if ([onLineStr isEqualToString:@"在线"]) {
        [str addAttribute:NSForegroundColorAttributeName value:SensMain  range:range2];
    }
    else{
        [str addAttribute:NSForegroundColorAttributeName value:SensText1  range:range2];
    }
    
    self.titleL.attributedText = str;

}


- (void)btnAction:(id)sender{
    UIButton *btn = sender; 
    self.resultBlock(btn.tag - 3000,infoDic);
}



@end
