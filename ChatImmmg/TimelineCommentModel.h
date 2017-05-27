//
//  TimelineCommentModel.h
//  ChatImmmg
//
//  Created by 王凯 on 2017/5/25.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
@interface TimelineCommentModel : NSObject

@property(nonatomic,strong) NSString *__v;
@property(nonatomic,strong) NSString *_id;
@property(nonatomic,strong) NSString *account;
@property(nonatomic,strong) NSString *authorAccount;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *publishDate;
@property(nonatomic,strong) NSString *timelineID;
@property(nonatomic,strong) NSString *avatar;
@property(nonatomic,strong) UserInfo *user;
@end
