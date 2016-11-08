//
//  AlertShowView.h
//  Created by taojin on 15/7/9.
//

#import <UIKit/UIKit.h>
#import "SensDeviceToolView.h"

typedef void(^SheetViewBlock)(id sender,NSInteger row,NSString *title);//row>=-1
typedef void(^SheetActionBlock)(NSInteger row,NSString *title);
typedef void(^EmptyActionBlock)(id obj,id obj2,id obj3);

@interface AlertShowView : UIView<UIScrollViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>


@property (nonatomic ,strong) UILabel *title;

+ (AlertShowView *) sharedInstance;


/**
 所选周的第一天（周一）
 */
- (NSDate *)getWeekBeginWith:(NSDate *)seledate;

- (void)showNotifWith:(NSString *)message andInfo:(NSDictionary *)info;
/**
 空的View
 */
- (void)addEmptyViewWithFrame:(CGRect)frame andFadeView:(UIView *)fview;
- (void)removeEmptyViewWithFadeView:(UIView *)fview;
- (void)moveEmptyViewWithFadeView:(UIView *)fview andHeight:(CGFloat)height;
/**
 屏幕中间的btn列表
 */
- (void)addSheetBtnViewWtihTitles:(NSArray *)titles andViewSize:(CGSize)viewsize andEvent:(SheetActionBlock)eventblock;
/**
 系统sheetView
 */
- (void)showSheetInView:(UIView *)view WithTitle:(NSString *)title andButton:(NSArray *)buttons andEnventBlock:(SheetActionBlock)enventblock;
- (void)showSheetWithTitle:(NSString *)title andButton:(NSArray *)buttons andEnventBlock:(SheetActionBlock)enventblock;
/**
 view加线
 */
+ (void)addLineWithView:(UIView *)view andColor:(UIColor *)color;
/**
 view加圆角
 */
+ (void)addCornerWithView:(UIView *)sview andRadius:(CGFloat)radius;
/**
 弹小框
 */
- (void)showMiniSheetViewWithView:(UIView *)sview andTitles:(NSArray *)titleArr andEvent:(SheetViewBlock)eventblock;
/**
 弹小框和尺寸
 */
- (void)showMiniSheetViewWithView:(UIView *)sview andOffset:(CGPoint)offset andViewSize:(CGSize)viewsize andTitles:(NSArray *)titleArr andEvent:(SheetViewBlock)eventblock;

- (void)showBlockViewWithView:(UIView*)sview  customView:(UIView*)customView event:(SheetViewBlock)eventblock;
/**
 显示弹窗
 */
- (void)showInView:(UIView *)sview andMessage:(NSString *)message;
/**
 显示弹窗与显示时间
 */
- (void)showInView:(UIView *)sview andMessage:(NSString *)message andTime:(int)time;
/**
 显示弹窗与显示时间和位置
 */
- (void)showInView:(UIView *)sview andMessage:(NSString *)message andTime:(int)time andHeight:(NSInteger)height;
/**
 显示默认弹窗
 */
- (void)showMessage:(NSString *)message;
- (void)showSysMessage:(NSString *)message;
/**
 显示AlertView
 */
- (void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message andEnventBlock:(SheetActionBlock)enventblock;
- (void)showSWAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message andEnventBlock:(SheetActionBlock)enventblock;
/**
 显示AlertView,只有确认
 */
- (void)showAlertViewOnlySureWithTitle:(NSString *)title andMessage:(NSString *)message andEnventBlock:(SheetActionBlock)enventblock;
/**
 显示默认图片
 */
- (void)showImageView:(UIImage *)image;
/**
 * obj seleDate obj2 seleDateStr obj3 [NSDate date]
 */
- (void)showDateViewWithSeleDate:(NSDate *)seledate andStyle:(UIDatePickerMode)datePickerMode andEnventBlock:(EmptyActionBlock)emptyblock;
+ (NSString *)stringWithDicStr:(NSString *)str;

//
//- (void)showDeviceToolWithInfo:(Device *)infoDic andEnventBlock:(ResultBlock)block;
//- (void)showTextFiled:(NSString *)str ViewWithEnventBlock:(EmptyActionBlock)emptyblock;
//- (void)showActivityWithView:(UIView *)view;
//- (void)removeActivityWithView:(UIView *)view;
@end
