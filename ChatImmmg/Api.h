//
//  Api.h
//  ChatImmmg
//
//  Created by 王凯 on 2017/5/18.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#ifndef Api_h
#define Api_h


static NSString *KDL_DNS = @"http://118.190.102.153:4090/api";
static NSString *QINIU_URL = @"http://oq9k9uekk.bkt.clouddn.com/";

/**
 登陆注册模块
 */
static NSString *param_register = @"/auth/register";
static NSString *param_login = @"/auth/login";

/**
 好友模块
 */

static NSString *param_follow = @"/follow/follow";
static NSString *param_unfollow = @"/follow/unfollow";
static NSString *param_getFollowersList = @"/follow/getFollowing";

/**
 修改用户信息模块
 */
static NSString *param_changeName = @"/auth/changeName";
static NSString *param_changeMotto = @"/auth/changeMotto";
static NSString *param_getAvatarUploadInfo = @"/auth/getAvatarUploadInfo";
static NSString *param_changeAvatar = @"/auth//changeAvatar";


/**
 动态模块
 */
static NSString *param_getImageUploadInfo = @"/timeline/getImageUploadInfo";
static NSString *param_postTimeline = @"/timeline/postTimeline";
static NSString *param_getTimelines = @"/timeline/getTimelines";
static NSString *param_deleteTimeline = @"/timeline/deleteTimeline";
static NSString *param_postCommentTimeline = @"/timeline/comment";
static NSString *param_getDetailTimeline = @"/timeline/getTimelineById";
/**
 个人主页
 */
static NSString *param_getPersonalTimeline = @"/timeline/getByUser";
static NSString *param_getPersonInfo = @"/auth/getUserByAccount";
#endif /* Api_h */
