//
//  PersonalTopView.m
//  Meeeets
//
//  Created by 王凯 on 2017/4/26.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import "PersonalTopView.h"
@interface PersonalTopView()
@property(nonatomic,strong)UIImageView *headImg;
@property(nonatomic,strong)UILabel *name;

@end
@implementation PersonalTopView

-(instancetype)init{
    if(self = [super init]){
        [self createView];
    }
    return self;
}

-(void)createView{
    UIImageView *backgroundImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    [self addSubview:backgroundImg];
    
    UIImageView *headImg = [UIImageView new];
    self.headImg = headImg;
    [self addSubview:self.headImg];
    
    UILabel *name = [UILabel new];
    self.name = name;
    name.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0];
    [self addSubview:self.name];
    
    UIButton *followBtn = [UIButton new];
    [followBtn setTitle:@"关注" forState:normal];
    followBtn.backgroundColor = [UIColor blueColor];
    self.followBtn = followBtn;
    followBtn.layer.cornerRadius = 5.0;
    followBtn.backgroundColor = [UIColor colorWithRed:51/255.0 green:161/255.0 blue:201/255.0 alpha:1.0] ;
    [self addSubview:self.followBtn];
    
    
    UIButton *chatBtn = [UIButton new];
    [chatBtn setTitle:@"私聊" forState:normal];
    chatBtn.backgroundColor = [UIColor blueColor];
    self.chatBtn = chatBtn;
    chatBtn.layer.cornerRadius = 5.0;
    chatBtn.backgroundColor = [UIColor colorWithRed:51/255.0 green:161/255.0 blue:201/255.0 alpha:1.0] ;
    [self addSubview:self.chatBtn];
    
    
    
    
    [backgroundImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.left.equalTo(self);
        make.height.mas_equalTo(184);
    }];
    
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroundImg.mas_bottom).offset(-40);
        make.left.mas_equalTo(40);
        make.width.height.mas_equalTo(80);
    }];
    
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImg.mas_bottom).offset(5);
        make.left.equalTo(headImg.mas_left);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(30);
    }];
    
    [chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(name.mas_top).offset(-10);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    [followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(chatBtn.mas_top);
        make.right.equalTo(chatBtn.mas_left).offset(-10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
}

-(void)configModel:(NSString *)headUrl name:(NSString *)name{
    self.headImg.image = [UIImage imageNamed:headUrl];
    self.name.text = name;
    
}

@end