//
//  NetworkManager.m
//  ChatImmmg
//
//  Created by 王凯 on 2017/5/18.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import "NetworkManager.h"

static NetworkManager *shareManager = nil;
@implementation NetworkManager
+(NetworkManager *)shareNetwork{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[self alloc]init];
    });

    return shareManager;
}



/**
 登陆注册
 */
-(void)registerWithParam:(NSDictionary *)params successful:(SuccessBlock)success failure:(FailureBlock)failure{
    [NetworkingManager httpRequestWithType:HttpRequestTypePost WithURLString:param_register parameters:params success:^(NSDictionary *responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure){
            failure(error);
        }
    }];
    
    

}

-(void)loginWithParam:(NSDictionary *)params successful:(SuccessBlock)success failure:(FailureBlock)failure{
    [NetworkingManager httpRequestWithType:HttpRequestTypePost WithURLString:param_login parameters:params success:^(NSDictionary *responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure){
            failure(error);
        }
    }];
}


/**
 关注
 */
-(void)followWithParam:(NSDictionary *)params isfollow:(NSString *)isfollow successful:(SuccessBlock)success failure:(FailureBlock)failure{
    [NetworkingManager httpRequestWithType:HttpRequestTypePost WithURLString:param_follow parameters:params success:^(NSDictionary *responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];

}

-(void)getFollowersList:(NSDictionary *)params paramsUrl:(NSString *)paramsUrl successful:(SuccessBlock)success failure:(FailureBlock)failure{
    NSString *urlString = [param_getFollowersList stringByAppendingString:paramsUrl];
    [NetworkingManager httpRequestWithType:HttpRequestTypeGet WithURLString:urlString parameters:params success:^(NSDictionary *responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


/**
 修改用户信息
 */
-(void)changeNameWithParam:(NSDictionary *)params successful:(SuccessBlock)success failure:(FailureBlock)failure{
    [NetworkingManager httpRequestWithType:HttpRequestTypePost WithURLString:param_changeName parameters:params success:^(NSDictionary *responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

-(void)changeMottoWithParam:(NSDictionary *)params successful:(SuccessBlock)success failure:(FailureBlock)failure{
    [NetworkingManager httpRequestWithType:HttpRequestTypePost WithURLString:param_changeMotto parameters:params success:^(NSDictionary *responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

-(void)getQINiuUploadInfoWithParam:(NSDictionary *)params successful:(SuccessBlock)success failure:(FailureBlock)failure{
    [NetworkingManager httpRequestWithType:HttpRequestTypeGet WithURLString:param_getAvatarUploadInfo parameters:params success:^(NSDictionary *responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];

}

-(void)changeAvatarWithParam:(NSDictionary *)params successful:(SuccessBlock)success failure:(FailureBlock)failure{
    [NetworkingManager httpRequestWithType:HttpRequestTypePost WithURLString:param_changeAvatar parameters:params success:^(NSDictionary *responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/**
 动态
 */
-(void)getImageUploadInfoWithParam:(NSDictionary *)params paramsUrl:(NSString *)paramsUrl successful:(SuccessBlock)success failure:(FailureBlock)failure{
    NSString *urlString = [param_getImageUploadInfo stringByAppendingString:paramsUrl];
    [NetworkingManager httpRequestWithType:HttpRequestTypeGet WithURLString:urlString parameters:params success:^(NSDictionary *responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

-(void)postTimelineWithParam:(NSDictionary *)params successful:(SuccessBlock)success failure:(FailureBlock)failure{
    [NetworkingManager httpRequestWithType:HttpRequestTypePost WithURLString:param_postTimeline parameters:params success:^(NSDictionary *responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];

}

-(void)getTimelinesWithParam:(NSDictionary *)params paramsUrl:(NSString *)paramsUrl successful:(SuccessBlock)success failure:(FailureBlock)failure{
    NSString *urlString = [param_getTimelines stringByAppendingString:paramsUrl];
    [NetworkingManager httpRequestWithType:HttpRequestTypeGet WithURLString:urlString parameters:params success:^(NSDictionary *responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

-(void)deleteTimelineWithParam:(NSDictionary *)params successful:(SuccessBlock)success failure:(FailureBlock)failure{
    [NetworkingManager httpRequestWithType:HttpRequestTypePost WithURLString:param_deleteTimeline parameters:params success:^(NSDictionary *responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

-(void)commentTimelineWithParam:(NSDictionary *)params successful:(SuccessBlock)success failure:(FailureBlock)failure{
    [NetworkingManager httpRequestWithType:HttpRequestTypePost WithURLString:param_postCommentTimeline parameters:params success:^(NSDictionary *responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];

}

-(void)getDetailTimelineWithParam:(NSDictionary *)params paramsUrl:(NSString *)paramsUrl successful:(SuccessBlock)success failure:(FailureBlock)failure{
    
    NSString *urlString = [param_getDetailTimeline stringByAppendingString:paramsUrl];
    [NetworkingManager httpRequestWithType:HttpRequestTypeGet WithURLString:urlString parameters:params success:^(NSDictionary *responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];

}

/**
 个人主页
 */

-(void)getPersonalTimelineWithParam:(NSDictionary *)params paramsUrl:(NSString *)paramsUrl successful:(SuccessBlock)success failure:(FailureBlock)failure{
    NSString *urlString = [param_getPersonalTimeline stringByAppendingString:paramsUrl];
    [NetworkingManager httpRequestWithType:HttpRequestTypeGet WithURLString:urlString parameters:params success:^(NSDictionary *responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

-(void)getPersonalInfoWithParam:(NSDictionary *)params paramsUrl:(NSString *)paramsUrl successful:(SuccessBlock)success failure:(FailureBlock)failure{
    NSString *urlString = [param_getPersonInfo stringByAppendingString:paramsUrl];
    [NetworkingManager httpRequestWithType:HttpRequestTypeGet WithURLString:urlString parameters:params success:^(NSDictionary *responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/**
 BaseHttp
 */
+ (void)GetOrPostWithHttpType:(HttpRequestType)httpType
                  WithURLString:(NSString *)urlString
                     parameters:(NSDictionary *)parameters
                        success:(SuccessBlock)successBlock
                        failure:(FailureBlock)failureBlock{
    NSString *httpURL = [KDL_DNS stringByAppendingString:urlString];
    
    [self httpRequestWithType:httpType WithURLString:httpURL parameters:parameters success:successBlock failure:failureBlock];
}

+ (void)httpRequestWithType:(HttpRequestType)httpType
              WithURLString:(NSString *)urlString
                 parameters:(NSDictionary *)parameters
                    success:(SuccessBlock)successBlock
                    failure:(FailureBlock)failureBlock{

//    Reachability *reachability = [Reachability reachabilityForInternetConnection];
//    if (reachability) {
//        [SVProgressHUD showInfoWithStatus:@"亲，您的网络飞走啦～"];
//    }
    
    // 启动系统风火轮
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    
    switch (httpType) {
        case HttpRequestTypeGet:
        {
            //以get的形式提交，只需要将上面的请求地址给GET做参数就可以
            [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                // 隐藏系统风火轮
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                //json解析
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                successBlock(resultDic);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                // 解析失败隐藏系统风火轮(可以打印error.userInfo查看错误信息)
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                if (failureBlock) {
                    failureBlock(error);
                    NSLog(@"网络异常 - T_T%@", error);
                    NSLog(@"%@%@%ld",error.userInfo,error.domain,error.code);
                }

            }];
        }
            break;
        default:
        {
            //以post的形式提交，POST的参数就是上面的域名，parameters的参数是一个字典类型，将上面的字典作为它的参数
            
            [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                // 隐藏系统风火轮
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                //json解析
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                successBlock(resultDic);
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                // 解析失败隐藏系统风火轮(可以打印error.userInfo查看错误信息)
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                if (failureBlock) {
                    failureBlock(error);
                    NSLog(@"网络异常 - T_T%@", error);
                    NSLog(@"%@%@%ld",error.userInfo,error.domain,error.code);
                }
                
            }];
        }
            break;
    }
}

@end
