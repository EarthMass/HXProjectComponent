//
//  PopViewDemo.m
//  HXProjectComponent
//
//  Created by Guo on 2022/6/14.
//

#import "PopViewDemo.h"
#import "UIButton+ImageTitleSpacing.h"

#import "HXAlertView.h"

@interface PopViewDemo ()

@end

@implementation PopViewDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIView *test = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 280)];
    test.center = self.view.center;
    test.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:test];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, 150, 20)];
    [btn1 setTitle:@"alert" forState:UIControlStateNormal];
    [test addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(15, 40, 150, 20)];
    [btn2 setTitle:@"actionSheet" forState:UIControlStateNormal];
    [test addSubview:btn2];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(15, 70, 150, 20)];
    [btn3 setTitle:@"customPopView" forState:UIControlStateNormal];
    [test addSubview:btn3];
    
    __weak typeof(self) weakSelf = self;
    [btn1 handleControlBlock:^{
       
        
        [weakSelf showAlert];
      
    }];
    [btn2 handleControlBlock:^{
        
        [weakSelf showSheet];
       
    }];
    [btn3 handleControlBlock:^{
        
        [weakSelf showCustom];
    }];
}

- (void)showAlert {
    HXAlertView * alert = [HXAlertView  alertWithTitle:@"标题" msg:@"描述,描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述" withType:HXAlertViewTypeAlert];

    HXAlertViewAction * actionCancel = [HXAlertViewAction actionWithTitle:@"取消" blk:^{
        [alert dissmiss];
    }];

    HXAlertViewAction * action = [HXAlertViewAction actionWithTitle:@"确定" blk:^{
        [alert dissmiss];
    }];
    HXAlertViewAction * action2 = [HXAlertViewAction actionWithTitle:@"4444" blk:^{
        [alert dissmiss];
    }];
    [action2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    [alert addAction:actionCancel];
    [alert addAction:action];
    [alert addAction:action2];

    [alert show];
}

- (void)showSheet {
    HXAlertView * alert = [HXAlertView alertWithTitle:nil msg:@"描述,描述描述" withType:HXAlertViewTypeSheet];
    HXAlertViewAction * actionCancel = [HXAlertViewAction actionWithTitle:@"取消" blk:^{
        [alert dissmiss];
    }];
    
    HXAlertViewAction * action = [HXAlertViewAction actionWithTitle:@"确定" blk:^{
        [alert dissmiss];
    }];
    HXAlertViewAction * action2 = [HXAlertViewAction actionWithTitle:@"4444" blk:^{
        [alert dissmiss];
    }];
    [action2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [alert addAction:actionCancel];
    [alert addAction:action];
    [alert addAction:action2];
    
    [alert show];
}

- (void)showCustom {
    UIView  * cusView = [UIView new];
    cusView.backgroundColor = [UIColor redColor];
    cusView.frame = CGRectMake(0, 0, 100, 200);
    
    HXAlertView * alert = [HXAlertView  alertWithTitle:nil msg:@"" cusView:cusView  withType:HXAlertViewTypeSheet];
    
    HXAlertViewAction * actionCancel = [HXAlertViewAction actionWithTitle:@"取消" blk:^{
        [alert dissmiss];
    }];
    
    HXAlertViewAction * action = [HXAlertViewAction actionWithTitle:@"确定" blk:^{
        [alert dissmiss];
    }];
    HXAlertViewAction * action2 = [HXAlertViewAction actionWithTitle:@"4444" blk:^{
        [alert dissmiss];
    }];
    [action2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [alert addAction:actionCancel];
//        [alert addAction:action];
//        [alert addAction:action2];
    
    [alert show];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
