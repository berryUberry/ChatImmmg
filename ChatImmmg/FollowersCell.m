//
//  FollowersCell.m
//  ChatImmmg
//
//  Created by 王凯 on 2017/5/20.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import "FollowersCell.h"
#import "HeadImgView.h"
@interface FollowersCell()
@property(nonatomic,strong)HeadImgView *headImg;
@property(nonatomic,strong)UILabel *name;

@end

@implementation FollowersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self createFirendsCell];
    }
    return self;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)createFirendsCell{
    HeadImgView *headImg = [HeadImgView new];
    self.headImg = headImg;
    [self addSubview:self.headImg];
    
    UILabel *name = [UILabel new];
    name.textAlignment = NSTextAlignmentLeft;
    self.name = name;
    [self addSubview:self.name];
    
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(8);
        make.width.height.mas_equalTo(40);
    }];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImg.mas_right).offset(8);
        make.right.mas_equalTo(-8);
        make.top.equalTo(headImg.mas_top).offset(5);
        make.height.mas_equalTo(30);
    }];
    
    
}

-(void)configModel:(UserInfo *)model{
    self.headImg.model = model;
    self.name.text = model.name;
    
}

@end
