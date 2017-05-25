//
//  HeadCell.m
//  ChatImmmg
//
//  Created by 王凯 on 2017/5/21.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import "HeadCell.h"
@interface HeadCell()

@property(nonatomic,strong)UIImageView *icon;

@end
@implementation HeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self createHeadCell];
    }
    return self;

}

-(void)createHeadCell{
    UILabel *iconLabel = [UILabel new];
    iconLabel.text = @"头像";
    [self addSubview:iconLabel];
    
    [iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(30);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
        
    }];
    
    UIImageView *icon = [UIImageView new];
    icon.image = [UIImage imageNamed:@"morentouxiang"];
    [self addSubview:icon];
    icon.layer.borderWidth = 0.5f;
    icon.layer.borderColor = [UIColor grayColor].CGColor;
    self.icon = icon;
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(8);
        make.width.height.mas_equalTo(64);
    }];

}

-(void)configModel:(NSString *)url{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:url]];

}
@end
