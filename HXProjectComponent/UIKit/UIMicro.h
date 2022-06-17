//
//  UIMicro.h
//  HXProjectComponent
//
//  Created by Guo on 2022/6/6.
//

#ifndef UIMicro_h
#define UIMicro_h


//  适配比例
#define ADAPTATIONRATIO     kScreenWidth / 750.0f

// 颜色
#define GKColorRGBA(r, g, b, a) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a]
#define GKColorRGB(r, g, b)     GKColorRGBA(r, g, b, 1.0)
#define GKColorGray(v)          GKColorRGB(v, v, v)

#define GKColorHEX(hexValue, a) GKColorRGBA(((float)((hexValue & 0xFF0000) >> 16)), ((float)((hexValue & 0xFF00) >> 8)), ((float)(hexValue & 0xFF)), a)

#define GKColorRandom           GKColorRGB(arc4random() % 255, arc4random() % 255, arc4random() % 255)

#define HEXCOLOR(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0  blue:((float)(hexValue & 0xFF))/255.0 alpha:a]

#define kRefreshDuration   0.5f

#define kBaseHeaderHeight  kScreenWidth * 385.0f / 704.0f
#define kBaseSegmentHeight 40.0f

#pragma mark- 尺寸适配宏

//判断是否是ipad
#define kIsPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define IS_INPHONEX_LATER  (([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896 || [UIScreen mainScreen].bounds.size.height > 812) && !kIsPad)

//iPhoneX系列
#define kStatusBar_Height (IS_INPHONEX_LATER ? 44.0 : 20.0)
#define kNavBar_Height (IS_INPHONEX_LATER ? 88.0 : 64.0)
#define kNavBarNoStatusBar_Height (kNavBar_Height - kStatusBar_Height)
#define kTabBar_Height (IS_INPHONEX_LATER ? 83.0 : 49.0)
#define kSafeArea_Height (IS_INPHONEX_LATER ? 34.f : 0.f) //底部安全区域

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height





#endif /* UIMicro_h */
