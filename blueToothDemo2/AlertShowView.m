//
//  AlertShowView.m
//  Created by taojin on 15/7/9.
//

#import "AlertShowView.h"
#import <objc/runtime.h>

#define OAScreen [UIScreen mainScreen].bounds
#define OALine   [UIColor lightGrayColor]
#define OAText   [UIColor lightTextColor]

@interface AlertShowView ()<UITextFieldDelegate>{
    
}

@end

@implementation AlertShowView{
    int content;//显示时间
    NSTimer *sytime;
    UIAlertView *alvertView;
    UIImageView *showImageView;
    UIView *emptyView;
    UIView *btnEmptyView;

}

static char overviewKey;
static char overviewKeyTwo;
static char overviewKeyAlert;
static char overviewKeyEmpty;

static AlertShowView* sInstance = nil;
+ (AlertShowView *) sharedInstance{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sInstance = [[self alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    });
    return sInstance;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
        self.title.font = [UIFont systemFontOfSize:15.0];
        self.title.textColor = [UIColor whiteColor];
        self.title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.title];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    }
    return self;
}

+ (void)addLineWithView:(UIView *)sview andColor:(UIColor *)color{
    if (color) {
        sview.layer.borderColor = [color CGColor];
    }
    else{
        sview.layer.borderColor = [OALine CGColor];
    }
    
    sview.layer.borderWidth = 0.5;
}
+ (void)addCornerWithView:(UIView *)sview andRadius:(CGFloat)radius{
    sview.layer.cornerRadius = radius;
    sview.layer.masksToBounds = YES;
}

- (void)addEmptyViewWithFrame:(CGRect)frame andFadeView:(UIView *)fview{
    if ([emptyView superview]) {
        [[emptyView superview] removeFromSuperview];
    }
    emptyView = [[UIView alloc]initWithFrame:frame];
    emptyView.tag = 1001;
    emptyView.backgroundColor = [UIColor whiteColor];
    emptyView.layer.cornerRadius = 3.0;
    emptyView.layer.masksToBounds = YES;
    if (fview) {
        [emptyView addSubview:fview];
    }
    emptyView.center = CGPointMake(OAScreen.size.width/2.0f, OAScreen.size.height + emptyView.frame.size.height/2.0f);
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, OAScreen.size.width, OAScreen.size.height)];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    [backView addSubview:emptyView];
    [window addSubview:backView];
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEmptyBackView:)];
    [backView addGestureRecognizer:tapGest];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        emptyView.center =backView.center;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)removeEmptyViewWithFadeView:(UIView *)fview{
    //UIView *emptyView = [fview superview];
    UIView *backView = [emptyView superview];
    [backView endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        emptyView.center = CGPointMake(emptyView.center.x, OAScreen.size.height + emptyView.frame.size.height/2.0f);
    } completion:^(BOOL finished) {
        [backView removeFromSuperview];
    }];
}

- (void)moveEmptyViewWithFadeView:(UIView *)fview andHeight:(CGFloat)height{
    //UIView *emptyView = [fview superview];
    UIView *backView = [emptyView superview];
    [backView endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        emptyView.center = CGPointMake(backView.center.x, backView.center.y - height);
    } completion:^(BOOL finished) {
    }];
}

- (void)tapEmptyBackView:(UITapGestureRecognizer *)gest{
    UIView *backView = [emptyView superview];
    //UIView *emptyView = [backView viewWithTag:1001];
    [backView endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        emptyView.center = CGPointMake(emptyView.center.x, OAScreen.size.height + emptyView.frame.size.height/2.0f);
    } completion:^(BOOL finished) {
        [backView removeFromSuperview];
    }];
}

- (void)addSheetBtnViewWtihTitles:(NSArray *)titles andViewSize:(CGSize)viewsize andEvent:(SheetActionBlock)eventblock{
    UIView *btnBackView = [[UIView alloc]initWithFrame:CGRectMake((OAScreen.size.width - viewsize.width)/2.0f, OAScreen.size.height,  viewsize.width, viewsize.height*[titles count])];
    btnBackView.layer.cornerRadius = 3.0;
    btnBackView.layer.masksToBounds = YES;
    btnBackView.tag = 1001;
    btnBackView.backgroundColor = [UIColor whiteColor];
    btnBackView.layer.borderWidth = 0.5;
    btnBackView.layer.borderColor = [OALine CGColor];
    objc_setAssociatedObject(self, &overviewKeyTwo, eventblock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    for (int i = 0; i < [titles count]; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, viewsize.height*i, viewsize.width, viewsize.height)];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = 3001 + i;
        [btn setTitle:[NSString stringWithFormat:@"%@",titles[i]] forState:UIControlStateNormal];
        [btn setTitleColor:OAText forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn addTarget:self action:@selector(sheetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        btn.layer.borderWidth = 0.25;
        btn.layer.borderColor = [OALine CGColor];
        btn.exclusiveTouch = YES;
        [btnBackView addSubview:btn];
        
    }
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, OAScreen.size.width, OAScreen.size.height)];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    [backView addSubview:btnBackView];
    [window addSubview:backView];
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBtnBackView:)];
    [backView addGestureRecognizer:tapGest];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        btnBackView.center =backView.center;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)sheetBtnAction:(id)sender{
    UIButton *btn = sender;
    SheetActionBlock block = (SheetActionBlock)objc_getAssociatedObject(self, &overviewKeyTwo);
    if (block) {
        block([btn tag] - 3001,@"");
    }
    UIView *backView = [[btn superview] superview];
    UIView *btnView = [backView viewWithTag:1001];
    [UIView animateWithDuration:0.3 animations:^{
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        btnView.center = CGPointMake(btnView.center.x, OAScreen.size.height + btnView.frame.size.height/2.0f);
    } completion:^(BOOL finished) {
        [backView removeFromSuperview];
    }];
}

- (void)tapBtnBackView:(UITapGestureRecognizer *)gest{
    UIView *backView = [gest view];
    UIView *btnView = [backView viewWithTag:1001];
    [UIView animateWithDuration:0.3 animations:^{
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        btnView.center = CGPointMake(btnView.center.x, OAScreen.size.height + btnView.frame.size.height/2.0f);
    } completion:^(BOOL finished) {
        [backView removeFromSuperview];
    }];
}

- (void)showBlockViewWithView:(UIView*)sview  customView:(UIView*)customView event:(SheetViewBlock)eventblock{
    if (sview==nil) {
        sview=[[UIApplication sharedApplication].delegate window];
    }
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, OAScreen.size.width, OAScreen.size.height)];
    backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackView:)];
    [backView addGestureRecognizer:tapGest];
    [backView setUserInteractionEnabled:YES];
    
    CGRect frame=customView.frame;
    frame.origin=CGPointMake((sview.frame.size.width-customView.frame.size.width)/2.0, (sview.frame.size.height-customView.frame.size.height)/2.0);
    [customView setFrame:frame];
    [backView addSubview:customView];
    
    [sview addSubview:backView];
}

- (void)showMiniSheetViewWithView:(UIView *)sview andTitles:(NSArray *)titleArr andEvent:(SheetViewBlock)eventblock{
    [self showMiniSheetViewWithView:sview andOffset:CGPointMake(0, 15) andViewSize:CGSizeMake(90, 50) andTitles:titleArr?titleArr:@[] andEvent:eventblock];
}

- (void)showMiniSheetViewWithView:(UIView *)sview andOffset:(CGPoint)offset andViewSize:(CGSize)viewsize andTitles:(NSArray *)titleArr andEvent:(SheetViewBlock)eventblock{
    
    UIView *typeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewsize.width, viewsize.height*[titleArr count])];
    typeView.tag = 1001;
    typeView.layer.cornerRadius = 3.0;
    typeView.layer.masksToBounds = YES;
    typeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    for (int i = 0; i < [titleArr count]; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, viewsize.height*i, viewsize.width, viewsize.height)];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = 3001 + i;
        [btn setTitle:[NSString stringWithFormat:@"%@",titleArr[i]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(typeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        btn.exclusiveTouch = YES;
        [typeView addSubview:btn];
    }
    objc_setAssociatedObject(typeView, &overviewKey, eventblock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, OAScreen.size.width, OAScreen.size.height)];
    backView.backgroundColor = [UIColor clearColor];
    CGRect rect = [sview convertRect:sview.bounds toView:window];
    
    typeView.center = CGPointMake((rect.origin.x + rect.size.width/2.0f) + offset.x, rect.origin.y + rect.size.height + (viewsize.height*[titleArr count]/2.0f));
    [backView addSubview:typeView];
    [window addSubview:backView];
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackView:)];
    [backView addGestureRecognizer:tapGest];
    [UIView animateWithDuration:0.2 animations:^{
        typeView.center = CGPointMake((rect.origin.x + rect.size.width/2.0f) + offset.x, rect.origin.y + rect.size.height + (viewsize.height*[titleArr count]/2.0f) + offset.y);
    }];
    
}

- (void)tapBackView:(UITapGestureRecognizer *)gest{
    UIView *backView = [gest view];
    UIView *typeView = [backView viewWithTag:1001];
    [UIView animateWithDuration:0.2 animations:^{
        typeView.center = CGPointMake(typeView.center.x, typeView.center.y - 10);
        typeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    } completion:^(BOOL finished) {
        [backView removeFromSuperview];
    }];
    
    SheetViewBlock block = (SheetViewBlock)objc_getAssociatedObject(typeView, &overviewKey);
    if (block) {
        block(backView,-1,@"取消");
    }
}

- (void)typeBtnAction:(id)sender{
    UIButton *btn = sender;
    NSString *seleType = btn.titleLabel.text;
    UIView *typeView = [btn superview];
    [UIView animateWithDuration:0.2 animations:^{
        typeView.center = CGPointMake(typeView.center.x, typeView.center.y - 10);
        typeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    } completion:^(BOOL finished) {
        [[typeView superview] removeFromSuperview];
    }];
    
    SheetViewBlock block = (SheetViewBlock)objc_getAssociatedObject(typeView, &overviewKey);
    if (block) {
        block(sender,[btn tag]-3001,seleType);
    }
}
- (void)showMessage:(NSString *)message{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [self showInView:window andMessage:message];
}

- (void)showInView:(UIView *)sview andMessage:(NSString *)message{
    [self showInView:sview andMessage:message andTime:4.0];
}

- (void)showInView:(UIView *)sview andMessage:(NSString *)message andTime:(int)time{
    if (!sview) {
        sview = [[UIApplication sharedApplication] keyWindow];
    }
    [self showInView:sview andMessage:message andTime:time andHeight:80];
}

- (void)showInView:(UIView *)sview andMessage:(NSString *)message andTime:(int)time andHeight:(NSInteger)height{
    if (!message) {
       // message = @"";
        return;
    }
    NSString *messageStr = [NSString stringWithFormat:@"%@",message];
    self.alpha = 0.0;
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.9],NSFontAttributeName,nil];
    CGSize size = [messageStr boundingRectWithSize:CGSizeMake(264,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
    self.frame = CGRectMake(20, 0, size.width<200?200:280, size.height + 20);
    self.layer.cornerRadius = 3.0;
    self.title.frame = CGRectMake(8, 5, self.frame.size.width - 16, self.frame.size.height - 10);
    self.title.text = messageStr;
    self.title.numberOfLines = 0;
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

- (void)showActivityWithView:(UIView *)view{
    UIActivityIndicatorView *showActivity = [view viewWithTag:9001];
    if (!showActivity) {
        UIActivityIndicatorView *showActivity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        showActivity.tag = 9001;
        showActivity.center = CGPointMake(view.frame.size.width/2.0, view.frame.size.height/2.0);
        [showActivity startAnimating];
        [view addSubview:showActivity];
    }
}

- (void)removeActivityWithView:(UIView *)view{
    UIActivityIndicatorView *showActivity = [view viewWithTag:9001];
    if (showActivity) {
        [showActivity stopAnimating];
        [showActivity removeFromSuperview];
    }
}

- (void)showImageView:(UIImage *)image{
    
    if (image != nil) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        UIScrollView *backView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, OAScreen.size.width, OAScreen.size.height)];
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0];
        backView.showsHorizontalScrollIndicator = NO;
        backView.showsVerticalScrollIndicator = NO;
        showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, OAScreen.size.width, OAScreen.size.height)];
        showImageView.image = [image copy];
        [showImageView setContentMode:UIViewContentModeScaleAspectFit];
        showImageView.layer.masksToBounds = YES;
        [backView addSubview:showImageView];
        backView.contentSize=CGSizeMake(OAScreen.size.width, OAScreen.size.height);
        backView.delegate=self;
        backView.maximumZoomScale=2.0;
        backView.minimumZoomScale=1.0;
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapView:)];
        [backView addGestureRecognizer:tapGest];
        
        [self showAnimation:backView];
        [window addSubview:backView];
        
    }
    
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return showImageView;
}

- (void)showAnimation:(UIView *)view{
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.2;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:popAnimation forKey:nil];
}

- (void)imageTapView:(UITapGestureRecognizer *)gest{
    UIView *view = gest.view;
    CGPoint center = view.center;
    [UIView animateWithDuration:0.2 animations:^{
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 5, 5);
        view.center = center;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
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

- (void)showSheetWithTitle:(NSString *)title andButton:(NSArray *)buttons andEnventBlock:(SheetActionBlock)enventblock{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [self showSheetInView:window WithTitle:title andButton:buttons andEnventBlock:enventblock];
}

- (void)showSheetInView:(UIView *)view WithTitle:(NSString *)title andButton:(NSArray *)buttons andEnventBlock:(SheetActionBlock)enventblock{
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    objc_setAssociatedObject(self, &overviewKeyTwo, enventblock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [sheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    
    for (NSString *str in buttons) {
        [sheet addButtonWithTitle:str];
    }
    [sheet showInView:view];
}

//菜单列表按钮的触发方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    SheetActionBlock block = (SheetActionBlock)objc_getAssociatedObject(self, &overviewKeyTwo);
    if (block) {
        block(buttonIndex,[actionSheet buttonTitleAtIndex:buttonIndex]);
    }
    
}

- (void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message andEnventBlock:(SheetActionBlock)enventblock{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    objc_setAssociatedObject(self, &overviewKeyAlert, enventblock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [alertView show];
}

- (void)showSWAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message andEnventBlock:(SheetActionBlock)enventblock{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"开启", nil];
    objc_setAssociatedObject(self, &overviewKeyAlert, enventblock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [alertView show];
}
- (void)showAlertViewOnlySureWithTitle:(NSString *)title andMessage:(NSString *)message andEnventBlock:(SheetActionBlock)enventblock{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    objc_setAssociatedObject(self, &overviewKeyAlert, enventblock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    SheetActionBlock block = (SheetActionBlock)objc_getAssociatedObject(self, &overviewKeyAlert);
    if (block) {
        block(buttonIndex,@"");
    }
}


- (void)showDateViewWithSeleDate:(NSDate *)seledate andStyle:(UIDatePickerMode)datePickerMode andEnventBlock:(EmptyActionBlock)emptyblock{
    
    UIDatePicker *dateView = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 300, 250)];
    dateView.datePickerMode = datePickerMode;
    dateView.date = seledate;
    dateView.tag = 6001;
    [self showEmptyViewWithFrame:dateView.frame andBtnHeight:50 andFadeView:dateView andEnventBlock:emptyblock];
}

- (void)showTextFiled:(NSString *)str ViewWithEnventBlock:(EmptyActionBlock)emptyblock{
    
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, OAScreen.size.width - 20, 100)];
    UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, textView.frame.size.width - 40, 90)];
    text.placeholder = @"请输入设备名称";
    text.text = str;
    text.delegate = self;
    text.tag = 5001;
    text.textAlignment = NSTextAlignmentCenter;
//    [text becomeFirstResponder];
    textView.tag = 1005;
    [textView addSubview:text];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(80, 70,  textView.frame.size.width - 160, 0.6)];
    lineView.backgroundColor = OALine;
    [textView addSubview:lineView];
    [self showEmptyViewWithFrame:textView.frame andBtnHeight:50 andFadeView:textView andEnventBlock:emptyblock];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    [UIView animateWithDuration:0.2 animations:^{
//        btnEmptyView.center = CGPointMake(MyScreen.width/2.0f, MyScreen.height/2.0f - 90);
//    }];
//    
//    return YES;
//}
//
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    [UIView animateWithDuration:0.2 animations:^{
//        btnEmptyView.center = CGPointMake(MyScreen.width/2.0f, MyScreen.height/2.0f);
//    }];
//    return YES;
//}

- (void)showEmptyViewWithFrame:(CGRect)frame  andBtnHeight:(CGFloat)btnHeight andFadeView:(UIView *)fview andEnventBlock:(EmptyActionBlock)emptyblock{
    if ([btnEmptyView superview]) {
        [[btnEmptyView superview] removeFromSuperview];
    }
    
    frame.size.height += btnHeight;
    btnEmptyView = nil;
    btnEmptyView = [[UIView alloc]initWithFrame:frame];
    btnEmptyView.tag = 1001;
    btnEmptyView.backgroundColor = [UIColor whiteColor];
    btnEmptyView.layer.cornerRadius = 3.0;
    btnEmptyView.layer.masksToBounds = YES;
    if (btnHeight > 0) {
        UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, frame.size.height - btnHeight, frame.size.width/2.0f, btnHeight)];
        UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width/2.0f - 0.5, frame.size.height - btnHeight, frame.size.width/2.0f + 0.5, btnHeight)];
        [AlertShowView addLineWithView:leftBtn andColor:nil];
        [AlertShowView addLineWithView:rightBtn andColor:nil];
        
        [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
       // [leftBtn setTitleColor:SensText3 forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [leftBtn addTarget:self action:@selector(emptyLeftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [rightBtn setTitle:@"确认" forState:UIControlStateNormal];
      //  [rightBtn setTitleColor:SensText3 forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [rightBtn addTarget:self action:@selector(emptyRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnEmptyView addSubview:leftBtn];
        [btnEmptyView addSubview:rightBtn];
    }
    
    if (fview) {
        [btnEmptyView addSubview:fview];
    }
    
    objc_setAssociatedObject(btnEmptyView, &overviewKeyEmpty, emptyblock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    btnEmptyView.center = CGPointMake(OAScreen.size.width/2.0f, OAScreen.size.height + btnEmptyView.frame.size.height/2.0f);
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, OAScreen.size.width, OAScreen.size.height)];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    [backView addSubview:btnEmptyView];
    [window addSubview:backView];
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBtnEmptyBackView:)];
    [backView addGestureRecognizer:tapGest];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        btnEmptyView.center =backView.center;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)emptyLeftBtnAction:(id)sender{
    
    EmptyActionBlock block = (EmptyActionBlock)objc_getAssociatedObject(btnEmptyView, &overviewKeyEmpty);
    UIView *backView = [btnEmptyView superview];
    [backView endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        btnEmptyView.center = CGPointMake(btnEmptyView.center.x, OAScreen.size.height + btnEmptyView.frame.size.height/2.0f);
    } completion:^(BOOL finished) {
        block(nil,nil,nil);
        [backView removeFromSuperview];
    }];
}

- (void)emptyRightBtnAction:(id)sender{
    EmptyActionBlock block = (EmptyActionBlock)objc_getAssociatedObject(btnEmptyView, &overviewKeyEmpty);
    UIView *backView = [btnEmptyView superview];
    [backView endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        btnEmptyView.center = CGPointMake(btnEmptyView.center.x, OAScreen.size.height + btnEmptyView.frame.size.height/2.0f);
    } completion:^(BOOL finished) {
        UIView *fview = [btnEmptyView viewWithTag:6001];
        UIView *textView = [btnEmptyView viewWithTag:1005];
        if (fview) {
            UIDatePicker *dateView = (UIDatePicker *)fview;
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"hh:mm:ss"];
            block(dateView.date,[formatter stringFromDate:dateView.date],[NSDate date]);
        }
        else if (textView){
            UITextField *text = [textView viewWithTag:5001];
            block(text.text,nil,nil);
        }
        else{
            block(nil,nil,nil);
        }
        [backView removeFromSuperview];
    }];
    
}

- (void)tapBtnEmptyBackView:(UITapGestureRecognizer *)gest{
    EmptyActionBlock block = (EmptyActionBlock)objc_getAssociatedObject(btnEmptyView, &overviewKeyEmpty);
    UIView *backView = [btnEmptyView superview];
    [backView endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        btnEmptyView.center = CGPointMake(btnEmptyView.center.x, OAScreen.size.height + btnEmptyView.frame.size.height/2.0f);
    } completion:^(BOOL finished) {
        block(nil,nil,nil);
        [backView removeFromSuperview];
    }];
    
}

- (void)showSysMessage:(NSString *)message{
    
    alvertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",message] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alvertView show];
    
}

- (NSDate *)getWeekBeginWith:(NSDate *)seledate{
    NSDate *newDate = seledate;
    double interval = 0;
    NSDate *beginDate = seledate;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];
    [calendar rangeOfUnit:NSCalendarUnitWeekOfYear startDate:&beginDate interval:&interval forDate:newDate];
    return beginDate;
}

- (void)showNotifWith:(NSString *)message andInfo:(NSDictionary *)info{
    
    if (message) {
        if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
            NSString *str = [NSString stringWithFormat:@"%@",message];
            UILocalNotification* localNotif = [[UILocalNotification alloc] init];
            if (localNotif == nil) {
                return;
            }
            localNotif.alertBody = str;
            localNotif.alertAction = @"查看";
            localNotif.soundName = UILocalNotificationDefaultSoundName;
            localNotif.userInfo = info;
            //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            localNotif.applicationIconBadgeNumber = ++[UIApplication sharedApplication].applicationIconBadgeNumber;
            localNotif.repeatInterval = 0;
            [[UIApplication sharedApplication]  presentLocalNotificationNow:localNotif];
        }
        
    }
    
    
}

+ (NSString *)stringWithDicStr:(NSString *)str{
    if (str) {
        return [NSString stringWithFormat:@"%@",str];
    }
    else{
        return @"";
    }
}

- (void)showQRViewWithBlock:(EmptyActionBlock)block{
    
}
//
//- (void)showDeviceToolWithInfo:(Device *)infoDic andEnventBlock:(ResultBlock)block{
//    SensDeviceToolView *deviceView = [[SensDeviceToolView alloc]initWithFrame:CGRectMake(0, 0, OAScreen.size.width, 230)];
//    [deviceView setInfoValue:infoDic];
//    [deviceView setResultBlock:block];
//    [self addEmptyViewWithFrame:deviceView.frame andFadeView:deviceView];
//}



@end
