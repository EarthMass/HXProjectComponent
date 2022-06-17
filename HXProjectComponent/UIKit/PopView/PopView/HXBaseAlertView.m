//
//  HXBaseAlertView.m
//  QiangHongBao
//
//  Created by Guo on 2022/5/17.
//

#import "HXBaseAlertView.h"


@interface HXBaseAlertView ()<FGPopupView>

@property (nonatomic, strong) zhPopupController * pop;
@property (nonatomic, strong) UIView * showInView;

@end

@implementation HXBaseAlertView
#pragma mark- init
- (instancetype)init {
    if (self = [super init]) {
        self.layoutType = zhPopupLayoutTypeBottom;
        self.presentationStyle = zhPopupSlideStyleFromBottom;
        self.dismissOnMaskTouched = YES;
    }
    return self;
}

#pragma mark- Delegate
- (UIView *)customView {
    return self;
}
- (void)show {
    
    if (self.priority) {
        [[FGPopupSchedulerUitl sharePopupScheduler] add:self];
        [FGPopupSchedulerUitl sharePopupScheduler].suspended = NO;
    } else {
        [self showPopupView];
    }
   
    
}
- (void)showInView:(UIView *)view {
    self.showInView = view;
    if (self.priority) {
        [[FGPopupSchedulerUitl sharePopupScheduler] add:self];
        [FGPopupSchedulerUitl sharePopupScheduler].suspended = NO;
    }
}
- (void)dissmiss {
    [self dismissPopupView];
}
#pragma mark- FGPopupView
- (void)showPopupView{
    
    [self setupView];
    if (self.showInView) {
        [self.pop showInView:self.showInView completion:nil];
    } else {
        [self.pop show];
    }
}

- (void)dismissPopupView{
    [self.pop dismiss];
    [self.pop dismissWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut completion:^{
        
    }];
}
- (FGPopupViewUntriggeredBehavior)popupViewUntriggeredBehavior{
    return FGPopupViewUntriggeredBehaviorAwait; //未显示继续等待
}
- (FGPopupViewSwitchBehavior)popupViewSwitchBehavior{
    return FGPopupViewSwitchBehaviorAwait; //后面一个优先级更高，不抛弃这个
}

#pragma mark- setupView
- (void)setupView {
    UIView * cusView = [self customView];
    self.pop = [[zhPopupController alloc] initWithView:cusView size:cusView.bounds.size];
    self.pop.panGestureEnabled = NO;
    self.pop.dismissOnMaskTouched = YES;
   
    self.pop.layoutType = self.layoutType;
    self.pop.presentationStyle = self.presentationStyle;
    self.pop.dismissOnMaskTouched = self.dismissOnMaskTouched;
    
    __weak typeof(self) weakSelf = self;
    [self.pop setDidDismissBlock:^(zhPopupController * _Nonnull popupController) {
        [weakSelf dismissPopupView];
    }];
    
}
#pragma mark- Event

#pragma mark- Lazy

@end

