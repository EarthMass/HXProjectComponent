//
//  HUDDemo.m
//  HXProjectComponent
//
//  Created by Guo on 2022/6/10.
//

#import "HUDDemo.h"
#import "HXHUD.h"

@interface HUDDemo ()

@property (nonatomic, strong) HXHUD * hud;
@property (nonatomic, assign) CGFloat progress;

@end

@implementation HUDDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *test = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 280)];
    test.center = self.view.center;
    test.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:test];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, 150, 20)];
    [btn1 addTarget:self action:@selector(btnTest:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"提示消息" forState:UIControlStateNormal];
    btn1.tag=1001;
    [test addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(15, 40, 150, 20)];
    [btn2 addTarget:self action:@selector(btnTest:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setTitle:@"加载成功" forState:UIControlStateNormal];
    btn2.tag=1002;
    [test addSubview:btn2];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(15, 70, 150, 20)];
    [btn3 addTarget:self action:@selector(btnTest:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setTitle:@"加载中（菊花）" forState:UIControlStateNormal];
    btn3.tag=1003;
    [test addSubview:btn3];
    
    UIButton *btn4 = [[UIButton alloc] initWithFrame:CGRectMake(15, 100, 150, 20)];
    [btn4 addTarget:self action:@selector(btnTest:) forControlEvents:UIControlEventTouchUpInside];
    [btn4 setTitle:@"加载中（环形）" forState:UIControlStateNormal];
    btn4.tag=1004;
    [test addSubview:btn4];
    
    UIButton *btn5 = [[UIButton alloc] initWithFrame:CGRectMake(15, 130, 150, 20)];
    [btn5 addTarget:self action:@selector(btnTest:) forControlEvents:UIControlEventTouchUpInside];
    [btn5 setTitle:@"自定义图片" forState:UIControlStateNormal];
    btn5.tag=1005;
    [test addSubview:btn5];
    
    UIButton *btn6 = [[UIButton alloc] initWithFrame:CGRectMake(15, 160, 150, 20)];
    [btn6 addTarget:self action:@selector(btnTest:) forControlEvents:UIControlEventTouchUpInside];
    [btn6 setTitle:@"随机动画" forState:UIControlStateNormal];
    btn6.tag=1006;
    [test addSubview:btn6];
    
    UIButton *btn7 = [[UIButton alloc] initWithFrame:CGRectMake(15, 190, 200, 20)];
    [btn7 addTarget:self action:@selector(btnTest:) forControlEvents:UIControlEventTouchUpInside];
    [btn7 setTitle:@"加载中（下载进度）" forState:UIControlStateNormal];
    btn7.tag=1007;
    [test addSubview:btn7];
    
    UIButton *btn8 = [[UIButton alloc] initWithFrame:CGRectMake(15, 220, 200, 20)];
    [btn8 addTarget:self action:@selector(btnTest:) forControlEvents:UIControlEventTouchUpInside];
    [btn8 setTitle:@"自定义图片+文字" forState:UIControlStateNormal];
    btn8.tag=1008;
    [test addSubview:btn8];
    
    UIButton *btn9 = [[UIButton alloc] initWithFrame:CGRectMake(15, 250, 200, 20)];
    [btn9 addTarget:self action:@selector(btnTest:) forControlEvents:UIControlEventTouchUpInside];
    [btn9 setTitle:@"gif" forState:UIControlStateNormal];
    btn9.tag=1009;
    [test addSubview:btn9];
}



-(void)btnTest:(UIButton *)sender{
    switch (sender.tag) {
        case 1001:{
//            for (int i = 0; i < 10; i ++) {
//                [HXHUD showText: [NSString stringWithFormat:@"66666- %d",i]];
//            }
//            [HXHUD showText: [NSString stringWithFormat:@"66666"]];
            [HXHUD showText: [NSString stringWithFormat:@"66666"] postition:HXProgressPositionBottom];
            break;
        }
        case 1002:{
//            [YJProgressHUD showSuccess:@"加载成功" inview:self.view];
            break;
        }
        case 1003:{
            //菊花加载
            [HXHUD showHud:@"加载中..."];
//            [YJProgressHUD showProgress:@"加载中..." inView:self.view];
            break;
        }
        case 1004:{
            //环形加载（图片不喜欢可以自己换）
            [HXHUD showHud:@"加载中"];
            break;
        }
        case 1005:{
            [HXHUD showHudWithImage:@"1.jpg"];
        }
            break;
        
        case 1006:{
            [HXHUD showCustomAnimation:@"555" withImgArry:@[@"1.jpg",@"2.jpg",@"3.jpg"] inview:self.view];
            break;
        }
        case 1007:{
//            加载进度，类似下载进度
            self.hud = [HXHUD showProgress:@"进度..." inView:nil];

            //用定时器模拟数据，下面对HUD进行设置进度值即可，正式使用时，获取到afn下载的进度，同理设置就行
            self.progress = 0.01;
            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
            break;
        }
        case 1008:{
            //加载自定义图片，含文字
            [HXHUD showImg:@"1.jpg" msg:@"成功了"];
            break;
        }
        case 1009:{
            //加载自定义图片，含文字
            [HXHUD showCustomGif];
            break;
        }
        default:
            break;
    }




    //下面是设置
    if (sender.tag == 1007) {
        return;
    }


    //这里是我手动设置的停止动画，实际使用时，可以在数据请求结束时，用 [YJProgressHUD hide]; 结束动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HXHUD hide];

    });
}

-(void)updateProgress{
    if (self.progress >=1) {
        [self.hud.hud hideAnimated:YES];
        self.hud = nil;
    }
    
    self.progress = self.progress + 0.01;
    self.hud.hud.progress = self.progress;
    
    
}

@end
