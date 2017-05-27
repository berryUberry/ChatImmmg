//
//  CommentCell.h
//  ChatImmmg
//
//  Created by 王凯 on 2017/5/25.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelineCommentModel.h"

@interface CommentCell : UITableViewCell
-(void)configModel:(TimelineCommentModel *)model;
@end
