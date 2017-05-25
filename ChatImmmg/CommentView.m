//
//  CommentView.m
//  ChatImmmg
//
//  Created by 王凯 on 2017/5/25.
//  Copyright © 2017年 berryberry. All rights reserved.
//

#import "CommentView.h"
@interface CommentView()
@property(nonatomic,strong) UILabel *label;
@property(nonatomic,strong) UIView *textFieldView;
@end
@implementation CommentView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
//    self.backgroundColor = [UIColor colorWithHexString:@"#DBDBDB"];
    //    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 14, 30, 20)];
    self.backgroundColor = [UIColor whiteColor];
    UILabel *label = [UILabel new];
    [self addSubview:label];
    label.font = [UIFont systemFontOfSize:13];
    label.text = @"留言";
    self.label = label;
    
    //    UIView *textFieldView = [[UIView alloc]initWithFrame:CGRectMake(45, 7, 320*V_S_W/375, 33)];
    UIView *textFieldView = [UIView new];
    [self addSubview:textFieldView];
    textFieldView.backgroundColor = [UIColor whiteColor];
    textFieldView.layer.masksToBounds = YES;
    textFieldView.layer.cornerRadius = 10;
    _textFieldView = textFieldView;
    //    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(52, 12, 310*V_S_W/375, 23)];
    //    [self addSubview:textField];
    //    textField.backgroundColor = [UIColor whiteColor];
    //    textField.placeholder = @"说点什么...";
    //    textField.returnKeyType = UIReturnKeySend;
    //    _commentField = textField;
    
    //    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(50, 10, 310*V_S_W/375, 23)];
    UITextView *textView = [UITextView new];
    [self.textFieldView addSubview:textView];
    textView.backgroundColor = [UIColor whiteColor];
    textView.returnKeyType = UIReturnKeySend;
    textView.font = [UIFont systemFontOfSize:12];
    _textView = textView;
    
    UILabel *placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 7, 200*self.frame.size.width/375, 20)];
    placeholderLabel.text = @"说点什么...";
    placeholderLabel.textColor = [UIColor lightGrayColor];
    placeholderLabel.backgroundColor = [UIColor clearColor];
    placeholderLabel.font = [UIFont systemFontOfSize:13];
    placeholderLabel.numberOfLines = 0;
    _placeholderLabel = placeholderLabel;
    [_textFieldView addSubview:placeholderLabel];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(self.frame.size.height/2 - 10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(30);
        
    }];
    
    [self.textFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(50);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top).offset(7);
        make.bottom.equalTo(self.mas_bottom).offset(-7);
        
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textFieldView.mas_left).offset(4);
        make.right.equalTo(self.textFieldView.mas_right).offset(-4);
        make.top.equalTo(self.textFieldView.mas_top).offset(1);
        make.bottom.equalTo(self.textFieldView.mas_bottom).offset(-5);
        
    }];
    
    
}


@end
