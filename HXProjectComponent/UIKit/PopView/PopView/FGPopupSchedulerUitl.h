//
//  FGPopupSchedulerUitl.h
//  FGPopupSchedulerDemo
//
//  Created by FoneG on 2021/6/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FGPopupScheduler.h"
NS_ASSUME_NONNULL_BEGIN

@interface FGPopupSchedulerUitl : NSObject

+ (FGPopupScheduler *)sharePopupScheduler;


+ (UIViewController *)findCurrentShowingViewController;

@end

NS_ASSUME_NONNULL_END
