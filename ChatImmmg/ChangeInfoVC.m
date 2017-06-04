//
//  ChangeInfoVC.m
//  ChatImmmg
//
//  Created by 王凯 on 2017/6/1.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import "ChangeInfoVC.h"

@interface ChangeInfoVC ()<UITextViewDelegate>
@property(nonatomic,assign) int maxCount;
@end

@implementation ChangeInfoVC

-(instancetype)init{
    if(self){
        [self setupView];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setupView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupView{
    
    UIButton *publishBtn = [UIButton new];
    publishBtn.frame = CGRectMake(0, 0, 40, 25);
    [publishBtn setTitle:@"保存" forState:normal];
    [publishBtn addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *publishItem = [[UIBarButtonItem alloc]initWithCustomView:publishBtn];
    self.navigationItem.rightBarButtonItem = publishItem;

    
    UITextView *text = [UITextView new];
//    text.backgroundColor = [UIColor grayColor];
    self.text = text;
    text.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [text becomeFirstResponder];
    [self.view addSubview:text];
    text.layer.borderColor = [UIColor colorWithRed:46.0f / 255 green:139.0f / 255 blue:87.0f / 255 alpha:1].CGColor;
    text.layer.borderWidth = 1;
    text.layer.cornerRadius =5;
    text.font = [UIFont systemFontOfSize:20];
    text.returnKeyType = UIReturnKeyDone;
    text.delegate = self;
    
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(60);
    }];
    
}

-(void)publish{
    if([self.text.text isEqual:@""]){
        [SVProgressHUD showInfoWithStatus:@"不能为空"];
    }else{
        if([self.type isEqual:@"name"]){
            
            NSDictionary *param = @{@"name":self.text.text
                                    };
            
            WeakSelf
            [[NetworkManager shareNetwork]changeNameWithParam:param successful:^(NSDictionary *responseObject) {
                NSLog(@"changename%@",responseObject);
                
                if([[responseObject objectForKey:@"error"] isEqual:@"token不能为空"]){
                    [SVProgressHUD showErrorWithStatus:@"登陆信息失效！请重新登录!"];
                    LoginVC *loginvc = [LoginVC new];
                    [weakSelf presentViewController:loginvc animated:YES completion:nil];
                }
                
                
                if([responseObject objectForKey:@"error"]){
                    [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"error"]];
                }else{
                    
                    NSDictionary *result = [responseObject objectForKey:@"result"];
                    if(result){
                        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                        
                        [userDefault setObject:weakSelf.text.text forKey:@"name"];
                        
                        [SVProgressHUD showSuccessWithStatus:@"修改昵称成功！"];
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                }
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"error"];
            }];
        }else{
            NSDictionary *param = @{@"motto":self.text.text
                                    };
            
            WeakSelf
            [[NetworkManager shareNetwork]changeMottoWithParam:param successful:^(NSDictionary *responseObject) {
                NSLog(@"changemotto%@",responseObject);
                
                if([[responseObject objectForKey:@"error"] isEqual:@"token不能为空"]){
                    [SVProgressHUD showErrorWithStatus:@"登陆信息失效！请重新登录!"];
                    LoginVC *loginvc = [LoginVC new];
                    [weakSelf presentViewController:loginvc animated:YES completion:nil];
                }
                
                if([responseObject objectForKey:@"error"]){
                    [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"error"]];
                }else{
                    
                    NSDictionary *result = [responseObject objectForKey:@"result"];
                    if(result){
                        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                        
                        [userDefault setObject:weakSelf.text.text forKey:@"motto"];
                        
                        [SVProgressHUD showSuccessWithStatus:@"修改个性签名成功！"];
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                }
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"error"];
            }];
        }
    }
    
}


#pragma mark -- 输入限制maxCount个字
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([self.type isEqual:@"name"]){
        self.maxCount = 15;
    }else{
        self.maxCount = 30;
    }
    if([text isEqualToString:@"\n"]){
        [self publish];
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
        
        if (offsetRange.location < _maxCount) {
            return YES;
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"输入字数超过%d个字符！",_maxCount]];
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = _maxCount - comcatstr.length;
    
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
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"输入字数超过%d个字符！",_maxCount]];
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
    
    if (existTextNum > _maxCount)
    {
        //截取到最大位置的字符
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"输入字数超过%d个字符！",_maxCount]];
        NSString *s = [nsTextContent substringToIndex:_maxCount];
        
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
    [self.text mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height + 20);
    }];
    
    
}


@end
