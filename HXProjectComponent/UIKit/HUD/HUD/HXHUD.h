//
//  HXHUD.h
//  QiangHongBao
//
//  Created by Guo on 2022/6/6.
//

#import "MBProgressHUD.h"
#if __has_include(<MBProgressHUD/MBProgressHUD.h>)
#import <MBProgressHUD/MBProgressHUD.h>
#endif
#if __has_include("MBProgressHUD.h")
#import "MBProgressHUD.h"
#endif




NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,HXProgressMode){
    HXProgressModeOnlyText,           //文字
    HXProgressModeLoading,               //加载菊花
    HXProgressModeCircle,                //加载环形
    HXProgressModeCircleLoading,         //加载圆形-要处理进度值
    HXProgressModeCustomAnimation,       //自定义加载动画（序列帧实现）
    HXProgressModeSuccess,                //成功
    HXProgressModeCustomerImage,          //自定义图片
    HXProgressModelProgress,              //自定义图片
};

typedef NS_ENUM(NSInteger,HXProgressPosition)
{
    HXProgressPositionCenter,
    HXProgressPositionTop,
    HXProgressPositionBottom,
};

@interface HXHUD : NSObject

// 忽略时间
@property (nonatomic, assign) CGFloat ignoreTime;
@property (nonatomic,strong, nullable) MBProgressHUD  *hud;


+(instancetype)shareInstance;

#pragma mark- 文本
//文本显示
+(void)showText:(NSString *)msg;
+(void)showText:(NSString *)msg postition:(HXProgressPosition)postition;
+(void)showText:(NSString *)msg inView:(UIView *)inView duration:(CGFloat)duration;
+(void)showText:(NSString *)msg inView:(UIView *)inView duration:(CGFloat)duration postition:(HXProgressPosition)postition;

#pragma mark- 加载中
+ (void)showHud;
+ (void)showHud:(NSString *)msg;

#pragma mark- 自定义图片
+ (void)showHudWithImage:(NSString *)imageName;
//显示自定义动画(自定义动画序列帧)
+(void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray <NSString *> *)imgArry inview:(UIView *)view;
//显示自定义动画(gif)
+(void)showCustomGif:(NSString *)gifName;
+ (void)showCustomGif;

+ (void)showImg:(NSString *)imgName msg:(NSString *)msg;

#pragma mark- 进度
+(HXHUD *)showProgress:(NSString *)msg inView:(UIView *)view;


//隐藏
+(void)hide;

@end

NS_ASSUME_NONNULL_END
