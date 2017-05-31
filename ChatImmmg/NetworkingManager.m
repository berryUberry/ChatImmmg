//
//  NetworkingManager.m
//  ChatImmmg
//
//  Created by 王凯 on 2017/5/19.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import "NetworkingManager.h"

@implementation NetworkingManager


+ (void)httpRequestWithType:(HttpRequestType)httpType
              WithURLString:(NSString *)urlString
                 parameters:(NSDictionary *)parameters
                    success:(SuccessBlock)successBlock
                    failure:(FailureBlock)failureBlock{
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    
    // 启动系统风火轮
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if([userdefault objectForKey:@"token"]){
        [manager.requestSerializer setValue:[userdefault objectForKey:@"token"] forHTTPHeaderField:@"authorization"];
    }
    
    NSString *url = [KDL_DNS stringByAppendingString:urlString];
    
    switch (httpType) {
        case HttpRequestTypeGet:
        {
            //以get的形式提交，只需要将上面的请求地址给GET做参数就可以
            [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
            
            [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
