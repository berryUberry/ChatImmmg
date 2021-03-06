//
//  MineVC.m
//  ChatImmmg
//
//  Created by 王凯 on 2017/5/21.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import "MineVC.h"
#import "HeadCell.h"
#import "MineBaseCell.h"
#import "ExitCell.h"
#import "ChangeVC.h"
#import "ChangeInfoVC.h"
#import "UserMainPageVC.h"
#import "FollowersVC.h"
#import "LoginVC.h"

static NSString *HeadCellIdentifier = @"HeadCellIdentifier";
static NSString *MineBaseCellIdentifier = @"MineBaseCellIdentifier";
static NSString *ExitCellIdentifier = @"ExitCellIdentifier";

@interface MineVC ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation MineVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.tableView.hidden = NO;
//    self.title = @"个人信息";
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置导航栏背景颜色
//    UIColor * color = [UIColor colorWithRed:46.0f / 255 green:139.0f / 255 blue:87.0f / 255 alpha:1];
    self.navigationController.navigationBar.barTintColor = MainColor;
    self.navigationController.navigationBar.translucent = NO;
    
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowColor = [UIColor colorWithWhite:0.871 alpha:1.000];
    shadow.shadowOffset = CGSizeMake(0.5, 0.5);
    
    //设置导航栏标题颜色
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18],NSShadowAttributeName:shadow};
    self.navigationController.navigationBar.titleTextAttributes = attributes;
    
    UITableView *tableView = [UITableView new];
    tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[HeadCell class] forCellReuseIdentifier:HeadCellIdentifier];
    [tableView registerClass:[MineBaseCell class] forCellReuseIdentifier:MineBaseCellIdentifier];
    [tableView registerClass:[ExitCell class] forCellReuseIdentifier:ExitCellIdentifier];
    tableView.tableFooterView = [UIView new];
    self.tableView = tableView;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tableView.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            return 80;
        }else if(indexPath.row == 3){
            return 100;
        }else{
            return 40;
        }
    }else{
        if(indexPath.row == 2){
            return 60;
        }
        return 40;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
         NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        if(indexPath.row == 0){
            [self changeHeadIcon];
        
        }
        else if(indexPath.row == 1){
//            ChangeVC *changeVC = [[ChangeVC alloc]init];
//            [self presentViewController:changeVC animated:YES completion:nil];
//            changeVC.type = @"name";
//            changeVC.text.text = [userdefault objectForKey:@"name"];
            ChangeInfoVC *changeInfoVC = [[ChangeInfoVC alloc]init];
            
            changeInfoVC.type = @"name";
            changeInfoVC.text.text = [userdefault objectForKey:@"name"];
            [self.navigationController pushViewController:changeInfoVC animated:YES];
        }else if(indexPath.row == 3){
//            ChangeVC *changeVC = [ChangeVC new];
//            [self presentViewController:changeVC animated:YES completion:nil];
//            changeVC.type = @"motto";
//            changeVC.text.text = [userdefault objectForKey:@"motto"];
            ChangeInfoVC *changeInfoVC = [ChangeInfoVC new];
            changeInfoVC.type = @"motto";
            [self.navigationController pushViewController:changeInfoVC animated:YES];
            changeInfoVC.text.text = [userdefault objectForKey:@"motto"];

        }
    }else{
        if(indexPath.row == 0){
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            UserMainPageVC *usermainpageVC = [UserMainPageVC new];
            usermainpageVC.account = [userDefault objectForKey:@"account"];
            [self.navigationController pushViewController:usermainpageVC animated:YES];
        }else if(indexPath.row == 1){
            FollowersVC *followersVC = [FollowersVC new];
            [self.navigationController pushViewController:followersVC animated:YES];
        }
        
    }

}
#pragma mark --UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 4;
    }else{
        return 3;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            HeadCell *cell = [[HeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HeadCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            if([userdefault objectForKey:@"avatar"]){
                [cell configModel:[userdefault objectForKey:@"avatar"]];
            }
            return cell;
        }else if(indexPath.row == 1){
            MineBaseCell *cell = [[MineBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MineBaseCellIdentifier];
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            [cell configModel:@"昵称" last:[userdefault objectForKey:@"name"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else if(indexPath.row == 2){
            MineBaseCell *cell = [[MineBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MineBaseCellIdentifier];
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            [cell configModel:@"账号" last:[userdefault objectForKey:@"account"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            MineBaseCell *cell = [[MineBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MineBaseCellIdentifier];
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            [cell configModel:@"个性签名" last:[userdefault objectForKey:@"motto"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        if(indexPath.row == 0){
            MineBaseCell *cell = [[MineBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MineBaseCellIdentifier];
            [cell configModel:@"个人主页" last:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if(indexPath.row == 1){
            MineBaseCell *cell = [[MineBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MineBaseCellIdentifier];
            [cell configModel:@"关注" last:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            ExitCell *cell = [[ExitCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ExitCellIdentifier];
            [cell.exitBtn addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

-(void)changeHeadIcon{
    /** 
     *  弹出提示框
     */
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //初始化UIImagePickerController
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
        //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        /**
         其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式
         */
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];

}

//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//    _myHeadPortrait.image = newPhoto;
    [self qiniuHttp:newPhoto];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)qiniuHttp:(UIImage *)icon{
    [SVProgressHUD show];
    [[NetworkManager shareNetwork]getQINiuUploadInfoWithParam:nil successful:^(NSDictionary *responseObject) {
        NSLog(@"getQINIUInfo%@",responseObject);
        if([responseObject objectForKey:@"error"]){
            [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"error"]];
        }else{
            NSDictionary *result = [responseObject objectForKey:@"result"];
            if(result){
                NSString *token = [result objectForKey:@"token"];
                
                BOOL isHttps = TRUE;
                QNZone * httpsZone = [[QNAutoZone alloc] initWithHttps:isHttps dns:nil];
                QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
                    builder.zone = httpsZone;
                }];
                QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
                NSData *data = UIImagePNGRepresentation(icon);
                
                WeakSelf
                [upManager putData:data key:[result objectForKey:@"key"] token:token
                          complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                              NSLog(@"qiniuinfo%@", info);
                              NSLog(@"qiniuresp%@", resp);
                              
                              if([resp objectForKey:@"key"]){
                                  [weakSelf changeAvatarHttp:[resp objectForKey:@"key"]];
                              }
                              
                              
                          } option:nil];
                
            }
        }
        
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"error"];
    }];


}

-(void)changeAvatarHttp:(NSString *)AvatarUrl{
    NSDictionary *params = @{@"key":AvatarUrl
                             };
    
    WeakSelf
    [[NetworkManager shareNetwork]changeAvatarWithParam:params successful:^(NSDictionary *responseObject) {
        NSLog(@"changeAvatar%@",responseObject);
        
        if([[responseObject objectForKey:@"error"] isEqual:@"token不能为空"]){
            [SVProgressHUD showErrorWithStatus:@"登陆信息失效！请重新登录!"];
            LoginVC *loginvc = [LoginVC new];
            [weakSelf presentViewController:loginvc animated:YES completion:nil];
        }
        
        [SVProgressHUD dismiss];
        if([responseObject objectForKey:@"error"]){
            [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"error"]];
        }else{
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:[[responseObject objectForKey:@"result"] objectForKey:@"avatar"] forKey:@"avatar"];
            [SVProgressHUD showSuccessWithStatus:@"更换成功！"];
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"error"];
    }];

}

-(void)exit{
    LoginVC *loginVC = [LoginVC new];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:nil forKey:@"account"];
    [userDefault setObject:nil forKey:@"name"];
    [userDefault setObject:nil forKey:@"motto"];
    [userDefault setObject:nil forKey:@"avatar"];
    [userDefault setObject:nil forKey:@"token"];
    [self presentViewController:loginVC animated:YES completion:nil];
}
@end
