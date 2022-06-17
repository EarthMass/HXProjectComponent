//
//  MutiNestSubItemVC.m
//  GKScrollViewTest
//
//  Created by Guo on 2022/5/10.
//

#import "MutiNestSubItemVC.h"

#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>

#import "UIMicro.h"

@interface MutiNestSubItemVC ()<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (nonatomic, strong) UITableView * tableV;
@property (nonatomic, strong) NSMutableArray * dataArr;

@property (nonatomic, copy) void(^listScrollViewScrollCallback)(UIScrollView *scrollView);

@property (nonatomic, strong) UILabel * bottomView;

@end

@implementation MutiNestSubItemVC

#pragma mark- cycle life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- initUI
- (void)initUI {
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(40);
        make.bottom.offset(-kSafeArea_Height - self.headerViewHeight);
    }];
    self.bottomView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:self.tableV];
    [_tableV mas_makeConstraints:^(MASConstraintMaker * make) {
//        make.edges.equalTo(self.view);
        make.top.offset(0);
        make.left.right.offset(0);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];

    for (int i = 0; i < 30; i ++) {
        [self.dataArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    [self.tableV reloadData];
    
    __weak typeof(self) weakSelf = self;
    _tableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weakSelf.tableV.mj_header endRefreshing];
            [self.dataArr removeAllObjects];
            [self.tableV reloadData];
        });

    }];
    _tableV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableV.mj_footer endRefreshing];
        });
    }];
    
}

//更新底部视图的位置
- (void)updateBottomViewOffset:(CGFloat)offset {
//    [UIView performWithoutAnimation:^{
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.bottom.offset(-kSafeArea_Height + offset - self.headerViewHeight);
        }];
//    }];
}

#pragma mark -TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.isEmpty = (self.dataArr.count == 0)?YES:NO;
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"XXX";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSString * item = self.dataArr[indexPath.row];
    cell.textLabel.text = item;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
    
}

#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //点击cell操作
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    //隐藏多余的cell分割线
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    //    [tableView setTableHeaderView:view];
    
}

#pragma mark- GKPageListViewDelegate
- (UIView *)listView {
    return self.view;
}
- (UIScrollView *)listScrollView {
    return self.tableV;
}
- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.listScrollViewScrollCallback = callback;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.listScrollViewScrollCallback ? : self.listScrollViewScrollCallback(scrollView);
}


#pragma mark- Event

#pragma mark- Setting Getting

- (UITableView *)tableV {
    if (!_tableV) {
        
        _tableV = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        [self setExtraCellLineHidden:_tableV];
        
        _tableV.estimatedRowHeight = 60;
        _tableV.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableV;
}




- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}



- (UILabel *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UILabel alloc] init];
        _bottomView.text = @"底部固定视图";
        _bottomView.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomView;
}


@end
