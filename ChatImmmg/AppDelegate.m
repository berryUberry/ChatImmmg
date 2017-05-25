//
//  AppDelegate.m
//  ChatImmmg
//
//  Created by 王凯 on 2017/4/22.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import "AppDelegate.h"
#import <TuSDKGeeV1/TuSDKGeeV1.h>

#import "TabBarVC.h"
#import "LoginVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.window =[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
        LoginVC *root = [LoginVC new];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:root];
        self.window.rootViewController = nav;
//    TabBarVC *tabBarVC = [TabBarVC new];
//    self.window.rootViewController = tabBarVC;
    
    
    // TUSDK  初始化SDK (请前往 http://tusdk.com 获取您的 APP 开发密钥)
    [TuSDK initSdkWithAppKey:@"4a82be6c64ff76d9-00-iqztq1"];
    [TuSDK setLogLevel:lsqLogLevelDEBUG];
    
    //RongCloudIM 初始化SDK
    [[RCIM sharedRCIM] initWithAppKey:@"3argexb63u7re"];
    
//    [[RCIM sharedRCIM] connectWithToken:@"/cWeFinSWjcYtp5GoClNBW1L1Pex6EUJyToW5skqPPfDjIwkijWw0HzcJO/8Fy0zBjO7X26poECkNZv0CmizPQRm37Bv4Dt8"     success:^(NSString *userId) {
//        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
//    } error:^(RCConnectErrorCode status) {
//        NSLog(@"登陆的错误码为:%ld", (long)status);
//    } tokenIncorrect:^{
//        //token过期或者不正确。
//        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
//        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
//        NSLog(@"token错误");
//    }];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
