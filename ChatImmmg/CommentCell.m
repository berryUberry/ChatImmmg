//
//  CommentCell.m
//  ChatImmmg
//
//  Created by 王凯 on 2017/5/25.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import "CommentCell.h"
@interface CommentCell()
@property(nonatomic,strong) UIImageView *headImg;
@property(nonatomic,strong) UILabel *name;
@property(nonatomic,strong) UILabel *time;
@property(nonatomic,strong) UILabel *content;
@end

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if([super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self createCommentCell];
    }
    return self;
}

-(void)createCommentCell{
    UIImageView *headImg = [UIImageView new];
    headImg.image = [UIImage imageNamed:@"common_avatar_120px"];
    [self addSubview:headImg];
    self.headImg = headImg;
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(8);
        make.height.width.mas_equalTo(40);
    }];
    headImg.layer.cornerRadius = 20;
    headImg.layer.masksToBounds = YES;
    
    
    
    UILabel *name = [UILabel new];
    [self addSubview:name];
    self.name = name;
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImg.mas_top).offset(10);
        make.left.equalTo(headImg.mas_right).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *time = [UILabel new];
    [self addSubview:time];
    time.font = [UIFont systemFontOfSize:10.0];
    time.textAlignment = NSTextAlignmentRight;
    time.textColor = [UIColor grayColor];
    self.time = time;
    [time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(name.mas_top);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *content = [UILabel new];
    content.preferredMaxLayoutWidth = (SCREEN_WIDTH - 25);
    [content setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    content.font = [UIFont systemFontOfSize:13.0];
    content.numberOfLines = 0;
    [self addSubview:content];
    self.content = content;
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(headImg.mas_bottom).offset(8);
        make.right.mas_equalTo(-10);
    }];

}


-(void)configModel:(TimelineCommentModel *)model{
    if(model.user.avatar){
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.user.avatar]];
    }
    self.name.text = model.name;
    self.time.text = model.publishDate;
    self.content.text = model.content;
}

@end
