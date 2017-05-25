//
//  CommentCell.m
//  ChatImmmg
//
//  Created by 王凯 on 2017/5/25.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import "CommentCell.h"

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
    [self addSubview:headImg];
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(8);
        make.height.width.mas_equalTo(40);
    }];

    UILabel *name = [UILabel new];
    [self addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImg.mas_top).offset(10);
        make.left.equalTo(headImg.mas_right).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    

}
@end
