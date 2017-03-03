//
//  JHAlertView.m
//  NetWorkDemo
//
//  Created by sensology on 2016/11/28.
//  Copyright © 2016年 李建华. All rights reserved.
//

#import "JHAlertView.h"
#import <objc/runtime.h>
#import "AppDelegate.h"

#define MyScreen [UIScreen mainScreen].bounds.size
#define MYLine   [UIColor lightGrayColor]
#define MYText   [UIColor blackColor]

@interface JHAlertView ()<UIAlertViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>{
    int content;//显示时间
    int viewCount;
    NSTimer *sytime;
    NSTimer *viewTime;
}

@end

static void *JHAlertViewKey      = "JHAlertViewKey";
static void *JHAlertSheetViewKey = "JHAlertSheetViewKey";
static void *JHAlertViewEmptyKey = "JHAlertViewEmptyKey";
static void *JHAlertViewTextKey  = "JHAlertViewTextKey";
static void *JHSheetViewKey      = "JHSheetViewKey";

@implementation JHAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self viewInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self viewInit];
    }
    return self;
}

- (void)viewInit{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    content = 0;
    viewCount = 0;
}

- (id)initWithSview:(UIView *)view {
    if (view) {
        return [self initWithFrame:view.bounds];
    }
    else{
        return [self initWithFrame:CGRectMake(0, 0, 200, 40)];
    }
}

#pragma mark -----------------------------Message-----------------------------

+ (instancetype)showMessage:(NSString *)message{
    JHAlertView *alertView = [[self alloc] initWithSview:nil];
    [alertView showMessage:message ];
    return alertView;
}

+ (instancetype)showInView:(UIView *)sview andMessage:(NSString *)message{
    JHAlertView *alertView = [[self alloc] initWithSview:sview];
    [alertView showInView:sview andMessage:message ];
    [sview addSubview:alertView];
    return alertView;
}

+ (instancetype)showInView:(UIView *)sview andMessage:(NSString *)message andTime:(int)time andHeight:(NSInteger)height{
    JHAlertView *alertView = [[self alloc] initWithSview:sview];
    [alertView showInView:sview andMessage:message andTime:time andHeight:height];
    [sview addSubview:alertView];
    return alertView;
}

- (void)showMessage:(NSString *)message{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [self showInView:window andMessage:message];
}

- (void)showInView:(UIView *)sview andMessage:(NSString *)message{
    [self showInView:sview andMessage:message andTime:2.5];
}

- (void)showInView:(UIView *)sview andMessage:(NSString *)message andTime:(int)time{
    if (!sview) {
        sview = [[UIApplication sharedApplication] keyWindow];
    }
    [self showInView:sview andMessage:message andTime:time andHeight:80];
}

- (void)showInView:(UIView *)sview andMessage:(NSString *)message andTime:(int)time andHeight:(NSInteger)height{
    if (!message) {
        return;
    }

    UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    titleL.font = [UIFont systemFontOfSize:15.0];
    titleL.textColor = [UIColor whiteColor];
    titleL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleL];
    
    NSString *messageStr = [NSString stringWithFormat:@"%@",message];
    self.alpha = 0.0;
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.9],NSFontAttributeName,nil];
    CGSize size = [messageStr boundingRectWithSize:CGSizeMake(264,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
    self.frame = CGRectMake(20, 0, size.width<200?200:280, size.height + 20);
    self.layer.cornerRadius = 3.0;
    titleL.frame = CGRectMake(8, 5, self.frame.size.width - 16, self.frame.size.height - 10);
    titleL.text = messageStr;
    titleL.numberOfLines = 0;
    self.center = CGPointMake(sview.center.x, sview.frame.size.height - height - (size.height + 20)/2.0f);
    [sview addSubview:self];
    [UIView animateWithDuration:0.8 animations:^{
        self.alpha = 1;
    }];
    content = time;
    if (sytime != nil) {
        [sytime invalidate];
        sytime = nil;
    }
    sytime = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(changeTime:) userInfo:nil repeats:YES];
}

- (void)changeTime:(NSTimer *)time{
    if (content == 1.0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0.0;
        }];
    }
    if (content <= 0) {
        [time invalidate];
        sytime = nil;
        [self removeFromSuperview];
    }
    content--;
}

#pragma mark -----------------------------ShowView-----------------------------

//+ (instancetype)showJumpViewWithTime:(NSNumber *)time{
//    JHAlertView *alertView = [[self alloc] initWithSview:nil];
//    [alertView showJumpViewWithTime:time];
//    return alertView;
//}
//
//+ (instancetype)showRobotViewWithTime:(NSNumber *)time{
//    JHAlertView *alertView = [[self alloc] initWithSview:nil];
//    [alertView showRobotViewWithTime:time];
//    return alertView;
//}
//
//+ (instancetype)showLodingViewWithTime:(NSNumber *)time andMessage:(NSString *)message{
//    JHAlertView *alertView = [[self alloc] initWithSview:nil];
//    if (message) {
//        [alertView showLoadingViewWithTime:time andMessage:message];
//    }
//    else{
//       [alertView showLoadingViewWithTime:time];
//    }
//    
//    return alertView;
//}

//+ (instancetype)showView:(UIView *)aView inView:(UIView *)sview {
//    JHAlertView *alertView = [[self alloc] initWithSview:sview];
//    [alertView showView:aView inView:sview andTime:nil andHeight:sview.frame.size.height/2.0 - aView.frame.size.height/2.0];
//    return alertView;
//}
//
//+ (instancetype)showView:(UIView *)aView inView:(UIView *)sview andTime:(nullable NSNumber *)time andHeight:(NSInteger)height{
//    JHAlertView *alertView = [[self alloc] initWithSview:sview];
//    [alertView showView:aView inView:sview andTime:time andHeight:height];
//    return alertView;
//}

//- (void)showJumpViewWithTime:(NSNumber *)time{
//    JumpBallView *jumpView = [[JumpBallView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
//    [jumpView initFaceView];
//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
//    [self showView:jumpView inView:window andTime:time andHeight:window.frame.size.height/2.0 - window.frame.size.height/2.0];
//}
//
//- (void)showRobotViewWithTime:(NSNumber *)time{
//    RobotView *robotView = [[RobotView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//    [self showView:robotView inView:window andTime:time andHeight:window.frame.size.height/2.0 - window.frame.size.height/2.0];
//}
//
//- (void)showLoadingViewWithTime:(NSNumber *)time{
//    LoadingView *loadingView = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
//    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//    [self showView:loadingView inView:window andTime:time andHeight:window.frame.size.height/2.0 - window.frame.size.height/2.0];
//}
//
//- (void)showLoadingViewWithTime:(NSNumber *)time andMessage:(NSString *)messageStr{
//    
//    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//    backView.layer.cornerRadius = 5.0;
//    backView.tag = 1111;
//    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.9],NSFontAttributeName,nil];
//    CGSize size = [messageStr boundingRectWithSize:CGSizeMake(264,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
//    
//    UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
//    titleL.font = [UIFont systemFontOfSize:15.0];
//    titleL.textColor = [UIColor whiteColor];
//    titleL.textAlignment = NSTextAlignmentCenter;
//    titleL.numberOfLines = 0;
//    backView.frame = CGRectMake(20, 0, size.width<150?150:size.width, size.height + 20 + 90);
//    titleL.frame = CGRectMake(8, 90, backView.frame.size.width - 16, backView.frame.size.height - 10 - 90);
//    titleL.text = messageStr;
//    
//    LoadingView *loadingView = [[LoadingView alloc]initWithFrame:CGRectMake((backView.frame.size.width - 80)/2.0, 0, 80, 80)];
//    loadingView.backgroundColor = [UIColor clearColor];
//    loadingView.tag = 1112;
//    
//    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
//    [backView addSubview:titleL];
//    [backView addSubview:loadingView];
//
//    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
//
//    UIWindow *window = [MyDelegate window];
//    [self showView:backView inView:window andTime:time andHeight:window.frame.size.height/2.0 - window.frame.size.height/2.0];
//}
//

//- (void)showView:(UIView *)aView inView:(UIView *)sView{
//    if (!sView) {
//        sView = [[UIApplication sharedApplication] keyWindow];
//    }
//    [self showView:aView inView:sView andTime:nil andHeight:sView.frame.size.height/2.0 - aView.frame.size.height/2.0];
//}

//- (void)showView:(UIView *)aview inView:(UIView *)sView andTime:(nullable NSNumber*)time andHeight:(NSInteger)height{
//    
//    if (!aview) {
//        return;
//    }
//    self.frame = CGRectMake(0, 0, sView.frame.size.width, sView.frame.size.height);
//    aview.center = self.center;
//    [self addSubview:aview];
//    self.alpha = 0.0;
//    self.center = CGPointMake(sView.center.x, sView.frame.size.height/2.0f);
//    [sView addSubview:self];
//    
//    //aview.transform = CGAffineTransformMakeScale(0.5, 0.5);
//    [UIView animateWithDuration:0.2 animations:^{
//        self.alpha = 1;
//        //aview.transform = CGAffineTransformMakeScale(1.0, 1.0);
//    } completion:^(BOOL finished) {
//        if ([aview isKindOfClass:[RobotView class]]) {
//            [(RobotView *)aview startDraw];
//        }
//        else if ([aview isKindOfClass:[LoadingView class]]){
//            [(LoadingView *)aview startAnimate];
//        }
//        else if (aview.tag == 1111){
//            LoadingView *lview = [aview viewWithTag:1112];
//            [lview startAnimate];
//        }
//    }];
//    
//    if (time) {
//        viewCount = [time intValue];
//        if (viewTime != nil) {
//            [viewTime invalidate];
//            viewTime = nil;
//        }
//        viewTime = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(changeViewTime:) userInfo:nil repeats:YES];
//    }
//    
//}

//- (void)changeViewTime:(NSTimer *)time{
//    if (viewCount == 1.0) {
//        [UIView animateWithDuration:0.5 animations:^{
//            self.alpha = 0.0;
//        }];
//    }
//    if (viewCount <= 0) {
//        [time invalidate];
//        viewTime = nil;
//        [self removeFromSuperview];
//    }
//    viewCount--;
//}


+ (void)hideAllViewinView:(UIView *)sView{
    if (!sView) {
        sView = [[UIApplication sharedApplication] keyWindow];
    }
    
    NSArray *alertViewArr = [self alertViewForView:sView];
    for (JHAlertView *alertView in alertViewArr) {
        [UIView animateWithDuration:0.2 animations:^{
            alertView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [alertView stopTime];
            [alertView removeFromSuperview];
        }];
    }
    
}

+ (NSArray *)alertViewForView:(UIView *)view {

    NSMutableArray *huds = [NSMutableArray array];
    NSArray *subviews = view.subviews;
    for (UIView *aView in subviews) {
        if ([aView isKindOfClass:self]) {
            [huds addObject:aView];
        }
    }
    return [NSArray arrayWithArray:huds];
}

#pragma mark -----------------------------ShowSYMView-----------------------------

+ (void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}

+ (void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message inView:(UIView *)backView isCompletion:(void (^)(NSInteger buttonIndex))block{
    
    JHAlertView *delegateView = [[self alloc] initWithFrame:CGRectZero];
    [backView addSubview:delegateView];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:delegateView cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    objc_setAssociatedObject(alertView, JHAlertViewKey, block, OBJC_ASSOCIATION_COPY);

    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    void (^block)(NSInteger) = objc_getAssociatedObject(alertView, JHAlertViewKey);
    if (block) {
        block(buttonIndex);
    }
    [self removeFromSuperview];
}

+ (void)showSheetWithTitle:(NSString *)title andButton:(NSArray *)buttons inView:(UIView *)backView andEnventBlock:(AlertActionBlock)eventblock{
    
    JHAlertView *delegateView = [[self alloc] initWithFrame:CGRectZero];
    [backView addSubview:delegateView];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title delegate:delegateView cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    objc_setAssociatedObject(sheet, JHAlertSheetViewKey, eventblock, OBJC_ASSOCIATION_COPY);
    [sheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    
    for (NSString *str in buttons) {
        [sheet addButtonWithTitle:str];
    }
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [sheet showInView:window];
    
}

//菜单列表按钮的触发方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AlertActionBlock block = (AlertActionBlock)objc_getAssociatedObject(actionSheet, JHAlertSheetViewKey);
    if (block) {
        block(buttonIndex,[actionSheet buttonTitleAtIndex:buttonIndex]);
    }
    [self removeFromSuperview];
}


#pragma mark -----------------------------ShowZDYView-----------------------------

+ (void)showTextFiled:(NSString *)str
       andPlaceholder:(NSString *)placeholder
             andTitle:(NSString *)title
          andTempView:(UIView *)tempView
         isCompletion:(EmptyActionBlock)block{
    
    JHAlertView *delegateView = [[self alloc] initWithFrame:CGRectZero];
    [tempView addSubview:delegateView];
    
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MyScreen.width - 20, 160)];
    
    UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, textView.frame.size.width, 70)];
    titleL.text = title;
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor = MYText;
    titleL.numberOfLines = 0;
    [textView addSubview:titleL];
    
    UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(20, 80, textView.frame.size.width - 40, 80)];
    text.placeholder = placeholder;
    text.text = str;
    text.delegate = delegateView;
    text.tag = 5001;
    text.textAlignment = NSTextAlignmentCenter;
    textView.tag = 1005;
    [textView addSubview:text];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(50, 134,  textView.frame.size.width - 100, 0.6)];
    lineView.backgroundColor = MYLine;
    [textView addSubview:lineView];
    
    objc_setAssociatedObject(textView, JHAlertViewTextKey, delegateView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self showEmptyViewWithHeight:50 andFadeView:textView andEnventBlock:block];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    UIView *btnEmptyView = [[textField superview] superview];
    [UIView animateWithDuration:0.2 animations:^{
        if (btnEmptyView) {
           btnEmptyView.center = CGPointMake(MyScreen.width/2.0f, MyScreen.height/2.0f - 90);
        }
    }];
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    UIView *btnEmptyView = [[textField superview] superview];
    [UIView animateWithDuration:0.2 animations:^{
        if (btnEmptyView) {
            btnEmptyView.center = CGPointMake(MyScreen.width/2.0f, MyScreen.height/2.0f);
        }
    }];
    return YES;
}

+ (void)showEmptyViewWithHeight:(CGFloat)btnHeight andFadeView:(UIView *)fview andEnventBlock:(EmptyActionBlock)emptyblock{

    CGRect frame = fview.frame;
    frame.size.height += btnHeight;
    UIView *btnEmptyView = [[UIView alloc]initWithFrame:frame];
    btnEmptyView.tag = 1001;
    btnEmptyView.backgroundColor = [UIColor whiteColor];
    btnEmptyView.layer.cornerRadius = 3.0;
    btnEmptyView.layer.masksToBounds = YES;
    
    if (btnHeight > 0) {
        UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, frame.size.height - btnHeight, frame.size.width/2.0f, btnHeight)];
        UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width/2.0f - 0.5, frame.size.height - btnHeight, frame.size.width/2.0f + 0.5, btnHeight)];
        
        [self addLineWithView:leftBtn andColor:nil];
        [self addLineWithView:rightBtn andColor:nil];
        
        [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [leftBtn addTarget:self action:@selector(emptyLeftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [rightBtn setTitle:@"确认" forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [rightBtn addTarget:self action:@selector(emptyRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnEmptyView addSubview:leftBtn];
        [btnEmptyView addSubview:rightBtn];
    }
    
    if (fview) {
        [btnEmptyView addSubview:fview];
    }
    
    objc_setAssociatedObject(btnEmptyView, JHAlertViewEmptyKey, emptyblock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    btnEmptyView.center = CGPointMake(MyScreen.width/2.0f, MyScreen.height + btnEmptyView.frame.size.height/2.0f);
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MyScreen.width, MyScreen.height)];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    [backView addSubview:btnEmptyView];
    [window addSubview:backView];

    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        btnEmptyView.center      = backView.center;
    } completion:^(BOOL finished) {
        
    }];

}

+ (void)emptyLeftBtnAction:(id)sender{
    
    UIView *btnEmptyView = [sender superview];
    EmptyActionBlock block = (EmptyActionBlock)objc_getAssociatedObject(btnEmptyView,JHAlertViewEmptyKey);
    
    UIView *backView = [btnEmptyView superview];
    [backView endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        btnEmptyView.center = CGPointMake(btnEmptyView.center.x, MyScreen.height + btnEmptyView.frame.size.height/2.0f);
    } completion:^(BOOL finished) {
        UIView *textView = [btnEmptyView viewWithTag:1005];

        block(nil,nil,nil);
        if (textView) {
            JHAlertView *alertView = objc_getAssociatedObject(textView,JHAlertViewTextKey);
            if (alertView) {
                [alertView removeFromSuperview];
            }
        }
        [backView removeFromSuperview];
    }];
}

+ (void)emptyRightBtnAction:(id)sender{
    
    UIView *btnEmptyView = [sender superview];
    EmptyActionBlock block = (EmptyActionBlock)objc_getAssociatedObject(btnEmptyView, JHAlertViewEmptyKey);
    UIView *backView = [btnEmptyView superview];
    [backView endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        btnEmptyView.center = CGPointMake(btnEmptyView.center.x, MyScreen.height + btnEmptyView.frame.size.height/2.0f);
    } completion:^(BOOL finished) {
        UIView *textView = [btnEmptyView viewWithTag:1005];
        if (textView){
            UITextField *text = [textView viewWithTag:5001];
            block(text.text,nil,nil);
            JHAlertView *alertView = objc_getAssociatedObject(textView,JHAlertViewTextKey);
            if (alertView) {
                [alertView removeFromSuperview];
            }
        }
        else{
            block(nil,nil,nil);
        }
        [backView removeFromSuperview];
    }];
    
}

+ (void)showSheetViewWtihTitles:(NSArray *)titles andSeleRow:(int)seleRow andViewSize:(CGSize)viewsize andEvent:(AlertActionBlock)eventblock{
    
    UIView *btnBackView = [[UIView alloc]initWithFrame:CGRectMake((MyScreen.width - viewsize.width)/2.0f, MyScreen.height,  viewsize.width, viewsize.height*[titles count])];
    btnBackView.layer.cornerRadius = 3.0;
    btnBackView.layer.masksToBounds = YES;
    btnBackView.tag = 1001;
    btnBackView.backgroundColor = [UIColor whiteColor];
    btnBackView.layer.borderWidth = 0.5;
    btnBackView.layer.borderColor = [MYLine CGColor];
    
    objc_setAssociatedObject(btnBackView, JHSheetViewKey, eventblock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    for (int i = 0; i < [titles count]; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, viewsize.height*i, viewsize.width, viewsize.height)];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = 3001 + i;
        [btn setTitle:[NSString stringWithFormat:@"%@",titles[i]] forState:UIControlStateNormal];
        if (i == seleRow) {
            [btn setTitleColor:[UIColor colorWithRed:209/255.0f green:225/255.0f blue:  0/255.0f alpha:1.0]  forState:UIControlStateNormal];
        }
        else{
            [btn setTitleColor:MYText forState:UIControlStateNormal];
        }
        
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn addTarget:self action:@selector(sheetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        btn.layer.borderWidth = 0.25;
        btn.layer.borderColor = [MYLine CGColor];
        btn.exclusiveTouch = YES;
        [btnBackView addSubview:btn];
        
    }
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MyScreen.width, MyScreen.height)];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    [backView addSubview:btnBackView];
    [window addSubview:backView];
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBtnBackView:)];
    [backView addGestureRecognizer:tapGest];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        btnBackView.center = CGPointMake(MyScreen.width/2.0, MyScreen.height/2.0);
    } completion:^(BOOL finished) {
        
    }];
}

+ (void)sheetBtnAction:(id)sender{
    UIButton *btn = sender;
    UIView *backView = [[btn superview] superview];
    UIView *btnView = [backView viewWithTag:1001];
    
    AlertActionBlock block = (AlertActionBlock)objc_getAssociatedObject(btnView, JHSheetViewKey);
    if (block) {
        block([btn tag] - 3001,@"");
    }
    [UIView animateWithDuration:0.3 animations:^{
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        btnView.center = CGPointMake(btnView.center.x, MyScreen.height + btnView.frame.size.height/2.0f);
    } completion:^(BOOL finished) {
        [backView removeFromSuperview];
    }];
}

+ (void)tapBtnBackView:(UITapGestureRecognizer *)gest{
    UIView *backView = [gest view];
    UIView *btnView = [backView viewWithTag:1001];
    
    AlertActionBlock block = (AlertActionBlock)objc_getAssociatedObject(btnView, JHSheetViewKey);
    if (block) {
        block(-1,@"");
    }
    [UIView animateWithDuration:0.3 animations:^{
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        btnView.center = CGPointMake(btnView.center.x, MyScreen.height + btnView.frame.size.height/2.0f);
    } completion:^(BOOL finished) {
        [backView removeFromSuperview];
    }];
}



#pragma mark -----------------------------HelpTool-----------------------------

+ (void)addLineWithView:(UIView *)sview andColor:(UIColor *)color{
    if (color) {
        sview.layer.borderColor = [color CGColor];
    }
    else{
        sview.layer.borderColor = [MYLine CGColor];
    }
    
    sview.layer.borderWidth = 0.5;
}

- (void)stopTime{
    if (viewTime != nil) {
        [viewTime invalidate];
        viewTime = nil;
    }
    if (sytime != nil) {
        [sytime invalidate];
        sytime = nil;
    }
}

- (void)removeFromSuperview{
    [super removeFromSuperview];
}

- (void)dealloc{
    
}

@end



