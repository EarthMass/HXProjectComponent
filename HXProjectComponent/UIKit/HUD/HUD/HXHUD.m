//
//  HXHUD.m
//  QiangHongBao
//
//  Created by Guo on 2022/6/6.
//

#import "HXHUD.h"
#if __has_include(<SDWebImage/SDWebImage.h>)
#import <SDWebImage/SDWebImage.h>
#endif
#import "HXHUDImgView.h"
#import "FGPopupSchedulerUitl.h"

@interface HXHUD ()


@end

@implementation HXHUD

+(instancetype)shareInstance{
    
    static HXHUD *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HXHUD alloc] init];
        instance.ignoreTime = 0.5;
    });
    
    return instance;
}

+ (void)defaultSetting {
    //这里设置是否显示遮罩层
    //[HBHUD shareInstance].hud.dimBackground = YES;    //是否显示透明背景
    
    //是否设置黑色背景，这两句配合使用
    [HXHUD shareInstance].hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    [HXHUD shareInstance].hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [HXHUD shareInstance].hud.contentColor = [UIColor whiteColor];
    
    [HXHUD shareInstance].hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    
    [[HXHUD shareInstance].hud setMargin:10];
    [[HXHUD shareInstance].hud setRemoveFromSuperViewOnHide:YES];
}

+(void)show:(NSString *)msg inView:(UIView *)view mode:(HXProgressMode)myMode customImgView:(UIImageView *)customImgView{
    //如果已有弹框，先消失
    if ([HXHUD shareInstance].hud != nil) {
        [[HXHUD shareInstance].hud hideAnimated:NO];
        [HXHUD shareInstance].hud = nil;
    }
    
    //4\4s屏幕避免键盘存在时遮挡
    //    if ([UIScreen mainScreen].bounds.size.height == 480) {
    //        [view endEditing:YES];
    //    }
    
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    if (myMode == HXProgressModelProgress) {
        [HXHUD shareInstance].hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        [HXHUD shareInstance].hud.mode = MBProgressHUDModeAnnularDeterminate;
        [HXHUD shareInstance].hud.detailsLabel.text = msg;
        [self defaultSetting];
        return;
    }
    
    [HXHUD shareInstance].hud = [MBProgressHUD showHUDAddedTo:view animated:YES];

    [self defaultSetting];
    
    [HXHUD shareInstance].hud.detailsLabel.text = msg;
    
    switch ((NSInteger)myMode) {
        case HXProgressModeOnlyText:
        {
            [HXHUD shareInstance].hud.mode = MBProgressHUDModeText;
            UITapGestureRecognizer * tapDis = [[UITapGestureRecognizer alloc] initWithTarget:[HXHUD shareInstance] action:@selector(tapDismiss:)];
            [[HXHUD shareInstance].hud.backgroundView addGestureRecognizer:tapDis];
            [[HXHUD shareInstance].hud addGestureRecognizer:tapDis];
        }
            break;
            
        case HXProgressModeLoading:
        {
            [HXHUD shareInstance].hud.mode = MBProgressHUDModeIndeterminate;
        }
            break;
            
        case HXProgressModeCircle:{
            [HXHUD shareInstance].hud.mode = MBProgressHUDModeCustomView;
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading"]];
            CABasicAnimation *animation= [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            animation.toValue = [NSNumber numberWithFloat:M_PI*2];
            animation.duration = 1.0;
            animation.repeatCount = 100;
            [img.layer addAnimation:animation forKey:nil];
            [HXHUD shareInstance].hud.customView = img;
            
        }
            break;
            
        case HXProgressModeCustomerImage:
        {
            [HXHUD shareInstance].hud.mode = MBProgressHUDModeCustomView;
            [HXHUD shareInstance].hud.customView = customImgView;
        }
            break;
            
        case HXProgressModeCustomAnimation:
        {
            //这里设置动画的背景色
            [HXHUD shareInstance].hud.bezelView.color = [UIColor clearColor];
            [HXHUD shareInstance].hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
            [HXHUD shareInstance].hud.mode = MBProgressHUDModeCustomView;
            [HXHUD shareInstance].hud.customView = customImgView;
        }
            break;
            
        case HXProgressModeSuccess:
        {
            [HXHUD shareInstance].hud.mode = MBProgressHUDModeCustomView;
            [HXHUD shareInstance].hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
        }
            break;
            
        default:
            break;
    }
    
    if (myMode != HXProgressModeOnlyText) {
        [HXHUD shareInstance].hud.hidden = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([HXHUD shareInstance].ignoreTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HXHUD shareInstance].hud.hidden = NO;
        });
    }
}

#pragma mark- 文本
+(void)showText:(NSString *)msg {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    [self showText:msg inView:nil duration:2 postition:HXProgressPositionCenter];
#pragma clang diagnostic pop
    
}
+(void)showText:(NSString *)msg inView:(UIView *)inView duration:(CGFloat)duration {
    [self showText:msg inView:inView duration:duration postition:HXProgressPositionCenter];
}
+(void)showText:(NSString *)msg postition:(HXProgressPosition)postition {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    [self showText:msg inView:nil duration:2 postition:postition];
#pragma clang diagnostic pop
}
+(void)showText:(NSString *)msg
         inView:(UIView *)inView
       duration:(CGFloat)duration
      postition:(HXProgressPosition)postition {
    
    [self show:msg inView:inView mode:HXProgressModeOnlyText customImgView:nil];
    switch (postition) {
        case HXProgressPositionTop:
        {
            [HXHUD shareInstance].hud.offset = CGPointMake(0, -[UIScreen mainScreen].bounds.size.height/2 + 60);
        }
            break;
        case HXProgressPositionCenter:
        {
            [HXHUD shareInstance].hud.offset = CGPointMake(0, 0);
        }
            break;
        case HXProgressPositionBottom:
        {
            [HXHUD shareInstance].hud.offset = CGPointMake(0, [UIScreen mainScreen].bounds.size.height/2 - 20);
        }
            break;
            
        default: {
            [HXHUD shareInstance].hud.offset = CGPointMake(0, 0);
        }
            break;
    }
    
    [[HXHUD shareInstance].hud hideAnimated:YES afterDelay:duration];
    [[HXHUD shareInstance].hud setCompletionBlock:^{
        [HXHUD shareInstance].hud = nil;
    }];
}

#pragma mark- 加载中
+ (void)showHud {
    [self show:@"加载中..." inView:nil mode:HXProgressModeLoading customImgView:nil];
}
+ (void)showHud:(NSString *)msg {
    [self show:msg inView:nil mode:HXProgressModeLoading customImgView:nil];
}

#pragma mark- 自定义图片
+ (void)showHudWithImage:(NSString *)imageName {
    HXHUDImgView *bgImageView = [[HXHUDImgView alloc] init];
    UIImage *image = [UIImage imageNamed:imageName];
    bgImageView.image = image;
    [self show:nil inView:nil mode:HXProgressModeCustomerImage customImgView:bgImageView];
}

#pragma mark- 自定义
+(void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray <NSString *> *)imgArry inview:(UIView *)view{
    
    HXHUDImgView *showImageView = [[HXHUDImgView alloc] init];
    
    NSMutableArray * imgArr = [NSMutableArray array];
    for (NSString * imgName in imgArry) {
        if ([UIImage imageNamed:imgName]) {
            [imgArr addObject:[UIImage imageNamed:imgName]];
        }
    }
    showImageView.animationImages = imgArr;
    [showImageView setAnimationRepeatCount:0];
    [showImageView setAnimationDuration:(imgArr.count + 1) * 0.075];
    [showImageView startAnimating];
    
    [self show:msg inView:view mode:HXProgressModeCustomAnimation customImgView:showImageView];
}
//显示自定义动画(gif)
+(void)showCustomGif:(NSString *)gifName {
    HXHUDImgView *bgImageView = [[HXHUDImgView alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_imageWithData:data];
    bgImageView.image = image;
    [self show:nil inView:nil mode:HXProgressModeCustomAnimation customImgView:bgImageView];
    
}
+ (void)showCustomGif {
    [self showCustomGif:@"loading"];
}

+ (void)showImg:(NSString *)imgName msg:(NSString *)msg {
    
    HXHUDImgView *bgImageView = [[HXHUDImgView alloc] init];
    UIImage *image = [UIImage imageNamed:imgName];
    bgImageView.image = image;
    [self show:msg inView:nil mode:HXProgressModeCustomerImage customImgView:bgImageView];
    
}

#pragma mark- 进度
+(HXHUD *)showProgress:(NSString *)msg inView:(UIView *)view {
    [self show:msg inView:view mode:HXProgressModelProgress customImgView:nil];
    return [HXHUD shareInstance];
}



+(void)hide{
    if ([HXHUD shareInstance].hud != nil) {
        
        [[HXHUD shareInstance].hud hideAnimated:NO];
        [[HXHUD shareInstance].hud setCompletionBlock:^{
            [HXHUD shareInstance].hud = nil;
        }];
        
    }
}
#pragma mark- Tap
- (void)tapDismiss:(UITapGestureRecognizer *)ges {
    [HXHUD hide];
}


@end
