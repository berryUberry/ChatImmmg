//
//  LoginVC.m
//  ImgChat
//
//  Created by 王凯 on 2017/4/10.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import "LoginVC.h"
#import "LoginView.h"
#import "TabBarVC.h"
#import "UserInfo.h"

@interface LoginVC ()<RCIMUserInfoDataSource>
@property(nonatomic , strong)LoginView *loginView;
@property(nonatomic,strong)UserInfo *info;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    LoginView *loginView = [[LoginView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:loginView];
    self.loginView = loginView;
    [loginView.loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [loginView.labelButton addTarget:self action:@selector(labelAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loginAction{
    if([_loginView.loginButton.titleLabel.text  isEqual: @"登陆"]){
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSDictionary *params = @{@"account":[self.loginView.scrollView getLoginAccount],
                                 @"password":[self.loginView.scrollView getLoginPassword]
                                 
                                 };
        
        [[NetworkManager shareNetwork]loginWithParam:params successful:^(NSDictionary *responseObject) {
            NSLog(@"login%@",responseObject);
            if([responseObject objectForKey:@"error"]){
                [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"error"]];
            }else{
                
                NSDictionary *result = [responseObject objectForKey:@"result"];
                [[RCIM sharedRCIM] connectWithToken:[result objectForKey:@"token"]     success:^(NSString *userId) {
                    NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                    [[RCIM sharedRCIM] setUserInfoDataSource:self];
                    RCUserInfo *currentUser = [[RCUserInfo alloc]initWithUserId:userId name:[userDefault objectForKey:@"name"] portrait:[userDefault objectForKey:@"avatar"]];
                    [RCIMClient sharedRCIMClient].currentUserInfo = currentUser;
                } error:^(RCConnectErrorCode status) {
                    NSLog(@"登陆的错误码为:%ld", (long)status);
                } tokenIncorrect:^{
                    //token过期或者不正确。
                    //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                    //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                    NSLog(@"token错误");
                }];
                
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setObject:[[result objectForKey:@"user"] objectForKey:@"account"] forKey:@"account"];
                [userDefault setObject:[[result objectForKey:@"user"] objectForKey:@"name"] forKey:@"name"];
                [userDefault setObject:[[result objectForKey:@"user"] objectForKey:@"motto"] forKey:@"motto"];
                [userDefault setObject:[[result objectForKey:@"user"] objectForKey:@"avatar"] forKey:@"avatar"];
                [userDefault setObject:[result objectForKey:@"token"] forKey:@"token"];
                
                TabBarVC *tabbarVC = [[TabBarVC alloc]init];
                //[self.navigationController pushViewController:tabbarVC animated:YES];
                [self presentViewController:tabbarVC animated:YES completion:nil];

            }
            

        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"error"];

        }];
    }else{
        NSDictionary *params = @{@"account":[self.loginView.scrollView getRegisterAccount],
                                 @"password":[self.loginView.scrollView getRegisterPassword],
                                 @"name":[self.loginView.scrollView getRegisterName]
                                 };
        [[NetworkManager shareNetwork] registerWithParam:params successful:^(NSDictionary *responseObject) {
            NSLog(@"%@", responseObject);
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"error"];
        }];
    }
    
    
   
}

-(void)labelAction{
    CGRect frame = _loginView.scrollView.frame;
    if([_loginView.loginButton.titleLabel.text  isEqual: @"登陆"]){
        [_loginView.loginButton setTitle:@"注册" forState:normal];
        frame.origin.x = frame.size.width;
        frame.origin.y = 0;
        [_loginView.scrollView scrollRectToVisible:frame animated:YES];
        [_loginView.labelButton setTitle:@"已有账号？去登陆" forState:normal];
    }else{
        frame.origin.x = 0;
        frame.origin.y = 0;
        [_loginView.loginButton setTitle:@"登陆" forState:normal];
        [_loginView.scrollView scrollRectToVisible:frame animated:YES];
        [_loginView.labelButton setTitle:@"没有账号？去注册" forState:normal];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    NSString *paramUrl = [@"?account=" stringByAppendingString:userId];
    RCUserInfo *user = [[RCUserInfo alloc]init];
    WeakSelf
    [[NetworkManager shareNetwork]getPersonalInfoWithParam:nil paramsUrl:paramUrl successful:^(NSDictionary *responseObject) {
        NSLog(@"getuserinfo%@",responseObject);
        weakSelf.info = [UserInfo mj_objectWithKeyValues:[[responseObject objectForKey:@"result"] objectForKey:@"user"]];
        //        [userDefault setObject:weakSelf.info forKey:account];
        user.userId = userId;
        user.name = weakSelf.info.name;
        user.portraitUri = weakSelf.info.avatar;
        return completion(user);
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"error"];
    }];
}




@end
