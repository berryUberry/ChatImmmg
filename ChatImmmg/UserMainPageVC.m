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
    NSString *amount;
    NSString *since_id;
}

@property (nonatomic,strong) YHRefreshTableView *tableView;
@property (nonatomic,strong) NSMutableArray<YHWorkGroup *> *dataArray;
@property (nonatomic,strong) NSMutableArray<YHWorkGroup *> *newdataArray;
@property (nonatomic,strong) NSMutableDictionary *heightDict;

@property (nonatomic,strong) NSMutableArray<YHWorkGroup *> *timelineList;
@property (nonatomic,strong) UserInfo *userinfo;
@property (nonatomic,assign) BOOL isfollow;

@end

@implementation UserMainPageVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self getTimelinesByUser];
    [self getUserinfoByUser];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    amount = @"1";
    [self setUpUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpUI{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([[userDefault objectForKey:@"account"] isEqual:self.account]){
        self.title = @"我的主页";
    }else{
        self.title = @"主页";
    }
    
    
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
            [cell configModel:self.userinfo.avatar name:self.userinfo.name isHide:@"hide" motto:self.userinfo.motto];
        }else{
            [cell configModel:self.userinfo.avatar name:self.userinfo.name isHide:@"show" motto:self.userinfo.motto];
            [cell.chatBtn addTarget:self action:@selector(chat) forControlEvents:UIControlEventTouchUpInside];
            [cell.followBtn addTarget:self action:@selector(follow) forControlEvents:UIControlEventTouchUpInside];
            if(self.isfollow){
                [cell.followBtn setTitle:@"已关注" forState:normal];
            }else{
                [cell.followBtn setTitle:@"关注" forState:normal];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
}
#pragma mark - YHRefreshTableViewDelegate
- (void)refreshTableViewLoadNew:(YHRefreshTableView*)view{
    [self getTimelinesByUser];
    //    [self requestDataLoadNew:YES];
}

- (void)refreshTableViewLoadmore:(YHRefreshTableView*)view{
    //    [self requestDataLoadNew:NO];
    [self getOldTimeline];
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
        return 280 + 35;
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
    if(indexPath.section == 1){
        TimelineDetailVC *detailVC = [TimelineDetailVC new];
        [self.navigationController pushViewController:detailVC animated:YES];
        detailVC.model = self.dataArray[indexPath.row];
        WeakSelf
        [detailVC changeModel:^(YHWorkGroup *model) {
            weakSelf.dataArray[indexPath.row] = model;
            [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        [detailVC deleteTimeline:^(YHWorkGroup *model) {
            [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
            [weakSelf.heightDict removeObjectForKey:model.dynamicId];
            [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }];
    }
}

#pragma mark - CellForWorkGroupDelegate
- (void)onAvatarInCell:(CellForWorkGroup *)cell{
}

- (void)onMoreInCell:(CellForWorkGroup *)cell{
    DDLog(@"查看详情");
    if (cell.indexPath.row < [self.dataArray count]) {
        YHWorkGroup *model = self.dataArray[cell.indexPath.row];
        model.isOpening = !model.isOpening;
        [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

- (void)onCommentInCell:(CellForWorkGroup *)cell{
    TimelineDetailVC *detailVC = [TimelineDetailVC new];
    [self.navigationController pushViewController:detailVC animated:YES];
    detailVC.model = cell.model;
}

- (void)onLikeInCell:(CellForWorkGroup *)cell{
    [self thumbHttp:cell];
    
}

- (void)onShareInCell:(CellForWorkGroup *)cell{
}


- (void)onDeleteInCell:(CellForWorkGroup *)cell{
    if (cell.indexPath.row < [self.dataArray count]) {
        [self _deleteDynAtIndexPath:cell.indexPath dynamicId:cell.model.dynamicId];
    }
}


//
//
//-(void)getTimelineByUser{
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSString *paramUrl = [@"?account=" stringByAppendingString:self.account];
//    [[NetworkManager shareNetwork]getPersonalTimelineWithParam:nil paramsUrl:paramUrl successful:^(NSDictionary *responseObject) {
//        NSLog(@"userTimelinelist%@",responseObject);
//        self.dataArray = [YHWorkGroup mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"result"]];
//        for(int i = 0;i<self.dataArray.count;i++){
//            //            self.dataArray[i].thumbnailPicUrls = self.dataArray[i].images
//            
//            for(int j = 0;j<self.dataArray[i].images.count;j++){
//                if(j == 0){
//                    self.dataArray[i].thumbnailPicUrls = [NSMutableArray arrayWithObjects:[NSURL URLWithString:self.dataArray[i].images[j]], nil];
//                }else{
//                    [self.dataArray[i].thumbnailPicUrls addObject:[NSURL URLWithString: self.dataArray[i].images[j]]];
//                }
//                
//            }
//            self.dataArray[i].originalPicUrls = self.dataArray[i].thumbnailPicUrls;
//            
//            for(int q = 0;q<self.dataArray[i].likes.count;q++){
//                self.dataArray[i].isLike = NO;
//                if([self.dataArray[i].likes[q].uid isEqual:[userDefault objectForKey:@"account"]]){
//                    self.dataArray[i].isLike = YES;
//                    break;
//                }
//            }
//            self.dataArray[i].likeCount = [self.dataArray[i].liked intValue];
//            self.dataArray[i].commentCount = [[NSString stringWithFormat:@"%lu",(unsigned long)self.dataArray[i].comments.count] intValue];
//            self.dataArray[i].publishTime = [self configTime:self.dataArray[i].publishDate];
//        }
//        if(self.dataArray.count>0){
//            lastTimelineID = self.dataArray[0].dynamicId;
//        }
//        [self.tableView reloadData];
//    } failure:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"error"];
//    }];
//    
//
//}





-(void)getTimelinesByUser{
    NSString *paramUrlprepre = [@"?account=" stringByAppendingString:self.account];
    NSString *paramUrlpre = [@"&amount=" stringByAppendingString:amount];
    NSString *paramUrl;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.account,@"account",amount,@"amount", nil];
    if(since_id){
        NSString *paramUrl2 = [@"&since_id=" stringByAppendingString:since_id];
        paramUrl = [paramUrlprepre stringByAppendingString:[paramUrlpre stringByAppendingString:paramUrl2]];
        [params setValue:since_id forKey:@"since_id"];
    }else{
        paramUrl = [paramUrlprepre stringByAppendingString: paramUrlpre];
    }
    
    WeakSelf
    [[NetworkManager shareNetwork]getPersonalTimelineWithParam:params  successful:^(NSDictionary *responseObject) {
        NSLog(@"getPersonalTimelines%@",responseObject);
        
        if([[responseObject objectForKey:@"error"] isEqual:@"token不能为空"]){
            [SVProgressHUD showErrorWithStatus:@"登陆信息失效！请重新登录!"];
            LoginVC *loginvc = [LoginVC new];
            [weakSelf presentViewController:loginvc animated:YES completion:nil];
        }
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        weakSelf.newdataArray = [YHWorkGroup mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"result"]];
        for(int i = 0;i<weakSelf.newdataArray.count;i++){
            //            self.dataArray[i].thumbnailPicUrls = self.dataArray[i].images
            
            for(int j = 0;j<weakSelf.newdataArray[i].images.count;j++){
                if(j == 0){
                    weakSelf.newdataArray[i].thumbnailPicUrls = [NSMutableArray arrayWithObjects:[NSURL URLWithString:weakSelf.newdataArray[i].images[j]], nil];
                }else{
                    [weakSelf.newdataArray[i].thumbnailPicUrls addObject:[NSURL URLWithString: weakSelf.newdataArray[i].images[j]]];
                }
                
            }
            weakSelf.newdataArray[i].originalPicUrls = weakSelf.newdataArray[i].thumbnailPicUrls;
            
            for(int q = 0;q<weakSelf.newdataArray[i].likes.count;q++){
                weakSelf.newdataArray[i].isLike = NO;
                if([weakSelf.newdataArray[i].likes[q].uid isEqual:[userDefault objectForKey:@"account"]]){
                    weakSelf.newdataArray[i].isLike = YES;
                    break;
                }
            }
            weakSelf.newdataArray[i].likeCount = [weakSelf.newdataArray[i].liked intValue];
            weakSelf.newdataArray[i].commentCount = [[NSString stringWithFormat:@"%lu",(unsigned long)weakSelf.newdataArray[i].comments.count] intValue];
            weakSelf.newdataArray[i].publishTime = [weakSelf configTime:weakSelf.newdataArray[i].publishDate];
        }
        
        if(weakSelf.dataArray.count>0){
            //            self.dataArray = [NSMutableArray arrayWithObjects:[self.newdataArray arrayByAddingObjectsFromArray:self.dataArray], nil];
            weakSelf.dataArray = [NSMutableArray arrayWithArray:[weakSelf.newdataArray arrayByAddingObjectsFromArray:weakSelf.dataArray]];
            
            
        }else{
            weakSelf.dataArray = weakSelf.newdataArray;
            
        }
        
        if(weakSelf.dataArray.count>0){
            since_id = weakSelf.dataArray[0].dynamicId;
            lastTimelineID = weakSelf.dataArray[weakSelf.dataArray.count - 1].dynamicId;
            
        }
        weakSelf.newdataArray = nil;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView loadFinish:YHRefreshType_LoadNew];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"error"];
    }];
}

-(void)getOldTimeline{
    NSString *paramUrlprepre = [@"?account=" stringByAppendingString:self.account];
    NSString *paramUrlpre = [@"&amount=" stringByAppendingString:amount];
    NSString *paramUrl;
    if(lastTimelineID){
        
        NSString *paramUrl2 = [paramUrlpre stringByAppendingString:[@"&lastTimelineID=" stringByAppendingString:lastTimelineID]];
        paramUrl = [paramUrlprepre stringByAppendingString:paramUrl2];
        
        NSDictionary *params = @{@"account":self.account,
                                 @"amount":amount,
                                 @"lastTimelineID":lastTimelineID
                                 };
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        WeakSelf
        [[NetworkManager shareNetwork]getPersonalTimelineWithParam:params successful:^(NSDictionary *responseObject) {
            NSLog(@"getPersonaloldTimeline%@",responseObject);
            
            if([[responseObject objectForKey:@"error"] isEqual:@"token不能为空"]){
                [SVProgressHUD showErrorWithStatus:@"登陆信息失效！请重新登录!"];
                LoginVC *loginvc = [LoginVC new];
                [weakSelf presentViewController:loginvc animated:YES completion:nil];
            }
            
            weakSelf.newdataArray = [YHWorkGroup mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"result"]];
            for(int i = 0;i<weakSelf.newdataArray.count;i++){
                for(int j = 0;j<weakSelf.newdataArray[i].images.count;j++){
                    if(j == 0){
                        weakSelf.newdataArray[i].thumbnailPicUrls = [NSMutableArray arrayWithObjects:[NSURL URLWithString:weakSelf.newdataArray[i].images[j]], nil];
                    }else{
                        [weakSelf.newdataArray[i].thumbnailPicUrls addObject:[NSURL URLWithString: weakSelf.newdataArray[i].images[j]]];
                    }
                    
                }
                weakSelf.newdataArray[i].originalPicUrls = weakSelf.newdataArray[i].thumbnailPicUrls;
                
                
                for(int q = 0;q<weakSelf.newdataArray[i].likes.count;q++){
                    weakSelf.newdataArray[i].isLike = NO;
                    if([weakSelf.newdataArray[i].likes[q].uid isEqual:[userDefault objectForKey:@"account"]]){
                        weakSelf.newdataArray[i].isLike = YES;
                        break;
                    }
                }
                weakSelf.newdataArray[i].likeCount = [weakSelf.newdataArray[i].liked intValue];
                weakSelf.newdataArray[i].commentCount = [[NSString stringWithFormat:@"%lu",(unsigned long)weakSelf.newdataArray[i].comments.count] intValue];
                weakSelf.newdataArray[i].publishTime = [weakSelf configTime:weakSelf.newdataArray[i].publishDate];
            }
            
            if(weakSelf.dataArray.count>0){
                weakSelf.dataArray = [NSMutableArray arrayWithArray:[weakSelf.dataArray arrayByAddingObjectsFromArray:weakSelf.newdataArray]];
            }else{
                weakSelf.dataArray = weakSelf.newdataArray;
            }
            if(weakSelf.dataArray.count>0){
                lastTimelineID = weakSelf.dataArray[weakSelf.dataArray.count - 1].dynamicId;
            }
            weakSelf.newdataArray = nil;
            
            [weakSelf.tableView loadFinish:YHRefreshType_LoadMore];
            [weakSelf.tableView reloadData];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"error"];
        }];
    }else{
        [self getTimelinesByUser];
    }
}


-(void)getUserinfoByUser{
    
//    NSString *paramUrl = [@"?account=" stringByAppendingString:self.account];
    NSDictionary *params = @{@"account":self.account
                             };
    WeakSelf
    [[NetworkManager shareNetwork]getPersonalInfoWithParam:params  successful:^(NSDictionary *responseObject) {
        NSLog(@"getuserinfo%@",responseObject);
        
        if([[responseObject objectForKey:@"error"] isEqual:@"token不能为空"]){
            [SVProgressHUD showErrorWithStatus:@"登陆信息失效！请重新登录!"];
            LoginVC *loginvc = [LoginVC new];
            [weakSelf presentViewController:loginvc animated:YES completion:nil];
        }
        
        weakSelf.userinfo = [UserInfo mj_objectWithKeyValues:[[responseObject objectForKey:@"result"] objectForKey:@"user"]];
        NSLog(@"%@",[[[responseObject objectForKey:@"result"] objectForKey:@"follow"] class]);
        if(![[[[responseObject objectForKey:@"result"] objectForKey:@"follow"] class] isEqual:[NSNull class]]){
            weakSelf.isfollow = YES;
        }else{
            weakSelf.isfollow = NO;
        }
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"error"];
    }];
    
}




#pragma mark - private

-(void)thumbHttp:(CellForWorkGroup *)cell{
    NSDictionary *params = @{@"timelineID":cell.model.dynamicId
                             };
    WeakSelf
    [[NetworkManager shareNetwork]thumbUpTimelineWithParam:params successful:^(NSDictionary *responseObject) {
        NSLog(@"thumbUp%@",responseObject);
        
        if([[responseObject objectForKey:@"error"] isEqual:@"token不能为空"]){
            [SVProgressHUD showErrorWithStatus:@"登陆信息失效！请重新登录!"];
            LoginVC *loginvc = [LoginVC new];
            [weakSelf presentViewController:loginvc animated:YES completion:nil];
        }
        
        if([responseObject objectForKey:@"success"]){
            if (cell.indexPath.row < [weakSelf.dataArray count]) {
                YHWorkGroup *model = weakSelf.dataArray[cell.indexPath.row];
                
                BOOL isLike = !model.isLike;
                
                model.isLike = isLike;
                if (isLike) {
                    model.likeCount += 1;
                    
                }else{
                    model.likeCount -= 1;
                }
                
                [weakSelf.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"error"];
    }];
}


- (void)_deleteDynAtIndexPath:(NSIndexPath *)indexPath dynamicId:(NSString *)dynamicId{
    
    WeakSelf
    [YHUtils showAlertWithTitle:@"删除动态" message:@"您确定要删除此动态?" okTitle:@"确定" cancelTitle:@"取消" inViewController:self dismiss:^(BOOL resultYes) {
        
        if (resultYes)
        {
            
            DDLog(@"delete row is %ld",(long)indexPath.row);
            
            
            NSDictionary *params = @{@"timelineID":dynamicId
                                     };
            [[NetworkManager shareNetwork]deleteTimelineWithParam:params successful:^(NSDictionary *responseObject) {
                NSLog(@"deleteTimeline%@",responseObject);
                
                if([[responseObject objectForKey:@"error"] isEqual:@"token不能为空"]){
                    [SVProgressHUD showErrorWithStatus:@"登陆信息失效！请重新登录!"];
                    LoginVC *loginvc = [LoginVC new];
                    [weakSelf presentViewController:loginvc animated:YES completion:nil];
                }
                
                if([responseObject objectForKey:@"success"]){
                    [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
                    [weakSelf.heightDict removeObjectForKey:dynamicId];
                    [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    if(self.dataArray.count>0){
                        lastTimelineID = weakSelf.dataArray[weakSelf.dataArray.count - 1].dynamicId;
                    }else{
                        lastTimelineID = nil;
                        since_id = nil;
                    }
                    
                }else{
                    [SVProgressHUD showInfoWithStatus:@"删除失败！"];
                }
                
                
            } failure:^(NSError *error) {
                [SVProgressHUD showInfoWithStatus:@"error"];
            }];
            
            
            
            
        }
    }];
    
}


-(void)follow{
    
    NSDictionary *params = @{@"account":self.account
                             };
    WeakSelf
    
    
    [[NetworkManager shareNetwork]followWithParam:params isfollow:self.isfollow successful:^(NSDictionary *responseObject) {
        NSLog(@"%d%@",self.isfollow,responseObject);
        
        if([[responseObject objectForKey:@"error"] isEqual:@"token不能为空"]){
            [SVProgressHUD showErrorWithStatus:@"登陆信息失效！请重新登录!"];
            LoginVC *loginvc = [LoginVC new];
            [weakSelf presentViewController:loginvc animated:YES completion:nil];
        }
        
        if([responseObject objectForKey:@"success"]){
            weakSelf.isfollow = !weakSelf.isfollow;
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"error"];
    }];
    
    
}

-(void)chat{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //新建一个聊天会话View Controller对象,建议这样初始化
    RCConversationViewController *chat = [[RCConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE
                                                                                               targetId:[userDefault objectForKey:@"account"]];
    
    //    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
        chat.conversationType = ConversationType_PRIVATE;
    //    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chat.targetId = self.account;
    
    //设置聊天会话界面要显示的标题
    chat.title = self.userinfo.name;
    //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];
}

-(NSString *)configTime:(long)timestamp{
    
    NSString*tempTime =[[NSNumber numberWithLong:timestamp] stringValue];
    NSMutableString *getTime = [NSMutableString stringWithFormat:@"%@",tempTime];
    [getTime deleteCharactersInRange:NSMakeRange(10,3)];
    NSDateFormatter *matter = [[NSDateFormatter alloc]init];
    matter.dateFormat =@"YY-MM-dd HH:mm";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[getTime intValue]];
    NSString *timeStr = [matter stringFromDate:date];
    return timeStr;
}

@end
