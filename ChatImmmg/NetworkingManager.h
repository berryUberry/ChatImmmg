//
//  NetworkingManager.h
//  ChatImmmg
//
//  Created by 王凯 on 2017/5/19.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^SuccessBlock)(NSDictionary *responseObject);
typedef void (^FailureBlock)(NSError *error);
typedef NS_ENUM(NSInteger,HttpRequestType) {
    HttpRequestTypeGet = 1,
    
    HttpRequestTypePost = 2
};

@interface NetworkingManager : NSObject

@property (nonatomic, copy) SuccessBlock successBlock;
@property (nonatomic, copy) FailureBlock failureBlock;

+(void)httpRequestWithType:(HttpRequestType)httpType
             WithURLString:(NSString *)urlString
                parameters:(NSDictionary *)parameters
                   success:(SuccessBlock)successBlock
                   failure:(FailureBlock)failureBlock;
@end
