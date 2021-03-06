//
//  CircleVC.m
//  ChatImmmg
//
//  Created by 王凯 on 2017/5/16.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import "CircleVC.h"
#import "YHRefreshTableView.h"
#import "CellForWorkGroup.h"
#import "YHWorkGroup.h"
#import "YHUserInfoManager.h"
#import "YHUtils.h"
#import "YHSharePresentView.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#import "AddTimelineVC.h"
#import "TimelineDetailVC.h"
#import "UserMainPageVC.h"

@interface CircleVC ()<UITableViewDelegate,UITableViewDataSource,CellForWorkGroupDelegate>
{
    int _currentRequestPage; //当前请求页面
    BOOL _reCalculate;
    
    NSString *lastTimelineID;
    NSString *since_id;
    NSString *amount;
}

@property (nonatomic,strong) YHRefreshTableView *tableView;
@property (nonatomic,strong) NSMutableArray<YHWorkGroup *> *dataArray;
@property (nonatomic,strong) NSMutableArray<YHWorkGroup *> *newdataArray;
@property (nonatomic,strong) NSMutableDictionary *heightDict;

@property (nonatomic,strong) NSMutableArray<YHWorkGroup *> *timelineList;

@end



@implementation CircleVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    amount = @"1";
    [super viewDidLoad];
    [self initUI];
//    [self requestDataLoadNew:YES];
    [self getTimelines];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //设置UserId
    [YHUserInfoManager sharedInstance].userInfo.uid = [userDefault objectForKey:@"account"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI{
    
//    self.title = @"BerryCircle";
    
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
    
    UIButton *addTimelineBtn = [UIButton new];
    addTimelineBtn.frame = CGRectMake(0, 0, 25, 25);
    [addTimelineBtn setImage:[UIImage imageNamed:@"add"] forState:normal];
    [addTimelineBtn addTarget:self action:@selector(addTimeline) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addTimelineItem = [[UIBarButtonItem alloc]initWithCustomView:addTimelineBtn];
    self.navigationItem.rightBarButtonItem = addTimelineItem;
    
    
//    self.tableView = [[YHRefreshTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView = [[YHRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49) style:UITableViewStylePlain];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGBCOLOR(244, 244, 244);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView setEnableLoadNew:YES];
    [self.tableView setEnableLoadMore:YES];
    
    self.view.backgroundColor = RGBCOLOR(244, 244, 244);
    
    [self.tableView registerClass:[CellForWorkGroup class] forCellReuseIdentifier:NSStringFromClass([CellForWorkGroup class])];
}

#pragma mark - Lazy Load
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableDictionary *)heightDict{
    if (!_heightDict) {
        _heightDict = [NSMutableDictionary new];
    }
    return _heightDict;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

#pragma mark - 网络请求
- (void)requestDataLoadNew:(BOOL)loadNew{
    YHRefreshType refreshType;
    if (loadNew) {
        _currentRequestPage = 1;
        refreshType = YHRefreshType_LoadNew;
        [self.tableView setNoMoreData:NO];
    }
    else{
        _currentRequestPage ++;
        refreshType = YHRefreshType_LoadMore;
    }
    
    [self.tableView loadBegin:refreshType];
    if (loadNew) {
        [self.dataArray removeAllObjects];
        [self.heightDict removeAllObjects];
    }
    
    int totalCount = 10;
    
    NSUInteger lastDynamicID = 0;
    if (!loadNew && self.dataArray.count) {
        YHWorkGroup *model = self.dataArray.lastObject;
        lastDynamicID = [model.dynamicId integerValue];
    }
    for (int i=0; i<totalCount; i++) {
        YHWorkGroup *model = [YHWorkGroup new];
        model.dynamicId = [NSString stringWithFormat:@"%lu", lastDynamicID + i+1];
        [self randomModel:model totalCount:totalCount];
        [self.dataArray addObject:model];
    }
    
    [self.tableView loadFinish:refreshType];
    [self.tableView reloadData];
    
}

#pragma mark - 模拟产生数据源
- (void)randomModel:(YHWorkGroup *)model totalCount:(int)totalCount{
    
    model.type = arc4random()%totalCount %2? DynType_Forward:DynType_Original;//动态类型
    if (model.type == DynType_Forward) {
        model.forwardModel = [YHWorkGroup new];
        [self creatOriModel:model.forwardModel totalCount:totalCount];
    }
    [self creatOriModel:model totalCount:totalCount];
    
}

- (void)creatOriModel:(YHWorkGroup *)model totalCount:(int)totalCount{
    YHUserInfo *userInfo = [YHUserInfo new];
    model.userInfo = userInfo;
    
    
    NSArray *avtarArray = @[
                            @"http://testapp.gtax.cn/images/2016/11/05/812eb442b6a645a99be476d139174d3c.png!m90x90.png",
                            @"http://testapp.gtax.cn/images/2016/11/09/64a62eaaff7b466bb8fab12a89fe5f2f.png!m90x90.png",
                            @"https://testapp.gtax.cn/images/2016/09/30/ad0d18a937b248f88d29c2f259c14b5e.jpg!m90x90.jpg",
                            @"https://testapp.gtax.cn/images/2016/09/14/c6ab40b1bc0e4bf19e54107ee2299523.jpg!m90x90.jpg",
                            @"http://testapp.gtax.cn/images/2016/11/14/8d4ee23d9f5243f98c79b9ce0c699bd9.png!m90x90.png",
                            @"https://testapp.gtax.cn/images/2016/09/14/8cfa9bd12e6844eea0a2e940257e1186.jpg!m90x90.jpg"];
    int avtarIndex = arc4random() % avtarArray.count;
    if (avtarIndex < avtarArray.count) {
        model.userInfo.avatarUrl = [NSURL URLWithString:avtarArray[avtarIndex]];
    }
    
    
    CGFloat myIdLength = arc4random() % totalCount;
    int result = (int)myIdLength % 2;
    model.userInfo.uid = result ?   [YHUserInfoManager sharedInstance].userInfo.uid:@"2";
    
    CGFloat nLength = arc4random() % 3 + 1;
    NSMutableString *nStr = [NSMutableString new];
    for (int i = 0; i < nLength; i++) {
        [nStr appendString: @"测试名字"];
    }
    model.userInfo.userName = nStr;
    
    CGFloat iLength = arc4random() % 3 + 1;
    NSMutableString *iStr = [NSMutableString new];
    for (int i = 0; i < iLength; i++) {
        [iStr appendString: @"测试行业"];
    }
    model.userInfo.industry = iStr;
    
    
    CGFloat cLength = arc4random() % 8 + 1;
    NSMutableString *cStr = [NSMutableString new];
    for (int i = 0; i < cLength; i++) {
        [cStr appendString: @"测试公司"];
    }
    model.userInfo.company  = cStr;
    
    
    CGFloat jLength = arc4random() % 8 + 1;
    NSMutableString *jStr = [NSMutableString new];
    for (int i = 0; i < jLength; i++) {
        [jStr appendString: @"随机职位"];
    }
    model.userInfo.job = jStr;
    
    CGFloat qlength = arc4random() % totalCount + 5;
    NSMutableString *qStr = [[NSMutableString alloc] init];
    for (NSUInteger i = 0; i < qlength; ++i) {
        [qStr appendString:@"测试数据很长，测试数据很长."];
    }
    model.msgContent = qStr;
    model.publishTime = @"2013-04-17";
    
    
    CGFloat picLength = arc4random() % 9;
    
    //原图
    NSArray *oriPName = @[
                          @"https://testapp.gtax.cn/images/2016/08/25/2241c4b32b8445da87532d6044888f3d.jpg",
                          
                          @"https://testapp.gtax.cn/images/2016/08/25/0abd8670e96e4357961fab47ba3a1652.jpg",
                          
                          @"https://testapp.gtax.cn/images/2016/08/25/5cd8aa1f1b1f4b2db25c51410f473e60.jpg",
                          
                          @"https://testapp.gtax.cn/images/2016/08/25/5e8b978854ef4a028d284f6ddc7512e0.jpg",
                          
                          @"https://testapp.gtax.cn/images/2016/08/25/03c58da45900428796fafcb3d77b6fad.jpg",
                          
                          @"https://testapp.gtax.cn/images/2016/08/25/dbee521788da494683ef336432028d48.jpg",
                          
                          @"https://testapp.gtax.cn/images/2016/08/25/4cd95742b6744114ac8fa41a72f83257.jpg",
                          
                          @"https://testapp.gtax.cn/images/2016/08/25/4d49888355a941cab921c9f1ad118721.jpg",
                          
                          @"https://testapp.gtax.cn/images/2016/08/25/ea6a22e8b4794b9ba63fd6ee587be4d1.jpg"];
    
    NSMutableArray *oriPArr = [NSMutableArray new];
    for (NSString *pName in oriPName) {
        [oriPArr addObject:[NSURL URLWithString:pName]];
    }
    
    //小图
    NSArray *thumbPName = @[
                            @"https://testapp.gtax.cn/images/2016/08/25/2241c4b32b8445da87532d6044888f3d.jpg!t300x300.jpg",
                            
                            @"https://testapp.gtax.cn/images/2016/08/25/0abd8670e96e4357961fab47ba3a1652.jpg!t300x300.jpg",
                            
                            @"https://testapp.gtax.cn/images/2016/08/25/5cd8aa1f1b1f4b2db25c51410f473e60.jpg!t300x300.jpg",
                            
                            @"https://testapp.gtax.cn/images/2016/08/25/5e8b978854ef4a028d284f6ddc7512e0.jpg!t300x300.jpg",
                            
                            @"https://testapp.gtax.cn/images/2016/08/25/03c58da45900428796fafcb3d77b6fad.jpg!t300x300.jpg",
                            
                            @"https://testapp.gtax.cn/images/2016/08/25/dbee521788da494683ef336432028d48.jpg!t300x300.jpg",
                            
                            @"https://testapp.gtax.cn/images/2016/08/25/4cd95742b6744114ac8fa41a72f83257.jpg!t300x300.jpg",
                            
                            @"https://testapp.gtax.cn/images/2016/08/25/4d49888355a941cab921c9f1ad118721.jpg!t300x300.jpg",
                            
                            @"https://testapp.gtax.cn/images/2016/08/25/ea6a22e8b4794b9ba63fd6ee587be4d1.jpg!t300x300.jpg"];
    
    NSMutableArray *thumbPArr = [NSMutableArray new];
    for (NSString *pName in thumbPName) {
        [thumbPArr addObject:[NSURL URLWithString:pName]];
    }
    
    model.originalPicUrls = [oriPArr subarrayWithRange:NSMakeRange(0, picLength)];
    model.thumbnailPicUrls = [thumbPArr subarrayWithRange:NSMakeRange(0, picLength)];
}

#pragma mark - YHRefreshTableViewDelegate
- (void)refreshTableViewLoadNew:(YHRefreshTableView*)view{
    [self getTimelines];
//    [self requestDataLoadNew:YES];
}

- (void)refreshTableViewLoadmore:(YHRefreshTableView*)view{
//    [self requestDataLoadNew:NO];
    [self getOldTimeline];
}


#pragma mark - CellForWorkGroupDelegate
- (void)onAvatarInCell:(CellForWorkGroup *)cell{
    UserMainPageVC *usermainpagevc = [UserMainPageVC new];
    usermainpagevc.account = cell.model.userInfo.uid;
    [self.navigationController pushViewController:usermainpagevc animated:YES];
    
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
    if (cell.indexPath.row < [self.dataArray count]){
        [self _shareWithCell:cell];
    }
}


- (void)onDeleteInCell:(CellForWorkGroup *)cell{
    if (cell.indexPath.row < [self.dataArray count]) {
        [self _deleteDynAtIndexPath:cell.indexPath dynamicId:cell.model.dynamicId];
    }
}

//#pragma mark - CellForWorkGroupRepostDelegate
//
//- (void)onAvatarInRepostCell:(CellForWorkGroupRepost *)cell{
//    
//}
//
//
//- (void)onTapRepostViewInCell:(CellForWorkGroupRepost *)cell{
//}
//
//- (void)onCommentInRepostCell:(CellForWorkGroupRepost *)cell{
//}
//
//- (void)onLikeInRepostCell:(CellForWorkGroupRepost *)cell{
//    
//    if (cell.indexPath.row < [self.dataArray count]) {
//        YHWorkGroup *model = self.dataArray[cell.indexPath.row];
//        
//        BOOL isLike = !model.isLike;
//        //更新本地数据源
//        model.isLike = isLike;
//        if (isLike) {
//            model.likeCount += 1;
//            
//        }else{
//            model.likeCount -= 1;
//        }
//        [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        
//    }
//    
//    
//}
//
//- (void)onShareInRepostCell:(CellForWorkGroupRepost *)cell{
//    
//    if (cell.indexPath.row < [self.dataArray count]){
//        [self _shareWithCell:cell];
//    }
//}
//
//- (void)onDeleteInRepostCell:(CellForWorkGroupRepost *)cell{
//    if (cell.indexPath.row < [self.dataArray count]) {
//        [self _deleteDynAtIndexPath:cell.indexPath dynamicId:cell.model.dynamicId];
//    }
//}
//
//- (void)onMoreInRespostCell:(CellForWorkGroupRepost *)cell{
//    if (cell.indexPath.row < [self.dataArray count]) {
//        YHWorkGroup *model = self.dataArray[cell.indexPath.row];
//        model.isOpening = !model.isOpening;
//        [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
//}
//

#pragma mark - private
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
                
                if([responseObject objectForKey:@"success"]||[[responseObject objectForKey:@"error"] isEqual:@"未找到timeline"]){
                    [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
                    [weakSelf.heightDict removeObjectForKey:dynamicId];
                    [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    
                }else{
                    [SVProgressHUD showInfoWithStatus:@"删除失败！"];
                }
                
                NSLog(@"dddelte%@",[responseObject objectForKey:@"error"]);
                
            } failure:^(NSError *error) {
                [SVProgressHUD showInfoWithStatus:@"error"];
            }];
            
            
            
            
        }
    }];
    
}

- (void)_shareWithCell:(UITableViewCell *)cell{
    
    CellForWorkGroup *cellOri     = nil;
    cellOri = (CellForWorkGroup *)cell;
    YHWorkGroup *model = [YHWorkGroup new];
    
    model = cellOri.model;
    
    
    YHSharePresentView *shareView = [[YHSharePresentView alloc] init];
    shareView.shareType = ShareType_WorkGroup;
    [shareView show];
    [shareView dismissHandler:^(BOOL isCanceled, NSInteger index) {
        if (!isCanceled) {
            switch (index)
            {
                case 2:
                {
                    DDLog(@"动态");
                }
                    break;
                case 3:
                {
                    
                }
                    break;
                    
                case 0:
                {
                    //朋友圈
                    DDLog(@"朋友圈");
                    
                }
                    break;
                case 1:
                {
                    //微信好友
                    DDLog(@"微信好友");
                    
                }
                    break;
                default:
                    break;
            }
            
        }
    }];
    
    
    
}



-(void)addTimeline{
    AddTimelineVC *vc = [[AddTimelineVC alloc] init];
    vc.title = @"新动态";
    [self.navigationController pushViewController:vc animated:YES];
    [vc addSuccess:^{
        [self getTimelines];
    }];

}

-(void)getTimelines{
    NSString *paramUrlpre = [@"?amount=" stringByAppendingString:amount];
    NSString *paramUrl;
    if(since_id){
        NSString *paramUrl2 = [@"&since_id=" stringByAppendingString:since_id];
        paramUrl = [paramUrlpre stringByAppendingString:paramUrl2];
    }else{
        paramUrl = paramUrlpre;
    }
    WeakSelf
    [[NetworkManager shareNetwork]getTimelinesWithParam:nil paramsUrl:paramUrl successful:^(NSDictionary *responseObject) {
        NSLog(@"getTimelines%@",responseObject);

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
//            weakSelf.newdataArray[i].likeCount = [weakSelf.newdataArray[i].liked intValue];
            weakSelf.newdataArray[i].likeCount = (int)weakSelf.newdataArray[i].likes.count;
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
        
    }];
}

-(void)getOldTimeline{
    NSString *paramUrlpre = [@"?amount=" stringByAppendingString:amount];
    NSString *paramUrl;
    if(lastTimelineID){
        
        NSString *paramUrl2 = [@"&lastTimelineID=" stringByAppendingString:lastTimelineID];
        paramUrl = [paramUrlpre stringByAppendingString:paramUrl2];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        WeakSelf
        [[NetworkManager shareNetwork]getTimelinesWithParam:nil paramsUrl:paramUrl successful:^(NSDictionary *responseObject) {
            NSLog(@"getoldTimeline%@",responseObject);
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
            
        }];
    }
}

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
