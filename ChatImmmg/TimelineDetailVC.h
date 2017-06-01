//
//  TimelineDetailVC.h
//  ChatImmmg
//
//  Created by 王凯 on 2017/5/24.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHWorkGroup.h"

typedef void(^ChangeBlock)(YHWorkGroup *);
typedef void (^DeleteModelBlock)(YHWorkGroup *);

@interface TimelineDetailVC : UIViewController

@property (nonatomic,strong) YHWorkGroup *model;

-(void)changeModel:(ChangeBlock)disblock;
-(void)deleteTimeline:(DeleteModelBlock)disBlock;

@end
