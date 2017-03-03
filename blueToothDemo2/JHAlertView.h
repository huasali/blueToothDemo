//
//  JHAlertView.h
//  NetWorkDemo
//
//  Created by sensology on 2016/11/28.
//  Copyright © 2016年 李建华. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertActionBlock)(NSInteger row,NSString *title);
typedef void(^EmptyActionBlock)(id obj,id obj2,id obj3);

@interface JHAlertView : UIView

//Message
+ (instancetype)showMessage:(NSString *)message;

+ (instancetype)showInView:(UIView *)sview andMessage:(NSString *)message;

+ (instancetype)showInView:(UIView *)sview andMessage:(NSString *)message andTime:(int)time andHeight:(NSInteger)height;

////View
//+ (instancetype)showJumpViewWithTime:(NSNumber *)time;
//
//+ (instancetype)showRobotViewWithTime:(NSNumber *)time;
//
//+ (instancetype)showLodingViewWithTime:(NSNumber *)time andMessage:(NSString *)message;
//
//+ (instancetype)showView:(UIView *)aView inView:(UIView *)sview;
//
//+ (instancetype)showView:(UIView *)aView inView:(UIView *)sview andTime:(NSNumber *)time andHeight:(NSInteger)height;

+ (void)hideAllViewinView:(UIView *)sView;

//AlertView
+ (void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message;
+ (void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message inView:(UIView *)backView isCompletion:(void (^)(NSInteger buttonIndex))block;
+ (void)showSheetWithTitle:(NSString *)title andButton:(NSArray *)buttons inView:(UIView *)backView andEnventBlock:(AlertActionBlock)eventblock;

+ (void)showEmptyViewWithHeight:(CGFloat)btnHeight
                    andFadeView:(UIView *)fview
                 andEnventBlock:(EmptyActionBlock)emptyblock;

+ (void)showTextFiled:(NSString *)str
       andPlaceholder:(NSString *)placeholder
             andTitle:(NSString *)title
          andTempView:(UIView *)tempView
         isCompletion:(EmptyActionBlock)block;

+ (void)showSheetViewWtihTitles:(NSArray *)titles
                     andSeleRow:(int)seleRow
                    andViewSize:(CGSize)viewsize
                       andEvent:(AlertActionBlock)eventblock;
@end


