//
//  NetTestVC.m
//  HXProjectComponent
//
//  Created by Guo on 2022/6/18.
//

#import "NetTestVC.h"

#import <IOAApiManager/IOAApiManager.h>

#import "TestApi.h"
#import "UploadApi.h"

@interface NetTestVC ()<IOARequestDelegate>

@end

@implementation NetTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //https 配置，token 验证，需要先保存[saveToken]。
    
    //配置 网络地址
    [IOAApiHelper configNetworkWithBaseUrl:@"xxx"];
    

#pragma mark- 三种方式 请求，前两需要继承自IOARequest 最后项 直接 调用
        TestApiRequestEntity * requestEntity = [[TestApiRequestEntity alloc] init];
        requestEntity.appId = @"35C49FCB-F472-4B41-AD73-1EA3F4778380";
        requestEntity.phone = @"xxxxx";
        requestEntity.code = @"00000";

        //测试请求 block
//        TestApi * api = [[TestApi alloc] initWithModel:requestEntity respEntityName:@"TestApiRespEntity"];
    TestApi * api = [[TestApi alloc] initWithDictionary:nil respEntityName:@""];
        [api startWithBlockWithResult:^(IOAResponse *resp) {

            NSLog(@"data %@",resp.responseObject);
            UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:[resp.responseObject mj_JSONString] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alertV show];
        }];

        /*
         测试请求 delegate ,
         有指定 respMethodStr 回调为 respMethodStr
         未指定默认为ioaResult
         */
        TestApi * apiDelegate = [[TestApi alloc] initWithModel:nil respEntityName:@"TestApiRespEntity"];
        [apiDelegate startWithCompletionWithDelegate:self respMethodStr:@"getTestApi:"];
//         [api startWithCompletionWithDelegate:self respMethodStr:nil];


        //block快捷方式
        IOARequest * apiBlock = [IOARequest new];
        apiBlock.needShowHud = @0; //是否显示hud
        apiBlock.needAuthor = @0; //是否 需要验签
        [apiBlock startInBlockWithType:YTKRequestMethodPOST model:requestEntity  uri:@"xxx/api/v1/app_login/code" respEntityName:@"TestApiRespEntity" result:^(IOAResponse *resp) {

            NSLog(@"data %@",resp.responseObject);
        }];

        //资源上传
        UploadApi * uploadApi = [[UploadApi alloc] initWithModel:nil respEntityName:nil];
        [uploadApi uploadImageDic:@{@"11":[UIImage imageNamed:@"666.jpg"]}];

        [uploadApi startWithBlockWithResult:^(IOAResponse *resp) {

            NSLog(@"");
        }];
}


//未指定 默认回调方法
- (void)ioaResult:(IOAResponse *)result {
    
    NSLog(@"data");

}

//指定 回调方法
- (void)getTestApi:(IOAResponse *)result {
    
    NSLog(@"data");
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
