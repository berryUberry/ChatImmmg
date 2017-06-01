//
//  AddTimelineVC.h
//  ChatImmmg
//
//  Created by 王凯 on 2017/5/17.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^AddTimelineBlock)();
@interface AddTimelineVC : UIViewController

-(void)addSuccess:(AddTimelineBlock)disblock;

@end
