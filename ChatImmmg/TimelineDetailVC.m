//
//  TimelineDetailVC.m
//  ChatImmmg
//
//  Created by 王凯 on 2017/5/24.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import "TimelineDetailVC.h"
#import "YHRefreshTableView.h"
#import "CellForWorkGroup.h"
#import "YHUserInfoManager.h"
#import "YHUtils.h"
#import "YHSharePresentView.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#import "CommentView.h"
#import "CommentCell.h"
#import "TimelineCommentModel.h"

@interface TimelineDetailVC ()<UITableViewDelegate,UITableViewDataSource,CellForWorkGroupDelegate,UITextViewDelegate>

@property (nonatomic,strong) YHRefreshTableView *tableView;
@property (nonatomic,strong) NSMutableDictionary *heightDict;

@property (nonatomic,strong) CommentView *commentView;
@property (nonatomic , strong)UITapGestureRecognizer *gesture;

@property (nonatomic,strong) NSMutableArray<NSString *> *commentCellheights;

//@property(nonatomic,strong) NSMutableArray<TimelineCommentModel *> *comments;

@end

@implementation TimelineDetailVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    //注册键盘出现与隐藏时候的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboadWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self calcCommentCellHeights];
    [self getDetailTimeline];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    self.gesture.numberOfTapsRequired = 1;//手势敲击的次数
    [self.view addGestureRecognizer:self.gesture];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.view removeGestureRecognizer:self.gesture];
}

-(void)initUI{
    self.title = @"动态详情";
    
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
    
    
    self.tableView = [[YHRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGBCOLOR(244, 244, 244);
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
//    [self.tableView setEnableLoadNew:YES];
    [self.tableView setEnableLoadMore:YES];
    
    self.view.backgroundColor = RGBCOLOR(244, 244, 244);
    
    [self.tableView registerClass:[CellForWorkGroup class] forCellReuseIdentifier:NSStringFromClass([CellForWorkGroup class])];
    [self.tableView registerClass:[CommentCell class] forCellReuseIdentifier:NSStringFromClass([CommentCell class])];
    
    CommentView *commentView = [CommentView new];
    [self.view addSubview:commentView];
    [commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50.5);
    }];
    self.commentView = commentView;
    self.commentView.textView.delegate = self;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return 40;
    }else{
        return 0;
    }

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if(section == 1){
        return [NSString stringWithFormat:@"评论数：%lu",(unsigned long)self.model.comments.count];
    }else{
        return nil;
    }
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else{
        return self.model.comments.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        CellForWorkGroup *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CellForWorkGroup class])];
        if (!cell) {
            cell = [[CellForWorkGroup alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([CellForWorkGroup class])];
        }
        cell.indexPath = indexPath;
        cell.model = self.model;
        cell.delegate = self;
        cell.viewBottom.hidden = YES;
        return cell;
    }else{
        CommentCell *cell = [[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([CommentCell class])];
        [cell configModel:self.model.comments[indexPath.row]];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        CGFloat height = 0.0;
        //取缓存高度
        NSDictionary *dict =  self.heightDict[self.model.dynamicId];
        if (dict) {
            if (self.model.isOpening) {
                height = [dict[@"open"] floatValue];
            }else{
                height = [dict[@"normal"] floatValue];
            }
            if (height) {
                return height - 44;
            }
        }
        
        
        
        height = [CellForWorkGroup hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
            CellForWorkGroup *cell = (CellForWorkGroup *)sourceCell;
            
            cell.model = self.model;
            
        }];
        
        
        //缓存高度
        if (self.model.dynamicId) {
            NSMutableDictionary *aDict = [NSMutableDictionary new];
            if (self.model.isOpening) {
                [aDict setObject:@(height) forKey:@"open"];
            }else{
                [aDict setObject:@(height) forKey:@"normal"];
            }
            [self.heightDict setObject:aDict forKey:self.model.dynamicId];
        }
        return height - 44;
    }else{

        return [self.commentCellheights[indexPath.row] floatValue];
        
    }
}


#pragma mark - CellForWorkGroupDelegate
- (void)onAvatarInCell:(CellForWorkGroup *)cell{
    
}

- (void)onMoreInCell:(CellForWorkGroup *)cell{
    DDLog(@"查看详情");
    
    YHWorkGroup *model = self.model;
    model.isOpening = !model.isOpening;
    [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    
}



#pragma mark - 键盘出现消失等方法
//键盘出现时候调用的事件
-(void) keyboadWillShow:(NSNotification *)note{
    
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//键盘的frame
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 60 - keyboardSize.height, SCREEN_WIDTH, SCREEN_HEIGHT - 60);//UITextField位置的y坐标移动到offY
    }];
    
    
}
//键盘消失时候调用的事件
-(void)keyboardWillHide:(NSNotification *)note{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT - 60);//UITextField位置复原
    }];
    
}
//隐藏键盘方法
-(void)hideKeyboard{
    [self.commentView.textView resignFirstResponder];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.commentView.placeholderLabel.text = @"";
    
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if([textView.text length] == 0){
        self.commentView.placeholderLabel.text = @"说点什么...";
        return;
    }
    self.commentView.placeholderLabel.text = @"";
}

#pragma mark -- 输入限制50个字
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        [self comment];
        return NO;
        
    }
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < 50) {
            return YES;
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"输入字数超过50个字符！"];
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = 50 - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            
        }
        [SVProgressHUD showErrorWithStatus:@"输入字数超过50个字符！"];
        return NO;
    }
    
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
    
    //输入框随行数增加高度增加
    [self changeTextViewHeight:textView];
    
    //输入限制字数
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > 50)
    {
        //截取到最大位置的字符
        [SVProgressHUD showErrorWithStatus:@"输入字数超过50个字符！"];
        NSString *s = [nsTextContent substringToIndex:50];
        
        [textView setText:s];
        
        //输入框随行数增加高度增加
        [self changeTextViewHeight:textView];
    }
    
}

-(void)changeTextViewHeight:(UITextView *)textView{
    //输入框随行数增加高度增加
    [textView flashScrollIndicators];   // 闪动滚动条
    
    static CGFloat maxHeight = 130.0f;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height >= maxHeight)
    {
        size.height = maxHeight;
        textView.scrollEnabled = YES;   // 允许滚动
    }
    else
    {
        textView.scrollEnabled = NO;    // 不允许滚动，当textview的大小足以容纳它的text的时候，需要设置scrollEnabed为NO，否则会出现光标乱滚动的情况
    }
    [self.commentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height + 20);
    }];
    
    
}

//发评论
-(void)comment{
    [SVProgressHUD show];
    if(self.commentView.textView.text){
        NSDictionary *params = @{@"timelineID" : self.model.dynamicId,
                             @"content" : self.commentView.textView.text
                             };
        [[NetworkManager shareNetwork]commentTimelineWithParam:params successful:^(NSDictionary *responseObject) {
            NSLog(@"commentTimeline%@",responseObject);
            if([responseObject objectForKey:@"success"]){
                [SVProgressHUD dismiss];
                [SVProgressHUD showSuccessWithStatus:@"评论成功！"];
            }else{
                [SVProgressHUD dismiss];
                [SVProgressHUD showInfoWithStatus:@"评论失败！"];
            }
            
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"error"];
        }];
    
    }else{
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:@"内容不能为空！"];
    }
}

-(void)calcCommentCellHeights{
    for(int i = 0;i<self.model.comments.count;i++){
                NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:13.0]};
                CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 25, MAXFLOAT);
        
                // 计算文字占据的高度
                CGSize size = [self.model.comments[i].content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
        if(i == 0){
            self.commentCellheights = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%g",size.height + 75], nil];
        }else{
            [self.commentCellheights addObject:[NSString stringWithFormat:@"%g",size.height + 75]];
        }
        
    }
}


-(void)getDetailTimeline{
    
    NSString *paramUrl = [@"?timelineID=" stringByAppendingString:self.model.dynamicId];
    [[NetworkManager shareNetwork]getDetailTimelineWithParam:nil paramsUrl:paramUrl successful:^(NSDictionary *responseObject) {
        NSLog(@"detailTimeline%@",responseObject);
        self.model = [YHWorkGroup mj_objectWithKeyValues:[responseObject objectForKey:@"result"]];
        self.commentCellheights = nil;
        [self calcCommentCellHeights];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"error"];
    }];
}

@end
