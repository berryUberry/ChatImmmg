//
//  ChatListVC.m
//  ChatImmmg
//
//  Created by 王凯 on 2017/4/22.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import "ChatListVC.h"
#import "UserInfo.h"


@interface ChatListVC ()<RCIMUserInfoDataSource>
@property(nonatomic,strong)UserInfo *info;
@end

@implementation ChatListVC


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
    
    //设置导航栏背景颜色
//    UIColor * color = [UIColor colorWithRed:46.0f / 255 green:139.0f / 255 blue:87.0f / 255 alpha:1];
    self.navigationController.navigationBar.barTintColor = MainColor;
    self.navigationController.navigationBar.translucent = NO;
    
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowColor = [UIColor colorWithWhite:0.871 alpha:1.000];
    shadow.shadowOffset = CGSizeMake(0.5, 0.5);
    
    //设置导航栏标题颜色
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18],NSShadowAttributeName:shadow};
    self.navigationController.navigationBar.titleTextAttributes = attributes;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle;
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
}


-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
//    NSString *paramUrl = [@"?account=" stringByAppendingString:userId];
    NSDictionary *params = @{@"account" : userId
                             };
    RCUserInfo *user = [[RCUserInfo alloc]init];
    WeakSelf
    [[NetworkManager shareNetwork]getPersonalInfoWithParam:params successful:^(NSDictionary *responseObject) {
        NSLog(@"getuserinfo%@",responseObject);
        weakSelf.info = [UserInfo mj_objectWithKeyValues:[[responseObject objectForKey:@"result"] objectForKey:@"user"]];
        //        [userDefault setObject:weakSelf.info forKey:account];
        user.userId = userId;
        user.name = weakSelf.info.name;
        user.portraitUri = weakSelf.info.avatar;
        return completion(user);
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"error"];
    }];
}

@end
