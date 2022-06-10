//
//  ViewController.m
//  TestDemo
//
//  Created by Guo on 2022/5/7.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (nonatomic, strong) UITableView * tableV;
@property (nonatomic, strong) NSArray * dataArr;


@end

@implementation ViewController

#pragma mark- cycle life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initUI];
    [self setData];
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
}

- (void)setData {
    self.dataArr = @[
        @{@"sectionName":@"UI类型",
          @"modules":@[@{@"name":@"图片多选",@"class":@"TestMutiPhotoVC"},
                       @{@"name":@"嵌套列表",@"class":@"NestTestVC"},
                       @{@"name":@"HUD加载提示",@"class":@"HUDDemo"},
          ]},
        
    ];
    [self.tableV reloadData];
}

#pragma mark -TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   NSDictionary * dic = self.dataArr[section];
    NSArray * modulesArr = ((NSArray * )dic[@"modules"]);
    return modulesArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"XXX";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary * dic = self.dataArr[indexPath.section];
    NSArray * modulesArr = ((NSArray * )dic[@"modules"]);
    NSDictionary * item = modulesArr[indexPath.row];
    cell.textLabel.text = item[@"name"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
    
}

#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dic = self.dataArr[indexPath.section];
    NSArray * modulesArr = ((NSArray * )dic[@"modules"]);
    NSDictionary * item = modulesArr[indexPath.row];
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

#pragma mark- tableV headView Custom
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSDictionary * dic = self.dataArr[section];
    
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    UILabel * desLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 20, 40)];
    
    desLab.text = dic[@"sectionName"];
    desLab.textColor = [UIColor blackColor];
    desLab.font = [UIFont systemFontOfSize:14];
    [headView addSubview:desLab];
    
    headView.backgroundColor = [UIColor lightGrayColor];
    return headView;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001f;
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
        _tableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        if (@available(iOS 11.0, *)) {
//            _tableV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        }else {
//            self.automaticallyAdjustsScrollViewInsets = NO;
//        }
//        
//        if (@available(iOS 15.0, *)) {
//            _tableV.sectionHeaderTopPadding = 0;
//        }
    }
    return _tableV;
}




- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSArray alloc] init];
    }
    return _dataArr;
}





@end
