//
//  TabBarVC.m
//  ImgChat
//
//  Created by 王凯 on 2017/4/12.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import "TabBarVC.h"
#import "TuImgVC.h"
#import "ChatListVC.h"
#import "PcircleVC.h"
#import "CircleVC.h"
#import "FollowersVC.h"
#import "MineVC.h"

@implementation TabBarVC

-(void)viewDidLoad{

    [super viewDidLoad];
    [self configViewController];
}

-(void)configViewController{
    TuImgVC *tuimgVC = [TuImgVC new];
    tuimgVC.title = @"C3I4";
    tuimgVC.tabBarItem.image = [UIImage imageNamed:@"image_32x32"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tuimgVC];
    nav.navigationBar.tintColor = [UIColor whiteColor];
    [self addChildViewController:nav];
    
//    PcircleVC *vc2 = [PcircleVC new];
//    vc2.title = @"22";
//    vc2.tabBarItem.image =  [UIImage imageNamed:@"2.png"];
//    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:vc2];
//    [self addChildViewController:nav3];
    
    CircleVC *vc = [CircleVC new];
    vc.title = @"动态";
    vc.tabBarItem.image =  [UIImage imageNamed:@"circle"];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:vc];
    nav2.navigationBar.tintColor = [UIColor whiteColor];
    [self addChildViewController:nav2];
    
    
    ChatListVC *chatListVC = [ChatListVC new];
    chatListVC.title = @"最近聊天";
    chatListVC.tabBarItem.image =  [UIImage imageNamed:@"chat_32x32"];
    UINavigationController *navChatListVC = [[UINavigationController alloc]initWithRootViewController:chatListVC];
    navChatListVC.navigationBar.tintColor = [UIColor whiteColor];
    [self addChildViewController:navChatListVC];
    
//    FollowersVC *followersVC = [FollowersVC new];
//    UINavigationController *followersnav = [[UINavigationController alloc]initWithRootViewController:followersVC];
//    [self addChildViewController:followersnav];
    MineVC *mineVC = [MineVC new];
    mineVC.title = @"个人信息";
    mineVC.tabBarItem.image = [UIImage imageNamed:@"user_24x32"];
    UINavigationController *mineNav = [[UINavigationController alloc]initWithRootViewController:mineVC];
    mineNav.navigationBar.tintColor = [UIColor whiteColor];
    [self addChildViewController:mineNav];
    
//    UIColor * color = [UIColor colorWithRed:46.0f / 255 green:139.0f / 255 blue:87.0f / 255 alpha:1];
    self.tabBar.tintColor = MainColor;
    
    

}



@end
