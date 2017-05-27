//
//  TopViewCell.m
//  ChatImmmg
//
//  Created by 王凯 on 2017/5/27.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import "TopViewCell.h"
@interface TopViewCell()
@property(nonatomic,strong)UIImageView *headImg;
@property(nonatomic,strong)UILabel *name;
@end
@implementation TopViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if([super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self createTopViewCell];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)createTopViewCell{
    UIImageView *backgroundImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    [self addSubview:backgroundImg];
    
    UIImageView *headImg = [UIImageView new];
    headImg.image = [UIImage imageNamed:@"common_avatar_120px"];
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

-(void)configModel:(NSString *)headUrl name:(NSString *)name isHide:(NSString *)ishide{
    if(headUrl){
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:headUrl]];
    }
    self.name.text = name;
    if([ishide isEqual:@"hide"]){
        self.followBtn.hidden = YES;
        self.chatBtn.hidden = YES;
    }else{
        self.followBtn.hidden = NO;
        self.chatBtn.hidden = NO;
    }
}

@end
