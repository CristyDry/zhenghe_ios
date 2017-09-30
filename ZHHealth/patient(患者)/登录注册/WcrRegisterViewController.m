//
//  WcrRegisterViewController.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/13.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WcrRegisterViewController.h"
#import "RegExpValidate.h"
#import <SMS_SDK/SMSSDK.h>
#import <MOBFoundation/MOBFoundation.h>
static int count = 0;

@interface WcrRegisterViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
// 验证码
@property (nonatomic,strong)  NSString *identifyingcode;

@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong) UITextField *passwTF;
@property (nonatomic, strong) UITextField *suggestTF;
@property (nonatomic,strong)  NSTimer *timer;
@property (nonatomic,strong)  UIButton *getCodeButton;

@end

@implementation WcrRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addLeftBackItem];
    
    [self setNavigationBarProperty];
    
    [self customRegisterUI];
    
}

-(void)customRegisterUI {
    
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectMake(0, KTopLayoutGuideHeight, kMainWidth, kMainHeight - KTopLayoutGuideHeight)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.opaque = YES;
    [self.view addSubview:scrollView];
    
    CGFloat xPoint = kBorder;
    CGFloat yPoint = 30;
    CGFloat width = kMainWidth - xPoint * 2;
    CGFloat height = 40;
    CGFloat offsetY = 15;
    
    _phoneTF = [self getOneTextFieldWithFrame:CGRectMake(xPoint, yPoint, width, height) andPlaceholder:@"请输入手机号码" andSuperView:scrollView];
    
    yPoint = _phoneTF.maxY_wcr + offsetY;
    width = AUTO_MATE_WIDTH(170);
    _codeTF = [self getOneTextFieldWithFrame:CGRectMake(xPoint, yPoint, width, height) andPlaceholder:@"请输入验证码" andSuperView:scrollView];
    
    // 获取验证码button
    xPoint =  _codeTF.maxX_wcr + 10;
    width = _phoneTF.maxX_wcr - xPoint;
    UIButton *getCodeButton = [[UIButton alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    _getCodeButton =getCodeButton;
    [getCodeButton buttonWithTitle:@"获取验证码" andTitleColor:[UIColor whiteColor] andBackgroundImageName:@"圆角矩形-1-拷贝-5" andFontSize:KFont - 4];
    [getCodeButton addTarget:self action:@selector(getRegsterCode)];
    [scrollView addSubview:getCodeButton];
    
    yPoint = _codeTF.maxY_wcr + offsetY;
    width = _phoneTF.width_wcr;
    xPoint = _phoneTF.x_wcr;
    _passwTF = [self getOneTextFieldWithFrame:CGRectMake(xPoint, yPoint, width, height) andPlaceholder:@"请设置密码" andSuperView:scrollView];
    
    yPoint = _passwTF.maxY_wcr + offsetY;
    _suggestTF = [self getOneTextFieldWithFrame:CGRectMake(xPoint, yPoint, width, height) andPlaceholder:@"推荐码" andSuperView:scrollView];
    
    // 注册按钮
    yPoint = _suggestTF.maxY_wcr + 40;
    UIButton *registerButton = [[UIButton alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    [registerButton buttonWithTitle:@"注册" andTitleColor:[UIColor whiteColor] andBackgroundImageName:@"圆角矩形-1-拷贝-5" andFontSize:KFont - 2];
    [registerButton addTarget:self action:@selector(registerAction)];
    [scrollView addSubview: registerButton];
    
}

-(UITextField*)getOneTextFieldWithFrame:(CGRect)frame andPlaceholder:(NSString*)placeholder andSuperView:(UIView*)superView{
    
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    textField.placeholder = placeholder;
    [textField textFieldWithPlaceholder:placeholder andFont:KFont - 4 andSecureTextEntry:NO andReturnKey:UIReturnKeyNext andkeyboardType:0];
    textField.background = [UIImage imageFileNamed:@"圆角矩形-1-拷贝" andType:YES];
    textField.delegate = self;
    if ([placeholder isEqualToString:@"请输入手机号码"]) {
        textField.keyboardType = UIKeyboardTypePhonePad;
    }else if ([placeholder isEqualToString:@"请设置密码"]) {
        textField.secureTextEntry = YES;
    }
    [superView addSubview:textField];
    return textField;
    
}

#pragma mark - 获取验证码
-(void)getRegsterCode {
    // 验证手机号码
    NSString *phoneNumber = self.phoneTF.text;
    if ([RegExpValidate validateMobile:phoneNumber]) {
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneTF.text
                                       zone:@"86"
                           customIdentifier:nil
                                     result:^(NSError *error)
         {
             
             if (!error)
             {
                 NSLog(@"验证码发送成功");
                 count = 0;
                 _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                            target:self
                                                          selector:@selector(updateTime)
                                                          userInfo:nil
                                                           repeats:YES];
             }
             
         }];

    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号有误" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alertView show];
    }
}
#pragma mark - 更新获取验证码时间
-(void)updateTime
{
    count++;
    if (count > 60)
    {
        [_timer invalidate];
        return;
    }
    //NSLog(@"更新时间");
    [_getCodeButton buttonWithTitle:[NSString stringWithFormat:@"%i s",60-count] andTitleColor:[UIColor whiteColor] andBackgroundImageName:@"圆角矩形-1-拷贝-5" andFontSize:KFont - 4];
    
    if ((60-count) == 0) {
        [_getCodeButton buttonWithTitle:@"获取验证码" andTitleColor:[UIColor whiteColor] andBackgroundImageName:@"圆角矩形-1-拷贝-5" andFontSize:KFont - 4];
        
    }
    
}
#pragma mark - 注册成功
-(void)registerAction {
    
    // 验证密码
    if ([RegExpValidate validatePassword:self.passwTF.text]) {
        [SMSSDK commitVerificationCode:self.codeTF.text phoneNumber:_phoneTF.text zone:@"86" result:^(NSError *error) {
            
            if (!error) {
                NSLog(@"验证成功");
                // 请求参数
                NSMutableDictionary *args = [NSMutableDictionary dictionary];
                args[@"phone"] = self.phoneTF.text;
                NSString *passwordTF = [iOSMD5 md5:self.passwTF.text];
                args[@"password"] = passwordTF;
                args[@"tokenName"] = kToken;
                
                // 发送请求
                [httpUtil doPostRequest:@"api/ZhenghePatient/patientRegister" args:args targetVC:self response:^(ResponseModel *responseMd) {
                    if (responseMd.isResultOk) {
                        // 请求成功
                        NSLog(@"注册成功——%@",responseMd);
                        // 请求成功后返回的数据：resultData = 0;
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注册完成，请前往登录。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alertView show];
                    }
                }];
                
            }else{
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                NSLog(@"错误信息:%@",error);
            }
        }];

    }
    
    
}
     
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
