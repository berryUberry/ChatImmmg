//
//  HeadImgView.m
//  ChatImmmg
//
//  Created by 王凯 on 2017/5/21.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import "HeadImgView.h"

@interface HeadImgView()
{
    UIImageView *_headImg;
}

@end

@implementation HeadImgView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        _canTouch = YES;
        [self createView];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _canTouch = YES;
        [self createView];
    }
    return self;
}

-(void)createView{
    self.backgroundColor = [UIColor clearColor];
    
    UIView *contentView = [UIView new];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _contentView = contentView;

    /***************************头像*********************************/
    UIImageView *head = [UIImageView new];
    head.image = [UIImage imageNamed:@"morentouxiang"];
    head.userInteractionEnabled = YES;
    head.layer.masksToBounds = YES;
    [contentView addSubview:head];
    
    _headImg = head;

    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    
    _contentView.frame = self.bounds;
    
    _headImg.frame = CGRectMake(0, 0, width, width);
    _headImg.layer.cornerRadius = self.bounds.size.width / 2;

}


- (void)setModel:(UserInfo *)model {
    if (_model != model) {
        _model = model;
        
        if(model.avatar){
            NSURL *url = [NSURL URLWithString:model.avatar];
            [_headImg sd_setImageWithURL:url];
        
        }
    }
}



#pragma mark - 点击方法
- (void)tap:(UITapGestureRecognizer *)sender {
    
    if (!self.canTouch) {
        return;
    }
    
    
}
@end
