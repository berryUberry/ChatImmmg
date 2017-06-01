//
//  TopViewCell.h
//  ChatImmmg
//
//  Created by 王凯 on 2017/5/27.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopViewCell : UITableViewCell
@property(nonatomic,strong)UIButton *followBtn;
@property(nonatomic,strong)UIButton *chatBtn;
-(void)configModel:(NSString *)headUrl name:(NSString *)name isHide:(NSString *)ishide motto:(NSString *)motto;
@end
