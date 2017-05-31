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
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self._id = [aDecoder decodeObjectForKey:@"_id"];
        self.__v = [aDecoder decodeObjectForKey:@"__v"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.motto = [aDecoder decodeObjectForKey:@"motto"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder  {
    [aCoder encodeObject:self.account forKey:@"account"];
    [aCoder encodeObject:self.follow_infos forKey:@"follow_infos"];
    [aCoder encodeObject:self.isDefaultAvatar forKey:@"isDefaultAvatar"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.official forKey:@"official"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self._id forKey:@"_id"];
    [aCoder encodeObject:self.__v forKey:@"__v"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.motto forKey:@"motto"];
}


+ (NSDictionary *)mj_objectClassInArray {
    return @{@"result" : @"UserInfo"
             };
}

@end
