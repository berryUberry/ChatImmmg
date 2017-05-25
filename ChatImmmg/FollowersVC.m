//
//  FollowersVC.m
//  ChatImmmg
//
//  Created by 王凯 on 2017/5/20.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import "FollowersVC.h"
#import "FollowersCell.h"
#import "UserInfo.h"
static NSString *cellIdentifier = @"FollowersCellIdentifier";

@interface FollowersVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray<UserInfo *> *followersList;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation FollowersVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self follow];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITableView *tableView = [UITableView new];
    tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [tableView registerClass:[FollowersCell class] forCellReuseIdentifier:cellIdentifier];
    tableView.tableFooterView = nil;
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [self getFollowersList];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _followersList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FollowersCell *cell = [[FollowersCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configModel:_followersList[indexPath.row]];
    return cell;
}

#pragma mark -- UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


-(void)getFollowersList{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *account = [userDefault objectForKey:@"account"];
    NSString *paramsUrl = [@"?account=" stringByAppendingString:account];
    [[NetworkManager shareNetwork]getFollowersList:nil paramsUrl:paramsUrl successful:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",[responseObject objectForKey:@"error"]);
        if([responseObject objectForKey:@"error"]){
            [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"error"]];
        }else{
            self.followersList = [UserInfo mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"result"]];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];

}

-(void)follow{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *params = @{@"account":@"b",
                             @"token":[userDefault objectForKey:@"token"]
                             };
    [[NetworkManager shareNetwork]followWithParam:params isfollow:@"follow" successful:^(NSDictionary *responseObject) {
        NSLog(@"follow%@",responseObject);
        NSLog(@"%@",[responseObject objectForKey:@"error"]);
    } failure:^(NSError *error) {
        
    }];

}

@end
