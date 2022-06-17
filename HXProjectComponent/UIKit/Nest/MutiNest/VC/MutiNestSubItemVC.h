//
//  MutiNestSubItemVC.h
//  GKScrollViewTest
//
//  Created by Guo on 2022/5/10.
//

#import <UIKit/UIKit.h>
#import <GKPageScrollView/GKPageScrollView.h>
NS_ASSUME_NONNULL_BEGIN

@interface MutiNestSubItemVC : UIViewController<GKPageListViewDelegate>


/// 空页面更新 外层高度
@property (nonatomic, assign) BOOL isEmpty;

/// 底部固定视图
//外层视图头部高度
@property (nonatomic, assign) CGFloat headerViewHeight;
//更新底部视图的位置
- (void)updateBottomViewOffset:(CGFloat)offset;

@end

NS_ASSUME_NONNULL_END
