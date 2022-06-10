//
//  NestTestVC.m
//  GKScrollViewTest
//
//  Created by Guo on 2022/5/10.
//

#import "NestTestVC.h"
#import <Masonry/Masonry.h>

@interface NestTestVC ()<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (nonatomic, strong) UITableView * tableV;
@property (nonatomic, strong) NSMutableArray * dataArr;


@end

@implementation NestTestVC

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
    [self.view addSubview:self.tableV];
    [_tableV mas_makeConstraints:^(MASConstraintMaker * make) {
        make.edges.equalTo(self.view);
    }];
    
    self.dataArr = @[@{@"title":@"直接嵌套",@"class":@"MutiNestVC"},
                     @{@"title":@"多列表嵌套",@"class":@"MutiItemVC"},
                     @{@"title":@"单列表",@"class":@"SampleVC"},
                     @{@"title":@"分段定位滑动",@"class":@"PinLocationVC"}];
    [_tableV reloadData];
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
    
    NSDictionary * item = self.dataArr[indexPath.row];
    cell.textLabel.text = item[@"title"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
    
}

#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * item = self.dataArr[indexPath.row];
    UIViewController * vc = [[NSClassFromString(item[@"class"]) alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
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
