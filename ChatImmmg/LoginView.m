//
//  LoginView.m
//  ImgChat
//
//  Created by 王凯 on 2017/4/10.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import "LoginView.h"
#import <Masonry/Masonry.h>


@implementation LoginView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setupView];
    }
    return self;
    
}

-(void)setupView{
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *headImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon2"]];
    headImgView.layer.cornerRadius = 5;
    headImgView.layer.masksToBounds = YES;
    [self addSubview:headImgView];
    [headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self).offset(60);
        make.height.mas_equalTo(120);
    }];
    
    ScrollView *scrollView = [[ScrollView alloc]init];
    scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView = scrollView;
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headImgView);
        make.top.equalTo(headImgView.mas_bottom).offset(40);
        make.height.mas_equalTo(125);
    }];
    scrollView.contentSize = CGSizeMake((self.frame.size.width)*2, 85);
    
    UIButton *loginButton = [UIButton new];
    loginButton.backgroundColor = MainColor;
    loginButton.layer.cornerRadius = 5;
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [self addSubview:loginButton];
    self.loginButton = loginButton;
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headImgView);
        make.top.equalTo(scrollView.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *labelButton = [UIButton new];
    labelButton.backgroundColor = [UIColor whiteColor];
    [labelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [labelButton setTitle:@"没有账户？去注册" forState:UIControlStateNormal];
    [self addSubview:labelButton];
    self.labelButton = labelButton;
    [labelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headImgView);
        make.top.equalTo(loginButton.mas_bottom).offset(8);
        make.height.mas_equalTo(30);
    }];
}


@end
