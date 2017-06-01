//
//  CommentCell.h
//  ChatImmmg
//
//  Created by 王凯 on 2017/5/25.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelineCommentModel.h"
@class CommentCell;
@protocol CommentCellDelegate <NSObject>
-(void)gotoMainPage:(CommentCell *)commentcell;
@end
@interface CommentCell : UITableViewCell
@property(nonatomic,strong) TimelineCommentModel *model;
@property (weak,nonatomic) id<CommentCellDelegate>delegate;
-(void)configModel:(TimelineCommentModel *)model;
@end
