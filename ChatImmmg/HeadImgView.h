//
//  HeadImgView.h
//  ChatImmmg
//
//  Created by 王凯 on 2017/5/21.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface HeadImgView : UIView

@property(nonatomic,strong)UserInfo *model;

/**
 是否可以点击，默认为YES
 */
@property(nonatomic,assign) BOOL canTouch;

@property(nonatomic,strong) UIView *contentView;

@end
