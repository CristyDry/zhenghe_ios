//
//  BZIdeaFeedBackController.m
//  ZHHealth
//
//  Created by pbz on 15/12/16.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZIdeaFeedBackController.h"
#import "LoginResponseAccount.h"
#import "LoginViewController.h"
#import "BaseTabBarController.h"
#import "MBProgressHUD.h"
@interface BZIdeaFeedBackController ()
@property (nonatomic,strong)  UITextView *contentView;
@property (nonatomic,strong)  UITextField *phoneView;
@end

@implementation BZIdeaFeedBackController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 左边返回按钮
    [self addLeftBackItem];
    self.navigationItem.title = @"意见反馈";
    // 右边的提交按钮
    [self setCommitBtn];
    // 设置内容视图
    [self setCustomUI];
    self.view.backgroundColor = kBackgroundColor;

}
// 设置内容视图
- (void)setCustomUI{
    // 内容框
    CGFloat marginV = 15;
    UITextView *contentView = [[UITextView alloc] initWithFrame:CGRectMake(marginV, 84, kMainWidth - marginV * 2, kMainWidth * 0.55)];
    contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    contentView.layer.borderWidth = 1;
    contentView.layer.cornerRadius = 5;
    contentView.font = [UIFont systemFontOfSize:15];
    contentView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:contentView];
    _contentView =contentView;
    // 电话号码框
    UITextField *phoneView = [[UITextField alloc] initWithFrame:CGRectMake(marginV, CGRectGetMaxY(contentView.frame) + 5, kMainWidth - marginV * 2, kMainWidth * 0.1)];
    phoneView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    phoneView.layer.borderWidth = 1;
    phoneView.layer.cornerRadius = 5;
    phoneView.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneView.keyboardType = UIKeyboardTypeNumberPad;
    phoneView.placeholder = @"手机号(选填)";
    [self.view addSubview:phoneView];
    _phoneView = phoneView;
}
// 右边的提交按钮
-(void)setCommitBtn {
    UIButton *commitBtn = [[UIButton alloc] init];
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitBtn.width_wcr = 40;
    commitBtn.height_wcr = 30;
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [commitBtn addTarget:self action:@selector(commitAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:commitBtn];
}
// 提交
- (void)commitAction{
    
    // 判断是否已登录
    if ([LoginResponseAccount isLogin]) {
         // 已经登录
        // 判断是医生还是患者
        NSInteger userState = [CoreArchive intForKey:@"userState"];
        if (userState == kPatient) {
            // 患者
            [self commict:@"1"];
        }else if (userState == kDoctor){
            // 医生
            [self commict:@"2"];
        }
        
    }else{
        // 未登录，跳转到登录界面
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}
- (void)commict:(NSString *) userType{
    // 取出用户id
    LoginResponseAccount *account = [LoginResponseAccount decode];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"userId"] = account.Id;
    args[@"content"] = _contentView.text;
    args[@"userType"] = userType;
    if (_contentView.text.length) {
        // 验证手机号码
        if ((_phoneView.text.length == 0) || [RegExpValidate validateMobile:_phoneView.text]) {
            args[@"phone"] = _phoneView.text;
            [httpUtil doPostRequest:@"api/medicalApiController/addIdea" args:args targetVC:self response:^(ResponseModel *responseMd) {
                if (responseMd.isResultOk) {
                    // 提示提交成功
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"提交成功";
                    hud.margin = 10.f;
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:1];
                    // 1秒后跳转控制器
                    BaseTabBarController *baseTabBarVC = [BaseTabBarController sharedTabBarController];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    baseTabBarVC.selectedIndex = 3;
                    
                }
            }];
        }else{
            // 提示输入正确的手机号码
            UIAlertController *Alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确的手机号码" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [Alert addAction:sureBtn];
            [self presentViewController:Alert animated:YES completion:^{
            }];
        }
        
    }else{
        // 提示输入内容不能为空
        UIAlertController *Alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"提交的内容不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [Alert addAction:sureBtn];
        [self presentViewController:Alert animated:YES completion:^{
        }];
    }
}





@end
