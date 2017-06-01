//
//  ScrollView.h
//  ImgChat
//
//  Created by 王凯 on 2017/4/10.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollView : UIScrollView
@property(nonatomic,strong) UITextField *account;
@property(nonatomic,strong) UITextField *password;
@property(nonatomic,strong) UITextField *accountA;
@property(nonatomic,strong) UITextField *passwordA;
@property(nonatomic,strong) UITextField *username;
-(NSString *)getLoginAccount;
-(NSString *)getLoginPassword;
-(NSString *)getRegisterAccount;
-(NSString *)getRegisterPassword;
-(NSString *)getRegisterName;
@end
