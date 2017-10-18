//
//  WcrReModifyPasController.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/13.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WcrReModifyPasController.h"

#import "LoginViewController.h"
#import "HLTLoginViewController.h"

@interface WcrReModifyPasController ()<UITextFieldDelegate,UIAlertViewDelegate>


@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UITextField *rePasswordTF;

@end

@implementation WcrReModifyPasController

//-(void)setPhoneNumber:(NSString *)phoneNumber{
//    _phoneNumber = phoneNumber;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self addLeftBackItem];
    
    [self setNavigationBarProperty];
    
    [self customReModifyPasswordUI];
    
    self.title = @"重置密码";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)customReModifyPasswordUI {
    
    CGFloat xPoint = kBorder;
    CGFloat yPoint = KTopLayoutGuideHeight + 30;
    CGFloat width = kMainWidth - kBorder * 2;
    CGFloat height = AUTO_MATE_HEIGHT(35);
    
    UITextField *passwordTF = [[UITextField alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    _passwordTF = passwordTF;
    passwordTF.delegate = self;
    [passwordTF textFieldWithPlaceholder:@"重置密码" andFont:KFont - 4 andSecureTextEntry:YES andReturnKey:UIReturnKeyNext andkeyboardType:0];
    passwordTF.font = [UIFont systemFontOfSize:KFont - 4];
    passwordTF.layer.cornerRadius = 5.0f;
    passwordTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    passwordTF.layer.borderWidth = 1.0f;
//    passwordTF.background = [UIImage imageFileNamed:@"圆角矩形-1-拷贝" andType:YES];
    [self.view addSubview:passwordTF];
    
    yPoint = passwordTF.maxY_wcr + 20;
    
    UITextField *rePasswTF = [[UITextField alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    _rePasswordTF = rePasswTF;
    rePasswTF.delegate = self;
    rePasswTF.font = [UIFont systemFontOfSize:KFont - 4];
    [rePasswTF textFieldWithPlaceholder:@"确认密码" andFont:KFont - 4 andSecureTextEntry:YES andReturnKey:UIReturnKeyDone andkeyboardType:0];
    rePasswTF.font = [UIFont systemFontOfSize:KFont - 4];
    rePasswTF.layer.cornerRadius = 5.0f;
    rePasswTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    rePasswTF.layer.borderWidth = 1.0f;
//    rePasswTF.background = [UIImage imageFileNamed:@"圆角矩形-1-拷贝" andType:YES];
    [self.view addSubview:rePasswTF];
    
    yPoint = rePasswTF.maxY_wcr + 40;
    
    UIButton *nextStepButton = [[UIButton alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    [nextStepButton buttonWithTitle:@"完成" andTitleColor:[UIColor whiteColor] andBackgroundImageName:@"圆角矩形-1-拷贝-5" andFontSize:KFont - 2];
    [nextStepButton addTarget:self action:@selector(rePasswordAction)];
    [self.view addSubview:nextStepButton];
    
}

#pragma mark - 修改密码
-(void)rePasswordAction {
    
    //患者端
    NSInteger userState = [CoreArchive intForKey:@"userState"];
    if (userState == kPatient)
    {
        [AppConfig saveLoginType:kPatient];
        // 参数
        NSMutableDictionary *args = [NSMutableDictionary dictionary];
        args[@"phone"] = _phoneNumber;
        args[@"userType"] = @"1";
        if ([_passwordTF.text isEqualToString:_rePasswordTF.text]) {
            NSString *passwordTF = [iOSMD5 md5:_rePasswordTF.text];
            NSLog(@"患者passwordTF=======%@",passwordTF);
            args[@"password"] = passwordTF;
            [httpUtil doPostRequest:@"api/ZhenghePatient/resetPwd" args:args targetVC:self response:^(ResponseModel *responseMd) {
                if (responseMd.isResultOk) {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"修改密码成功，请重新登录。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                }
            }];
        }
    }
    else
    {
        [AppConfig saveLoginType:kDoctor];
        // 参数
        NSMutableDictionary *args = [NSMutableDictionary dictionary];
        args[@"phone"] = _phoneNumber;
        args[@"userType"] = @"2";
        if ([_passwordTF.text isEqualToString:_rePasswordTF.text]) {
            NSString *passwordTF = [iOSMD5 md5:_rePasswordTF.text];
            NSLog(@"医生passwordTF=======%@",passwordTF);
            args[@"password"] = passwordTF;
            [httpUtil doPostRequest:@"api/ZhenghePatient/resetPwd" args:args targetVC:self response:^(ResponseModel *responseMd) {
                if (responseMd.isResultOk) {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"修改密码成功，请重新登录。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                }
            }];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSInteger userState = [CoreArchive intForKey:@"userState"];
    
    if (userState == kPatient)
    {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        loginVC.phoneNumber = _phoneNumber;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else
    {
        HLTLoginViewController * hltLogin = [[HLTLoginViewController alloc] init];
        hltLogin.phoneNumber = _phoneNumber;
        [self.navigationController pushViewController:hltLogin animated:YES];
    }
    
   
}

#pragma mark - textField Delegate
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_passwordTF resignFirstResponder];
    [_rePasswordTF resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _passwordTF) {
        [_rePasswordTF becomeFirstResponder];
    }else if (textField == _rePasswordTF) {
        [_rePasswordTF resignFirstResponder];
        // 跳转
        
    }
    
    return YES;
}


@end
