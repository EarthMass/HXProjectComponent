//
//  MutiNestVC.m
//  GKScrollViewTest
//
//  Created by Guo on 2022/5/10.
//

#import "MutiNestVC.h"
#import <GKPageScrollView/GKPageScrollView.h>
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import <JXCategoryView.h>

#import "MutiNestSubItemVC.h"
#import "UIMicro.h"

@interface MutiNestVC ()<GKPageScrollViewDelegate,UIScrollViewDelegate, JXCategoryViewDelegate>
@property (nonatomic, strong) GKPageScrollView * pageScrollView;

@property (nonatomic, strong) UILabel * headerView;
@property (nonatomic, strong) JXCategoryTitleView   * categoryView;
@property (nonatomic, strong) UIScrollView * containerScr; //容器

@property (nonatomic, strong) NSMutableArray * childVCs; //子视图
@property (nonatomic, strong) NSMutableArray * titleArr;

@end

@implementation MutiNestVC

#pragma mark- cycle life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- initUI
- (void)setupView {
    
    [self.view addSubview:self.pageScrollView];
    [self.pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.top.offset(kNavBar_Height);
        make.left.right.bottom.offset(0);
    }];
    
    //模拟分段数量
    self.titleArr = [NSMutableArray arrayWithArray:@[@"标题1",@"标题2",@"标题3",@"标题4",@"标题5",@"标题6",@"标题7",@"标题8",@"标题9"]];
    self.categoryView.titles = self.titleArr;
    self.categoryView.contentScrollView = self.pageScrollView.listContainerView.collectionView;
    
    //初始化头部
    self.headerView.text = @"这是头部视图";
    self.headerView.backgroundColor = [UIColor lightGrayColor];
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 200);
    
    //添加视图
    for (int i = 0; i < self.titleArr.count; i++) {
        MutiNestSubItemVC * subVC = [[MutiNestSubItemVC alloc] init];
        [self.childVCs addObject:subVC];
    }
    
    CGFloat scrollH = kScreenHeight - kNavBar_Height - 40;
    __weak typeof(self) weakSelf = self;
    [_containerScr.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.childVCs enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addChildViewController:vc];
        [weakSelf.containerScr addSubview:vc.view];
        
        vc.view.frame = CGRectMake(idx * kScreenWidth, 0, kScreenWidth, scrollH);
    }];
    _containerScr.contentSize = CGSizeMake(kScreenWidth * self.childVCs.count, 0);
    
    [self.pageScrollView reloadData];
    
    //更新seg
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.titleArr = [NSMutableArray arrayWithArray:@[@"标题11",@"标题22"]];
//        self.categoryView.titles = self.titleArr;
//        self.categoryView.contentScrollView = self.pageScrollView.listContainerView.collectionView;
//        [self.categoryView reloadData];
//
//        //添加视图
//        [self.childVCs removeAllObjects];
//        for (int i = 0; i < self.titleArr.count; i++) {
//            MutiSubItemVC * subVC = [[MutiSubItemVC alloc] init];
//
//            [self.childVCs addObject:subVC];
//        }
//        [self.pageScrollView refreshSegmentedView];
//        [self.pageScrollView reloadData];
//    });
    
//    //更新头部
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 200);
//        [self.pageScrollView reloadData];
//    });
}

#pragma mark- Event

#pragma mark- GKPageScrollViewDelegate
- (NSInteger)numberOfListsInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.titleArr.count;
}

- (UIView *)pageViewInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.pageScrollView;
}
- (UIView *)headerViewInPageScrollView:(GKPageScrollView *)pageScrollView {
    
    return self.headerView;
}
- (UIView *)segmentedViewInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.categoryView;
}
- (BOOL)shouldLazyLoadListInPageScrollView:(GKPageScrollView *)pageScrollView {
    return YES;
}
- (id<GKPageListViewDelegate>)pageScrollView:(GKPageScrollView *)pageScrollView initListAtIndex:(NSInteger)index {
 
    return self.childVCs[index];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.pageScrollView horizonScrollViewWillBeginScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.pageScrollView horizonScrollViewDidEndedScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.pageScrollView horizonScrollViewDidEndedScroll];
}

#pragma mark- JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"滚动/或点击到分段 %ld",(long)index);
}
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"点击分段 %ld",(long)index);
}

#pragma mark- Lazy
- (GKPageScrollView *)pageScrollView {
    if (!_pageScrollView) {
        _pageScrollView = [[GKPageScrollView alloc] initWithDelegate:self];
        _pageScrollView.ceilPointHeight = 0;//50;
        _pageScrollView.allowListRefresh = YES; //NO为主视图刷新
        
        [_pageScrollView addSubview:self.categoryView];
        [_pageScrollView addSubview:self.containerScr];
    }
    return _pageScrollView;
}

- (UILabel *)headerView {
    if (!_headerView) {
        _headerView = [[UILabel alloc] init];
    }
    return _headerView;
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40.0f)];
        _categoryView.titles = self.titleArr;
        _categoryView.delegate = self;
        _categoryView.titleColor = [UIColor blackColor];
        _categoryView.titleSelectedColor = GKColorRGB(200, 38, 39);
        _categoryView.titleFont = [UIFont systemFontOfSize:16.0f];
        _categoryView.titleSelectedFont = [UIFont boldSystemFontOfSize:16.0f];
//        _categoryView.cellChangeInHalf = YES;   // 当scrollView滑动到一半时改变cell状态
        
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = GKColorRGB(200, 38, 39);
        lineView.indicatorWidth = 30.0f;
        lineView.lineStyle = JXCategoryIndicatorLineStyle_Lengthen;
        _categoryView.indicators = @[lineView];
        
        _categoryView.contentScrollView = self.containerScr;
     
        // 添加分割线
        UIView *btmLineView = [UIView new];
        btmLineView.frame = CGRectMake(0, 40 - 0.5, kScreenWidth, 0.5);
        btmLineView.backgroundColor = GKColorGray(200);
        [_categoryView addSubview:btmLineView];
    }
    return _categoryView;
}

- (UIScrollView *)containerScr {
    if (!_containerScr) {
        _containerScr = [[UIScrollView alloc] init];
        _containerScr.delegate = self;
    }
    return _containerScr;
}

- (NSMutableArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [[NSMutableArray alloc] init];
    }
    return _titleArr;
}

- (NSMutableArray *)childVCs {
    if (!_childVCs) {
        _childVCs = [[NSMutableArray alloc] init];
    }
    return _childVCs;
}


@end

