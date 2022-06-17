//
//  HXAlertView.h
//  HXProjectComponent
//
//  Created by Guo on 2022/6/14.
//

#import "HXBaseAlertView.h"

//NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,HXAlertViewType)
{
    HXAlertViewTypeAlert,
    HXAlertViewTypeSheet,
};

@interface HXAlertViewAction : UIButton

- (id)init __attribute__((unavailable("init not available, call actionWithTitle instead")));
- (id)new __attribute__((unavailable("new not available, call actionWithTitle instead")));
- (id)initWithFrame:(CGRect)frame __attribute__((unavailable("new not available, call actionWithTitle instead")));

@property (nonatomic, copy, readonly) NSString * titleStr;

+ (HXAlertViewAction *)actionWithTitle:(NSString *)title blk:(void(^)(void))blk;

@end

@interface HXAlertView : HXBaseAlertView

- (id)init __attribute__((unavailable("init not available, call alertWithTitle instead")));
- (id)new __attribute__((unavailable("new not available, call alertWithTitle instead")));
- (id)initWithFrame:(CGRect)frame __attribute__((unavailable("new not available, call alertWithTitle instead")));

+ (HXAlertView *)alertWithTitle:(NSString *)title msg:(NSString *)msg withType:(HXAlertViewType)type;
- (void)addAction:(HXAlertViewAction *)action;

/// 自定义视图
/// @param title 标题
/// @param msg 描述
/// @param cusView 自定义视图，只需要设置高度就好了，其他自适应
/// @param type 类型
+ (HXAlertView *)alertWithTitle:(NSString *)title msg:(NSString *)msg cusView:(UIView *)cusView withType:(HXAlertViewType)type;

@end

//NS_ASSUME_NONNULL_END
