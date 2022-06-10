//
//  SampleSubVC.m
//  GKScrollViewTest
//
//  Created by Guo on 2022/4/28.
//

#import "SampleSubVC.h"
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>

@interface SampleSubVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableV;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, strong) MJRefreshHeader * mainTableViewHeader; //外部列表的头部刷新

@property (nonatomic, copy) void(^listScrollViewScrollCallback)(UIScrollView *scrollView);

@end

@implementation SampleSubVC

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
//    NSLog(@"scrollView.contentOffset.y %f",scrollView.contentOffset.y);
    !self.listScrollViewScrollCallback ? : self.listScrollViewScrollCallback(scrollView);
}

- (void)refreshHeader:(MJRefreshHeader *)header {
    self.mainTableViewHeader = header;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [header endRefreshing];
        self.dataArr = [NSMutableArray arrayWithArray:@[@"666",@"777"]];
        [self.tableV reloadData];
    });
   
}

#pragma mark- cycle life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initUI];
    for (int i = 0; i < 5; i ++) {
        [self.dataArr addObject:[NSString stringWithFormat:@"%d",i]];
        [self.tableV reloadData];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- initUI
- (void)initUI {

    
    [self.view addSubview:self.tableV];
    [_tableV mas_makeConstraints:^(MASConstraintMaker * make) {
//        make.edges.equalTo(self.view);
        make.top.left.right.offset(0);
        make.bottom.offset(44 - 10);
    }];
    __weak typeof(self) weakSelf = self;
    __weak typeof(_tableV) weakTableV = _tableV;
    
//    MJRefreshAutoFooter 直接接在最后cell底部， MJRefreshBackNormalFooter接在列表底部
    //使用 MJRefreshAutoFooter 有问题, main下拉，接触区域为当前，会触发上拉回调
    _tableV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakTableV.mj_footer endRefreshing];

            [weakSelf.dataArr addObjectsFromArray:@[@"xxx",@"444",@"xxx",@"444",@"xxx",@"444"]];
            [weakSelf.tableV reloadData];
        });

    }];
    
//    _tableV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [weakTableV.mj_footer endRefreshing];
//
//            [weakSelf.dataArr addObjectsFromArray:@[@"xxx",@"444",@"xxx",@"444",@"xxx",@"444"]];
//            [weakSelf.tableV reloadData];
//        });
//
//    }];
}

#pragma mark -TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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





@end
