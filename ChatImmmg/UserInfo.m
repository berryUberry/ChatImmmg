//
//  UserInfo.m
//  Meeeets
//
//  Created by 王凯 on 2017/4/26.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

- (id)initWithCoder:(NSCoder *)aDecoder  {
    if(self = [super init]) {
        
        self.account = [aDecoder decodeObjectForKey:@"account"];
        self.follow_infos = [aDecoder decodeObjectForKey:@"follow_infos"];
        self.isDefaultAvatar = [aDecoder decodeObjectForKey:@"isDefaultAvatar"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.official = [aDecoder decodeObjectForKey:@"official"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder  {
    [aCoder encodeObject:self.account forKey:@"account"];
    [aCoder encodeObject:self.follow_infos forKey:@"follow_infos"];
    [aCoder encodeObject:self.isDefaultAvatar forKey:@"isDefaultAvatar"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.official forKey:@"official"];
}


+ (NSDictionary *)mj_objectClassInArray {
    return @{@"result" : @"UserInfo"
             };
}

@end
