//
//  AppDelegate.m
//  TestDemo
//
//  Created by Guo on 2022/5/7.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    ViewController * viewC = [[ ViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:viewC];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
