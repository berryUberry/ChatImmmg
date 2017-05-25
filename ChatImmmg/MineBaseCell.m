//
//  MineBaseCell.m
//  ChatImmmg
//
//  Created by 王凯 on 2017/5/21.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import "MineBaseCell.h"

@interface MineBaseCell()
@property(nonatomic,strong)UILabel *frontLabel;
@property(nonatomic,strong)UILabel *lastLabel;

@end

@implementation MineBaseCell

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
        [self createMineBaseCell];
    
    }

    return self;
}


-(void)createMineBaseCell{
    UILabel *frontLabel = [UILabel new];
    [self addSubview:frontLabel];
    self.frontLabel = frontLabel;
    [frontLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    
    
    UILabel *lastLabel = [UILabel new];
    [self addSubview:lastLabel];
    self.lastLabel = lastLabel;
    lastLabel.numberOfLines = 0;
    lastLabel.textAlignment = NSTextAlignmentRight;
    lastLabel.textColor = [UIColor grayColor];
    lastLabel.font = [UIFont systemFontOfSize:16];
    [lastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(250);
    }];
}

-(void)configModel:(NSString *)front last:(NSString *)last{
    self.frontLabel.text = front;
    self.lastLabel.text = last;
    CGRect rect = [last boundingRectWithSize:CGSizeMake(250, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
    CGSize textSize = [last sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    NSUInteger textRow = (NSUInteger)(rect.size.height / textSize.height);
    if(textRow > 1){
        self.lastLabel.textAlignment = NSTextAlignmentLeft;
    }else{
        self.lastLabel.textAlignment = NSTextAlignmentRight;
    }
}
@end
