//
//  ChangeVC.m
//  ChatImmmg
//
//  Created by 王凯 on 2017/5/21.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import "ChangeVC.h"




@interface ChangeVC()

@end

@implementation ChangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupView{
    
    UIButton *backBtn = [UIButton new];
    [backBtn setTitle:@"返回" forState: normal];
    [backBtn setTitleColor:[UIColor redColor] forState:normal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *publishBtn = [UIButton new];
    [publishBtn setTitle:@"发布" forState: normal];
    [publishBtn setTitleColor:[UIColor redColor] forState:normal];
    [publishBtn addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:publishBtn];
    
    UITextView *text = [UITextView new];
    self.text = text;
    text.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [text becomeFirstResponder];
    [self.view addSubview:text];
    
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(8);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    [publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.top.mas_equalTo(8);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.equalTo(backBtn.mas_bottom).offset(2);
        make.height.mas_equalTo(100);
    }];
    
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)publish{
    if([self.text.text isEqual:@""]){
        [SVProgressHUD showInfoWithStatus:@"不能为空"];
    }else{
        if([self.type isEqual:@"name"]){
            
            NSDictionary *param = @{@"name":self.text.text
                                    };
            [[NetworkManager shareNetwork]changeNameWithParam:param successful:^(NSDictionary *responseObject) {
                NSLog(@"changename%@",responseObject);
                if([responseObject objectForKey:@"error"]){
                    [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"error"]];
                }else{
                    
                    NSDictionary *result = [responseObject objectForKey:@"result"];
                    if(result){
                        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                        
                        [userDefault setObject:self.text.text forKey:@"name"];
                        
                        [SVProgressHUD showSuccessWithStatus:@"修改昵称成功！"];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                }
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"error"];
            }];
        }else{
            NSDictionary *param = @{@"motto":self.text.text
                                    };
            [[NetworkManager shareNetwork]changeMottoWithParam:param successful:^(NSDictionary *responseObject) {
                NSLog(@"changemotto%@",responseObject);
                if([responseObject objectForKey:@"error"]){
                    [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"error"]];
                }else{
                    
                    NSDictionary *result = [responseObject objectForKey:@"result"];
                    if(result){
                        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                        
                        [userDefault setObject:self.text.text forKey:@"motto"];
                        
                        [SVProgressHUD showSuccessWithStatus:@"修改个性签名成功！"];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                }
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"error"];
            }];
        }
    }
    
}



@end
