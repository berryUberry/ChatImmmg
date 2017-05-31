//
//  UserInfo.h
//  Meeeets
//
//  Created by 王凯 on 2017/4/26.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject<NSCoding>
@property(nonatomic,strong)NSString *account;
@property(nonatomic,strong)NSMutableArray *follow_infos;
@property(nonatomic,strong)NSString *isDefaultAvatar;
@property(nonatomic,strong)NSString *nickname;
@property(nonatomic,strong)NSString *official;
@property(nonatomic,strong)NSString *avatar;

@property(nonatomic,strong)NSString *_id;
@property(nonatomic,strong)NSString *__v;
@property(nonatomic,strong)NSString *follower;
@property(nonatomic,strong)NSString *following;

@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *motto;


@end
