//
//  SampleVC.m
//  GKScrollViewTest
//
//  Created by Guo on 2022/4/28.
//

#import "SampleVC.h"
#import <GKPageScrollView/GKPageScrollView.h>
#import <Masonry/Masonry.h>
#import "SampleSubVC.h"
#import <MJRefresh/MJRefresh.h>
#import "UIMicro.h"

@interface SampleVC ()<GKPageScrollViewDelegate>

@property (nonatomic, strong) GKPageScrollView * pageView;

@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) SampleSubVC * subVc;



@end

@implementation SampleVC

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
    [self.view addSubview:self.pageView];
    [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.top.offset(kNavBar_Height);
        make.left.right.offset(0);
        make.bottom.offset(-kSafeArea_Height);
    }];
    
    [self.pageView reloadData];
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(self.pageView.mainTableView) weakTableV = self.pageView.mainTableView;
    self.pageView.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [weakSelf.subVc refreshHeader:weakTableV.mj_header];

    }];
//
//    self.pageView.mainTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [weakTableV.mj_footer endRefreshing];
//
////            [weakSelf.dataArr addObjectsFromArray:@[@"9999",@"1111"]];
////            [weakSelf.tableV reloadData];
//        });
//
//    }];
}

#pragma mark- Event

- (UIView *)headerViewInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.headerView;
}

- (BOOL)shouldLazyLoadListInPageScrollView:(GKPageScrollView *)pageScrollView {
    return YES;
}
/**
 返回中间的segmentedView

 @param pageScrollView pageScrollView description
 @return segmentedView
 */
- (UIView *)segmentedViewInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.titleView;
}
/**
 返回列表的数量

 @param pageScrollView pageScrollView description
 @return 列表的数量
 */
- (NSInteger)numberOfListsInPageScrollView:(GKPageScrollView *)pageScrollView {
    return 1;
}

/**
 根据index初始化一个列表实例，需实现`GKPageListViewDelegate`代理

 @param pageScrollView pageScrollView description
 @param index 对应的索引
 @return 实例对象
 */
- (id<GKPageListViewDelegate>)pageScrollView:(GKPageScrollView *)pageScrollView initListAtIndex:(NSInteger)index {

    return self.subVc;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.pageView horizonScrollViewWillBeginScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.pageView horizonScrollViewDidEndedScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.pageView horizonScrollViewDidEndedScroll];
}


#pragma mark- Lazy
- (GKPageScrollView *)pageView {
    if (!_pageView) {
        _pageView = [[GKPageScrollView alloc] initWithDelegate:self];
        _pageView.ceilPointHeight = 0;//50;
        _pageView.allowListRefresh = NO; //NO为主视图刷新
    }
    return _pageView;
}
- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, 100);
        _headerView.backgroundColor = [UIColor lightGrayColor];
    }
    return _headerView;
}
- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.frame = CGRectMake(0, 0, kScreenWidth, 60);
        _titleView.backgroundColor = [UIColor grayColor];
    }
    return _titleView;
}
- (SampleSubVC *)subVc {
    if (!_subVc) {
        _subVc = [[SampleSubVC alloc] init];
    }
    return _subVc;
}

@end
