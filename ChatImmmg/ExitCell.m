//
//  ExitCell.m
//  ChatImmmg
//
//  Created by 王凯 on 2017/5/28.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import "ExitCell.h"

@implementation ExitCell

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
        [self createExitCell];
    }
    return self;
    
}

-(void)createExitCell{
    UIButton *exitBtn = [UIButton new];
    exitBtn.backgroundColor = [UIColor redColor];
    exitBtn.layer.cornerRadius = 5;
    [exitBtn setTitle:@"退出" forState:normal];
    exitBtn.titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:exitBtn];
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.bottom.mas_equalTo(-2);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    self.exitBtn = exitBtn;
}

@end
