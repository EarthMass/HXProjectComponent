//
//  PinLocationVC.m
//  GKScrollViewTest
//
//  Created by Guo on 2022/4/19.
//

#import "PinLocationVC.h"
#import <GKPageSmoothView/GKPageSmoothView.h>
#import "GKPinLocationView.h"
#import "JXCategoryPinTitleView.h"

#import <Masonry/Masonry.h>
#import <JXCategoryView/JXCategoryView.h>
#import "UIMicro.h"

@interface PinLocationVC ()<GKPageSmoothViewDataSource, GKPageSmoothViewDelegate, JXCategoryViewDelegate, GKPinLocationViewDelegate>

@property (nonatomic, strong) GKPageSmoothView *smoothView;

@property (nonatomic, strong) UIImageView *headerView;

@property (nonatomic, strong) JXCategoryPinTitleView *titleView;

@property (nonatomic, assign) BOOL isAnimation;

@end

@implementation PinLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    [self.view addSubview:self.smoothView];
    [self.smoothView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.top.offset(kNavBar_Height);
        make.left.right.bottom.offset(0);
    }];
    
    [self.smoothView reloadData];
    
    //刷新头部
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        CGRect newFrame = self.headerView.frame;
//        newFrame.size.height = 300;
//        self.headerView.frame = newFrame;
//
//        [self.smoothView refreshHeaderView];
//        [self.smoothView reloadData];
//    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        CGRect newFrame = self.headerView.frame;
//        newFrame.size.height = 100;
//        self.headerView.frame = newFrame;
//
//        [self.smoothView refreshHeaderView];
//        [self.smoothView reloadData];
//    });
}

- (void)oriAction {
    [self.smoothView scrollToOriginalPoint];
    self.isAnimation = YES;
}

- (void)criAction {
    [self.smoothView scrollToCriticalPoint];
    self.isAnimation = YES;
}

#pragma mark - GKPageSmoothViewDataSource
- (UIView *)headerViewInSmoothView:(GKPageSmoothView *)smoothView {
    return self.headerView;
}

- (UIView *)segmentedViewInSmoothView:(GKPageSmoothView *)smoothView {
    return self.titleView;
}

- (NSInteger)numberOfListsInSmoothView:(GKPageSmoothView *)smoothView {
    return 1;
}

- (id<GKPageSmoothListViewDelegate>)smoothView:(GKPageSmoothView *)smoothView initListAtIndex:(NSInteger)index {
    GKPinLocationView *listView = [[GKPinLocationView alloc] init];
    listView.delegate = self;
    
    NSMutableArray *data = [NSMutableArray new];
    NSArray *counts = @[@(6), @(8), @(9), @(5), @(7), @(10), @(13), @(6), @(8)];
    for (int i = 0; i < self.titleView.titles.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic[@"title"] = self.titleView.titles[i];
        dic[@"count"] = counts[i];
        [data addObject:dic];
    }
    listView.data = data;
    return listView;
}

#pragma mark - GKPageSmoothViewDelegate
- (void)smoothView:(GKPageSmoothView *)smoothView listScrollViewDidScroll:(UIScrollView *)scrollView contentOffset:(CGPoint)contentOffset {
    if (!self.isAnimation) {
        if (!(scrollView.isTracking || scrollView.isDecelerating)) return;
    }
    
    //collectionView
//    CGFloat categoryH = self.titleView.frame.size.height;
//
//    UICollectionView * collectionView = (UICollectionView *)scrollView;
//    NSIndexPath *topIndexPath = [collectionView indexPathForItemAtPoint:CGPointMake(30, contentOffset.y + categoryH - self.headerView.frame.size.height + 10)];
//    NSUInteger topSection = topIndexPath.section;
//    if (topIndexPath != nil) {
//        if (self.titleView.selectedIndex != topSection) {
//            [self.titleView selectItemAtIndex:topSection];
//        }
//    }
    
    //用户滚动的才处理
    //获取categoryView下面一点的所有布局信息，用于知道，当前最上方是显示的哪个section
//    CGFloat categoryH = self.titleView.frame.size.height;
    UITableView *tableView = (UITableView *)scrollView;
    NSArray <NSIndexPath *> *topIndexPaths = [tableView indexPathsForRowsInRect:CGRectMake(0, [self offsetYScrWithY:contentOffset.y], tableView.frame.size.width, 200)];
    
    NSIndexPath *topIndexPath = topIndexPaths.firstObject;
    NSUInteger topSection = topIndexPath.section;
    if (topIndexPath != nil) {
        if (self.titleView.selectedIndex != topSection) {
            [self.titleView selectItemAtIndex:topSection];
        }
    }
   
}

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    
    //collectionView
//    UICollectionView * collectionView = (UICollectionView *)self.smoothView.currentListScrollView;
//
//    UICollectionViewLayoutAttributes *attributes = [collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
//    CGRect rect = attributes.frame;
//
//    // 50为sectionHeader高度
//    CGFloat offsetY = rect.origin.y - 50 - self.titleView.frame.size.height;
//    CGFloat maxOffsetY = collectionView.contentSize.height - collectionView.frame.size.height;
//    if (offsetY > maxOffsetY) {
//        offsetY = maxOffsetY;
//    };
//
//    [collectionView setContentOffset:CGPointMake(collectionView.frame.origin.x, offsetY) animated:YES];
    
    //tableView
    UITableView *tableView = (UITableView *)self.smoothView.currentListScrollView;
    CGRect frame = [tableView rectForHeaderInSection:index];
    
    CGFloat offsetY =  [self offsetClickWithY:frame.origin.y];
    CGFloat maxOffsetY = tableView.contentSize.height - tableView.frame.size.height;
    if (offsetY > maxOffsetY) {
        offsetY = maxOffsetY;
    }
    
    [tableView setContentOffset:CGPointMake(0, offsetY) animated:YES];
}

//40为section高度
/// 偏移点击
- (CGFloat)offsetClickWithY:(CGFloat)y {
    return y - self.headerView.frame.size.height + self.titleView.frame.size.height + 40 + kNavBar_Height - _smoothView.ceilPointHeight;
}
/// 偏移滚动
- (CGFloat)offsetYScrWithY:(CGFloat)y {
    return y + self.titleView.frame.size.height - self.headerView.frame.size.height - 40; //+ 50 + 10;
}

#pragma mark - GKPinLocationViewDelegate
- (void)locationViewDidEndAnimation:(UIScrollView *)scrollView {
    self.isAnimation = NO;
}

#pragma mark - 懒加载
- (GKPageSmoothView *)smoothView {
    if (!_smoothView) {
        _smoothView = [[GKPageSmoothView alloc] initWithDataSource:self];
        _smoothView.ceilPointHeight = 0;//50;
        _smoothView.delegate = self;
    }
    return _smoothView;
}

- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBaseHeaderHeight)];
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
        _headerView.clipsToBounds = YES;
        _headerView.image = [UIImage imageNamed:@"test"];
        _headerView.backgroundColor = [UIColor brownColor];
    }
    return _headerView;
}

- (JXCategoryPinTitleView *)titleView {
    if (!_titleView) {
        _titleView = [JXCategoryPinTitleView new];
        _titleView.backgroundColor = UIColor.whiteColor;
        _titleView.frame = CGRectMake(0, 0, kScreenWidth, kBaseSegmentHeight);
//        _titleView.titles = @[@"年货市集", @"新年换新", @"安心过年", @"爆品专区", @"尝鲜专区", @"贺岁大餐", @"超值外卖", @"玩乐特惠", @"商超年货"];
        _titleView.titles = @[@"年货市集", @"新年换新", @"安心过年",@"爆品专区"];
//        _titleView.pinImage = [UIImage gk_changeImage:[UIImage imageNamed:@"location"] color:UIColor.redColor];
        _titleView.titleColor = UIColor.grayColor;
        _titleView.titleSelectedColor = UIColor.redColor;
        _titleView.titleFont = [UIFont systemFontOfSize:15];
        _titleView.delegate = self;
    }
    return _titleView;
}


@end
