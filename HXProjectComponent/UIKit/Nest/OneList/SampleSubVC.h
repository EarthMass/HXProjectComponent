//
//  SampleSubVC.h
//  GKScrollViewTest
//
//  Created by Guo on 2022/4/28.
//

#import <UIKit/UIKit.h>
#import <GKPageScrollView/GKPageScrollView.h>
#import <MJRefresh/MJRefresh.h>

NS_ASSUME_NONNULL_BEGIN

@interface SampleSubVC : UIViewController<GKPageListViewDelegate>

- (void)refreshHeader:(MJRefreshHeader *)header;

- (void)updateBottomViewOffset:(CGFloat)offset;

@end

NS_ASSUME_NONNULL_END
