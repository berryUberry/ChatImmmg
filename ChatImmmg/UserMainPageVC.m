//
//  UserMainPageVC.m
//  ChatImmmg
//
//  Created by 王凯 on 2017/5/26.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import "UserMainPageVC.h"
#import "YHRefreshTableView.h"
#import "YHWorkGroup.h"

@interface UserMainPageVC ()

@property (nonatomic,strong) YHRefreshTableView *tableView;
@property (nonatomic,strong) NSMutableArray<YHWorkGroup *> *dataArray;
@property (nonatomic,strong) NSMutableDictionary *heightDict;

@property (nonatomic,strong) NSMutableArray<YHWorkGroup *> *timelineList;

@end

@implementation UserMainPageVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getTimelineByUser];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getTimelineByUser{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *paramUrl = [@"?account=" stringByAppendingString:[userDefault objectForKey:@"account"]];
    [[NetworkManager shareNetwork]getPersonalTimelineWithParam:nil paramsUrl:paramUrl successful:^(NSDictionary *responseObject) {
        NSLog(@"userTimelinelist%@",responseObject);
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"error"];
    }];
    

}

//-(void)getUserinfoByUser{
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSString *paramUrl = [@"?account=" stringByAppendingString:[userDefault objectForKey:@"account"]];
//    [[NetworkManager shareNetwork]getPersonalTimelineWithParam:nil paramsUrl:paramUrl successful:^(NSDictionary *responseObject) {
//        NSLog(@"userTimelinelist%@",responseObject);
//    } failure:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"error"];
//    }];
//}

@end
