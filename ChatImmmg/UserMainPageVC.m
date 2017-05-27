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
#import "YHRefreshTableView.h"
#import "CellForWorkGroup.h"
#import "YHUserInfoManager.h"
#import "YHUtils.h"
#import "YHSharePresentView.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#import "TimelineDetailVC.h"
#import "TopViewCell.h"
#import "UserInfo.h"

@interface UserMainPageVC ()<UITableViewDelegate,UITableViewDataSource,CellForWorkGroupDelegate>{
    NSString *lastTimelineID;
}

@property (nonatomic,strong) YHRefreshTableView *tableView;
@property (nonatomic,strong) NSMutableArray<YHWorkGroup *> *dataArray;
@property (nonatomic,strong) NSMutableDictionary *heightDict;

@property (nonatomic,strong) NSMutableArray<YHWorkGroup *> *timelineList;
@property (nonatomic,strong) UserInfo *userinfo;

@end

@implementation UserMainPageVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self getTimelineByUser];
    [self getUserinfoByUser];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpUI{
    self.title = @"我的主页";
    
    //设置导航栏背景颜色
    UIColor * color = [UIColor colorWithRed:0.f green:191.f / 255 blue:143.f / 255 alpha:1];
    self.navigationController.navigationBar.barTintColor = color;
    self.navigationController.navigationBar.translucent = NO;
    
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowColor = [UIColor colorWithWhite:0.871 alpha:1.000];
    shadow.shadowOffset = CGSizeMake(0.5, 0.5);
    
    //设置导航栏标题颜色
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18],NSShadowAttributeName:shadow};
    self.navigationController.navigationBar.titleTextAttributes = attributes;
    
    self.tableView = [[YHRefreshTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGBCOLOR(244, 244, 244);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView setEnableLoadNew:YES];
    [self.tableView setEnableLoadMore:YES];
    
    self.view.backgroundColor = RGBCOLOR(244, 244, 244);
    
    [self.tableView registerClass:[TopViewCell class] forCellReuseIdentifier:NSStringFromClass([TopViewCell class])];
    [self.tableView registerClass:[CellForWorkGroup class] forCellReuseIdentifier:NSStringFromClass([CellForWorkGroup class])];

}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else{
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if(indexPath.section == 0){
        TopViewCell *cell = [[TopViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([TopViewCell class])];
        if([[userDefault objectForKey:@"account"] isEqual:self.account]){
            [cell configModel:self.userinfo.avatar name:self.userinfo.name isHide:@"hide"];
        }else{
            [cell configModel:self.userinfo.avatar name:self.userinfo.name isHide:@"show"];
        }
    
        return cell;
    }else{
    
        YHWorkGroup *model  = self.dataArray[indexPath.row];
        
        
        CellForWorkGroup *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CellForWorkGroup class])];
        if (!cell) {
            cell = [[CellForWorkGroup alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([CellForWorkGroup class])];
        }
        cell.indexPath = indexPath;
        cell.model = model;
        cell.delegate = self;
        return cell;
    }
    
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if(section == 1){
        return @"动态";
    }else{
        return nil;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        return 280;
    }else{
    if (indexPath.row < self.dataArray.count) {
        
        CGFloat height = 0.0;
        //原创cell
        Class currentClass  = [CellForWorkGroup class];
        YHWorkGroup *model  = self.dataArray[indexPath.row];
        
        //取缓存高度
        NSDictionary *dict =  self.heightDict[model.dynamicId];
        if (dict) {
            if (model.isOpening) {
                height = [dict[@"open"] floatValue];
            }else{
                height = [dict[@"normal"] floatValue];
            }
            if (height) {
                return height;
            }
        }
        
        
        
        height = [CellForWorkGroup hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
            CellForWorkGroup *cell = (CellForWorkGroup *)sourceCell;
            
            cell.model = model;
            
        }];
        
        
        //缓存高度
        if (model.dynamicId) {
            NSMutableDictionary *aDict = [NSMutableDictionary new];
            if (model.isOpening) {
                [aDict setObject:@(height) forKey:@"open"];
            }else{
                [aDict setObject:@(height) forKey:@"normal"];
            }
            [self.heightDict setObject:aDict forKey:model.dynamicId];
        }
        return height;
    }
    else{
        return 44.0f;
    }
    
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TimelineDetailVC *detailVC = [TimelineDetailVC new];
    [self.navigationController pushViewController:detailVC animated:YES];
    detailVC.model = self.dataArray[indexPath.row];
    
}





-(void)getTimelineByUser{

    NSString *paramUrl = [@"?account=" stringByAppendingString:self.account];
    [[NetworkManager shareNetwork]getPersonalTimelineWithParam:nil paramsUrl:paramUrl successful:^(NSDictionary *responseObject) {
        NSLog(@"userTimelinelist%@",responseObject);
        self.dataArray = [YHWorkGroup mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"result"]];
        for(int i = 0;i<self.dataArray.count;i++){
            //            self.dataArray[i].thumbnailPicUrls = self.dataArray[i].images
            
            for(int j = 0;j<self.dataArray[i].images.count;j++){
                if(j == 0){
                    self.dataArray[i].thumbnailPicUrls = [NSMutableArray arrayWithObjects:[NSURL URLWithString:self.dataArray[i].images[j]], nil];
                }else{
                    [self.dataArray[i].thumbnailPicUrls addObject:[NSURL URLWithString: self.dataArray[i].images[j]]];
                }
                
            }
            self.dataArray[i].originalPicUrls = self.dataArray[i].thumbnailPicUrls;
        }
        if(self.dataArray){
            lastTimelineID = self.dataArray[0].dynamicId;
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"error"];
    }];
    

}

-(void)getUserinfoByUser{
    
    NSString *paramUrl = [@"?account=" stringByAppendingString:self.account];
    [[NetworkManager shareNetwork]getPersonalInfoWithParam:nil paramsUrl:paramUrl successful:^(NSDictionary *responseObject) {
        NSLog(@"getuserinfo%@",responseObject);
        self.userinfo = [UserInfo mj_objectWithKeyValues:[[responseObject objectForKey:@"result"] objectForKey:@"user"]];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"error"];
    }];
    
}

@end
