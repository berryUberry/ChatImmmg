//
//  PersonalTopView.h
//  Meeeets
//
//  Created by 王凯 on 2017/4/26.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalTopView : UIView
@property(nonatomic,strong)UIButton *followBtn;
@property(nonatomic,strong)UIButton *chatBtn;
-(void)configModel:(NSString *)headUrl name:(NSString *)name;
@end
