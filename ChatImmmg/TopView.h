//
//  TopView.h
//  Meeeets
//
//  Created by 王凯 on 2017/4/26.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopView : UIView
@property(nonatomic,strong)UIButton *exitBtn;
-(void)configModel:(NSString *)headUrl name:(NSString *)name;
@end
