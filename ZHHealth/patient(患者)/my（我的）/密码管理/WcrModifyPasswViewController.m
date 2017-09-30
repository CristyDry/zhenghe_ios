//
//  WcrModifyPasswViewController.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/13.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WcrModifyPasswViewController.h"

#import "WcrReModifyPasController.h"

#import <SMS_SDK/SMSSDK.h>
#import <MOBFoundation/MOBFoundation.h>


static int count = 0;
@interface WcrModifyPasswViewController ()<UITextFieldDelegate>
/*  验证码  */
@property (nonatomic,strong)  NSString *identifyingcode;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong)  NSTimer* timer1;
@property (nonatomic, strong)  NSTimer* timer2;
@property (nonatomic, strong) UIButton *getCodeButton;


@end

@implementation WcrModifyPasswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftBackItem];
    
    [self setNavigationBarProperty];
    
    [self customModifyPasswordUI];
    
    self.title = @"重置密码";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)customModifyPasswordUI {
    
    CGFloat xPoint = kBorder;
    CGFloat yPoint = KTopLayoutGuideHeight + 30;
    CGFloat width = kMainWidth - kBorder * 2;
    CGFloat height = 40;
    
    UITextField *phoneTF = [[UITextField alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    _phoneTF = phoneTF;
    phoneTF.delegate = self;
    [phoneTF textFieldWithPlaceholder:@"请输入手机号" andFont:KFont - 4 andSecureTextEntry:NO andReturnKey:UIReturnKeyNext andkeyboardType:UIKeyboardTypePhonePad];
    phoneTF.font = [UIFont systemFontOfSize:KFont - 4];
    phoneTF.background = [UIImage imageFileNamed:@"圆角矩形-1-拷贝" andType:YES];
    [self.view addSubview:phoneTF];
    
    yPoint = phoneTF.maxY_wcr + 20;
    width = AUTO_MATE_WIDTH(170);
    
    UITextField *codeTF = [[UITextField alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    _codeTF = codeTF;
    codeTF.delegate = self;
    codeTF.font = [UIFont systemFontOfSize:KFont - 4];
    [codeTF textFieldWithPlaceholder:@"请入验证码" andFont:KFont - 4 andSecureTextEntry:NO andReturnKey:UIReturnKeyDone andkeyboardType:0];
    codeTF.background = [UIImage imageFileNamed:@"圆角矩形-1-拷贝" andType:YES];
    [self.view addSubview:codeTF];
    
    xPoint = codeTF.maxX_wcr + 10;
    width = phoneTF.width_wcr - codeTF.width_wcr - 10;
    
    _getCodeButton = [[UIButton alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    [_getCodeButton buttonWithTitle:@"获取验证码" andTitleColor:[UIColor whiteColor] andBackgroundImageName:@"圆角矩形-1-拷贝-5" andFontSize:KFont - 4];
    [_getCodeButton addTarget:self action:@selector(passwordButtonAction:)];
    _getCodeButton.tag = 1113;
    [self.view addSubview:_getCodeButton];
    
    xPoint = phoneTF.x_wcr;
    yPoint = codeTF.maxY_wcr + 40;
    width = phoneTF.width_wcr;
    
    UIButton *nextStepButton = [[UIButton alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    [nextStepButton buttonWithTitle:@"下一步" andTitleColor:[UIColor whiteColor] andBackgroundImageName:@"圆角矩形-1-拷贝-5" andFontSize:KFont - 2];
    [nextStepButton addTarget:self action:@selector(passwordButtonAction:)];
    nextStepButton.tag = 1114;
    [self.view addSubview:nextStepButton];
    
}
/*   点击获取验证码   */

-(void)passwordButtonAction:(UIButton*)button {
    
    if (button.tag == 1113) {
        
        if (_phoneTF.text.length==0) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"号码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        // 验证手机号
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
                     _timer2 = [NSTimer scheduledTimerWithTimeInterval:1
                                                                        target:self
                                                                      selector:@selector(updateTime)
                                                                      userInfo:nil
                                                                       repeats:YES];
                 }else{
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号有误" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                     [alertView show];
                 }
                 
             }];
        }
        
    }else if (button.tag == 1114) {
        // 下一步
        [SMSSDK commitVerificationCode:self.codeTF.text phoneNumber:_phoneTF.text zone:@"86" result:^(NSError *error) {
            
            if (!error) {
                NSLog(@"验证成功");
                WcrReModifyPasController *rePassModifyVC = [[WcrReModifyPasController alloc]init];
                rePassModifyVC.titleString = self.titleString;
                rePassModifyVC.phoneNumber = _phoneTF.text;
                [self.navigationController pushViewController:rePassModifyVC animated:YES];
            }
            else
            {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                NSLog(@"错误信息:%@",error);
            }
        }];
        
        
    }
    
}


#pragma mark - 更新获取验证码时间
-(void)updateTime
{
    count++;
    if (count > 60)
    {
        [_timer2 invalidate];
        return;
    }
    //NSLog(@"更新时间");
    [_getCodeButton buttonWithTitle:[NSString stringWithFormat:@"%i s",60-count] andTitleColor:[UIColor whiteColor] andBackgroundImageName:@"圆角矩形-1-拷贝-5" andFontSize:KFont - 4];
    
    if ((60-count) == 0) {
       [_getCodeButton buttonWithTitle:@"获取验证码" andTitleColor:[UIColor whiteColor] andBackgroundImageName:@"圆角矩形-1-拷贝-5" andFontSize:KFont - 4];
        [_getCodeButton addTarget:self action:@selector(passwordButtonAction:)];
        _getCodeButton.tag = 1113;
    }

}

#pragma mark - textField Delegate
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_phoneTF resignFirstResponder];
    [_codeTF resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _phoneTF) {
        [_codeTF becomeFirstResponder];
    }else if (textField == _codeTF) {
        [_codeTF resignFirstResponder];
        // 跳转
    }
    
    return YES;
}

@end
