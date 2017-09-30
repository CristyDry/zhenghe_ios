//
//  WCRAuthenticationController.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/17.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WCRAuthenticationController.h"

@interface WCRAuthenticationController ()

@property (nonatomic, strong) UITextView *contentTV;

@end

@implementation WCRAuthenticationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addLeftBackItem];
    
    [self setNavigationBarProperty];
    
    self.title = @"身份验证";
    
    [self customAuthenticationUI];
}

-(void)customAuthenticationUI {
    
    CGFloat xPoint = 5.0;
    CGFloat yPoint = KTopLayoutGuideHeight + 10.0;
    CGFloat width = kMainWidth - xPoint * 2;
    CGFloat height = AUTO_MATE_HEIGHT(100);
    
    UIButton *borderBtn = [[UIButton alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    [borderBtn setBorderOfButton];
    [borderBtn.layer setCornerRadius:0.1f];
    borderBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:borderBtn];
    
    xPoint = 10.0;
    yPoint = borderBtn.y_wcr + 10.0;
    height = borderBtn.height_wcr - 20.0;
    width = borderBtn.width_wcr - 20.0;
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    _contentTV = textView;
    textView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:textView];
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    [rightButton buttonWithTitle:@"发送" andTitleColor:[UIColor whiteColor] andBackgroundImageName:nil andFontSize:KFont - 2];
    [rightButton addTarget:self action:@selector(sendButtonAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}

-(void)sendButtonAction {
    NSLog(@"%@",_contentTV.text);
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    LoginResponseAccount *account = [LoginResponseAccount decode];
    args[@"doctorId"] = _doctorID;
    args[@"patientId"] = account.Id;
    args[@"verifyContent"] = _contentTV.text;
    [httpUtil doPostRequest:@"api/ZhengheDoctor/applyConsult" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"发送成功，请等待医生同意";
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:3];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_contentTV resignFirstResponder];
}

@end
