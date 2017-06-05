//
//  NetworkManager.h
//  ChatImmmg
//
//  Created by 王凯 on 2017/5/18.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(NSDictionary *responseObject);
typedef void (^FailureBlock)(NSError *error);



@interface NetworkManager : NSObject
@property (nonatomic, copy) SuccessBlock successBlock;
@property (nonatomic, copy) FailureBlock failureBlock;

+(NetworkManager *)shareNetwork;




/**
 登陆注册
 */
-(void)registerWithParam:(NSDictionary *)params
              successful:(SuccessBlock)success
                 failure:(FailureBlock)failure;

-(void)loginWithParam:(NSDictionary *)params
           successful:(SuccessBlock)success
              failure:(FailureBlock)failure;

/**
 关注
 */
-(void)followWithParam:(NSDictionary *)params
              isfollow:(BOOL)isfollow
            successful:(SuccessBlock)success
               failure:(FailureBlock)failure;

-(void)getFollowersList:(NSDictionary *)params
              paramsUrl:(NSString *)paramsUrl
             successful:(SuccessBlock)success
                failure:(FailureBlock)failure;

/**
 修改用户信息
 */
-(void)changeNameWithParam:(NSDictionary *)params
                successful:(SuccessBlock)success
                   failure:(FailureBlock)failure;
-(void)changeMottoWithParam:(NSDictionary *)params
                 successful:(SuccessBlock)success
                    failure:(FailureBlock)failure;
-(void)getQINiuUploadInfoWithParam:(NSDictionary *)params
                        successful:(SuccessBlock)success
                           failure:(FailureBlock)failure;
-(void)changeAvatarWithParam:(NSDictionary *)params
                   successful:(SuccessBlock)success
                      failure:(FailureBlock)failure;

/**
 动态
 */
-(void)getImageUploadInfoWithParam:(NSDictionary *)params
                         paramsUrl:(NSString *)paramsUrl
                        successful:(SuccessBlock)success
                           failure:(FailureBlock)failure;
-(void)postTimelineWithParam:(NSDictionary *)params
                  successful:(SuccessBlock)success
                     failure:(FailureBlock)failure;
-(void)getTimelinesWithParam:(NSDictionary *)params
                   paramsUrl:(NSString *)paramsUrl
                  successful:(SuccessBlock)success
                     failure:(FailureBlock)failure;
-(void)deleteTimelineWithParam:(NSDictionary *)params
                    successful:(SuccessBlock)success
                       failure:(FailureBlock)failure;
-(void)commentTimelineWithParam:(NSDictionary *)params
                     successful:(SuccessBlock)success
                        failure:(FailureBlock)failure;
-(void)getDetailTimelineWithParam:(NSDictionary *)params
                        paramsUrl:(NSString *)paramsUrl
                       successful:(SuccessBlock)success
                          failure:(FailureBlock)failure;
-(void)thumbUpTimelineWithParam:(NSDictionary *)params
                     successful:(SuccessBlock)success
                        failure:(FailureBlock)failure;
-(void)deleteCommentWithParam:(NSDictionary *)params
                   successful:(SuccessBlock)success
                      failure:(FailureBlock)failure;

/**
 个人主页
 */
-(void)getPersonalTimelineWithParam:(NSDictionary *)params
                         successful:(SuccessBlock)success
                            failure:(FailureBlock)failure;
-(void)getPersonalInfoWithParam:(NSDictionary *)params
                     successful:(SuccessBlock)success
                        failure:(FailureBlock)failure;
@end
