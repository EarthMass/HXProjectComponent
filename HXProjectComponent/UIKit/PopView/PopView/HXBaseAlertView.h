//
//  HXBaseAlertView.h
//  QiangHongBao
//
//  Created by Guo on 2022/5/17.
//

#import <UIKit/UIKit.h>
#import <zhPopupController/zhPopupController.h>
#import "FGPopupSchedulerUitl.h"

@protocol HXBaseAlertViewDelegate <NSObject>

- (UIView *)customView;
- (void)show;
- (void)showInView:(UIView *)view;
- (void)dissmiss;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HXBaseAlertView : UIView <HXBaseAlertViewDelegate>

@property (nonatomic, strong, readonly) zhPopupController * pop;
/// 对齐方式
@property (nonatomic, assign) zhPopupLayoutType layoutType;
/// 弹出方向
@property (nonatomic, assign) zhPopupSlideStyle presentationStyle;
/// 点击空白区域是否消失 default YES
@property (nonatomic, assign) BOOL dismissOnMaskTouched;

/// 是否开启优先级 同时只显示一个 default NO
@property (nonatomic, assign) BOOL priority;

@end

NS_ASSUME_NONNULL_END
