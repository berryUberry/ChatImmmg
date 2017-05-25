//
//  ScrollView.m
//  ImgChat
//
//  Created by 王凯 on 2017/4/10.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import "ScrollView.h"
#import <Masonry/Masonry.h>

@interface ScrollView()
@property(nonatomic,strong) UITextField *account;
@property(nonatomic,strong) UITextField *password;
@property(nonatomic,strong) UITextField *accountA;
@property(nonatomic,strong) UITextField *passwordA;
@property(nonatomic,strong) UITextField *username;


@end
@implementation ScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    self = [super init];
    if(self){
        [self setupView];
    }
    return self;
}

-(void)setupView{

    UITextField *account = [UITextField new];
    account.placeholder = @"账号";
    [self addSubview:account];
    [account mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(40);
        make.left.equalTo(self);
        make.width.equalTo(self.mas_width);
        make.height.mas_equalTo(40);
    }];
    self.account = account;
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = [UIColor grayColor];
    [self addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(account);
        make.top.equalTo(account.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    UITextField *password = [UITextField new];
    password.placeholder = @"密码";
    [self addSubview:password];
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(account);
        make.top.equalTo(account.mas_bottom);
    }];
    self.password = password;
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = [UIColor grayColor];
    [self addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(password);
        make.top.equalTo(password.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    
    UITextField *accountA = [UITextField new];
    accountA.placeholder = @"账号";
    [self addSubview:accountA];
    [accountA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(account.mas_right);
        make.width.equalTo(self.mas_width);
        make.height.mas_equalTo(40);
    }];
    self.accountA = accountA;
    
    UIView *line1A = [UIView new];
    line1A.backgroundColor = [UIColor grayColor];
    [self addSubview:line1A];
    [line1A mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(accountA);
        make.top.equalTo(accountA.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    UITextField *username = [UITextField new];
    username.placeholder = @"昵称";
    [self addSubview:username];
    [username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(accountA);
        make.top.equalTo(accountA.mas_bottom);
    }];
    self.username = username;
    
    UIView *line2A = [UIView new];
    line2A.backgroundColor = [UIColor grayColor];
    [self addSubview:line2A];
    [line2A mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(username);
        make.top.equalTo(username.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    UITextField *passwordA = [UITextField new];
    passwordA.placeholder = @"密码";
    [self addSubview:passwordA];
    [passwordA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(accountA);
        make.top.equalTo(username.mas_bottom);
    }];
    self.passwordA = passwordA;
    
    UIView *line3A = [UIView new];
    line3A.backgroundColor = [UIColor grayColor];
    [self addSubview:line3A];
    [line3A mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(passwordA);
        make.top.equalTo(passwordA.mas_bottom);
        make.height.mas_equalTo(1);
    }];

    
}

-(NSString *)getLoginAccount{
    return self.account.text;
}

-(NSString *)getLoginPassword{
    return self.password.text;
}

-(NSString *)getRegisterAccount{
    return self.accountA.text;
}

-(NSString *)getRegisterPassword{
    return self.passwordA.text;
}

-(NSString *)getRegisterName{
    return self.username.text;
}
@end
