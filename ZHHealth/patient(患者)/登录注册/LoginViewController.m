//
//  LoginViewController.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/13.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "LoginViewController.h"
#import "WcrRegisterViewController.h"
#import "HLTLoginViewController.h"
#import "MedicineViewController.h"
#import "InquiryViewController.h"
#import "KnowledgeViewController.h"
#import "MyViewController.h"
#import "BZChannelListModel.h"
#import "WcrModifyPasswViewController.h"
#import "LoginResponseAccount.h"
#import "MJExtension.h"
#import "RongYunTools.h"
#import "HUD.h"
#import <ShareSDK/ShareSDK.h>

@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)  LoginResponseAccount *loginAccount;
@property (nonatomic,strong)  NSArray *channelListModelA;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"用户登录";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setNavigationBarProperty];
    
    [self addLeftAndRightButton];
    
    [self customLoginUI];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
  _phoneTF.text = _phoneNumber;
}
#pragma mark - 导航栏左右按钮
-(void)addLeftAndRightButton {
    // KFont - 3
    UIButton *leftButton = [self getButtonWithButtonTitle:@"取消" andWith:40 andTag:308];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    //UIButton *rightButton = [self getButtonWithButtonTitle:@"快速注册" andWith:70 andTag:309];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
}

-(UIButton*)getButtonWithButtonTitle:(NSString*)buttonTitle andWith:(CGFloat)width andTag:(int)buttonTag {
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
    [button buttonWithTitle:buttonTitle andTitleColor:[UIColor whiteColor] andBackgroundImageName:nil andFontSize:KFont - 3];
    button.tag = buttonTag;
    [button addTarget:self action:@selector(LeftAndRightAction:)];
    return button;
    
}
-(void)LeftAndRightAction:(UIButton*)button {
    if (button.tag == 308) {
        [self skipToHomePage];
        
    }else if (button.tag == 309) {
        // 快速注册
        WcrRegisterViewController *registerVC = [[WcrRegisterViewController alloc]init];
        [self.navigationController pushViewController:registerVC animated:YES];
        
    }
    
}

-(void)skipToHomePage {
    // 取消登录
    UIFont *fontSize = [UIFont systemFontOfSize:KFont - 7];
    
    // 患者
    NSArray *norArray = @[@"图层-8",@"图层-9",@"iconfont-zhishiku",@"shape-23"];
    NSArray *selArray = @[@"形状-3",@"形状-8",@"形状-12",@"shape-232"];
    NSArray *titles = @[@"首页",@"咨询",@"知识",@"我的"];
    NSArray *classNames = @[@"MedicineViewController",@"InquiryViewController",@"KnowledgeViewController",@"MyViewController"];
    NSMutableArray *vcArray = [NSMutableArray array];
    
    for (int i = 0; i < classNames.count; i++) {
        UIViewController *vc = [[NSClassFromString(classNames[i]) alloc]init];
        
        vc.tabBarItem.image = [[UIImage imageFileNamed:norArray[i] andType:YES] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage = [[UIImage imageFileNamed:selArray[i] andType:YES] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        vc.tabBarItem.title = titles[i];
        
        [vc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fontSize,NSFontAttributeName,nil] forState:UIControlStateNormal];
        
        UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
        
        [vc setNavigationBarProperty];
        vc.navigationItem.title = titles[i];
        
        [vcArray addObject:navc];
    }
    
    UITabBarController *tabBarVC = [[UITabBarController alloc]init];
//    BaseTabBarController *tabBarVC = [BaseTabBarController sharedTabBarController];
    //设置整个tabBar的每个item选中时的颜色
    tabBarVC.tabBar.tintColor = [UIColor colorWithHexString:@"#05b7c3"];
    
    UIImage *tabBarImage = [UIImage imageFileNamed:@"底部栏" andType:YES];
    tabBarVC.tabBar.barTintColor = [UIColor colorWithPatternImage:tabBarImage];
    
    tabBarVC.viewControllers = vcArray;
     tabBarVC.selectedIndex = 0;
    [self presentViewController:tabBarVC animated:YES completion:nil];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    self.tabBarController.selectedIndex = 0;
   

}

#pragma mark - 自定义视图
-(void)customLoginUI {
    CGFloat xPoint = kBorder;
    CGFloat yPoint = 30.0f + KTopLayoutGuideHeight;
    CGFloat width = kMainWidth - kBorder * 2;
    CGFloat height = 40;
    
    UITextField *phoneTF = [[UITextField alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    _phoneTF = phoneTF;
    [phoneTF textFieldWithPlaceholder:@"请输入手机号" andFont:KFont - 4 andSecureTextEntry:NO andReturnKey:UIReturnKeyNext andkeyboardType:UIKeyboardTypePhonePad];
    phoneTF.delegate = self;
    phoneTF.layer.cornerRadius = 5.0f;
    phoneTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    phoneTF.layer.borderWidth = 1.0f;
//    phoneTF.background = [UIImage imageFileNamed:@"圆角矩形-1-拷贝" andType:YES];
    [self.view addSubview:phoneTF];
    
    yPoint = phoneTF.maxY_wcr + 15;
    UITextField *passwordTF = [[UITextField alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    _passwordTF = passwordTF;
    [passwordTF textFieldWithPlaceholder:@"请输入密码" andFont:KFont - 4 andSecureTextEntry:YES andReturnKey:UIReturnKeyDone andkeyboardType:0];
    passwordTF.delegate = self;
    passwordTF.layer.cornerRadius = 5.0f;
    passwordTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    passwordTF.layer.borderWidth = 1.0f;

//    passwordTF.background = [UIImage imageFileNamed:@"圆角矩形-1-拷贝" andType:YES];
    [self.view addSubview:passwordTF];
    
    yPoint = passwordTF.maxY_wcr + 35;
    UIButton *loginButton = [[UIButton alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    [loginButton buttonWithTitle:@"登录" andTitleColor:[UIColor whiteColor] andBackgroundImageName:@"圆角矩形-1-拷贝-5" andFontSize:KFont - 2];
    [loginButton addTarget:self action:@selector(loginButtonAction)];
    [self.view addSubview:loginButton];
    
    // 忘记密码
    width = 80;
    xPoint = loginButton.maxX_wcr - width;
    yPoint = loginButton.maxY_wcr + 8;
    height = 20;
    UIButton *forgetButton = [[UIButton alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    [forgetButton buttonWithTitle:@"忘记密码？" andTitleColor:[UIColor colorWithHexString:@"#999999"] andBackgroundImageName:nil andFontSize:KFont - 5];
    forgetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgetButton addTarget:self action:@selector(forgetButtonAction)];
    [self.view addSubview:forgetButton];
    
    // 使用第三方登录
    yPoint = loginButton.maxY_wcr + AUTO_MATE_HEIGHT(70);
    width = 140.0f;
    xPoint = kMainWidth / 2.0 - width / 2.0;
    height = 20;
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, 20)];
    [lable labelWithText:@"使用其他方式登录" andTextColor:kBlackColor andFontSize:KFont - 4 andBackgroundColor:kBackgroundColor];
    lable.textAlignment = NSTextAlignmentCenter;
    
    yPoint = yPoint + height / 2.0 - 1;
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(phoneTF.x_wcr, yPoint, phoneTF.width_wcr, 1)];
    line.backgroundColor = [UIColor colorWithRGB:199 G:199 B:199];
    [self.view addSubview:line];
    [self.view addSubview:lable];
    
    // 设置第三方登录按钮
    // QQ
    width = 90.0f;
    height = width;
    xPoint = (kMainWidth - width) / 2.0;
    yPoint = lable.maxY_wcr + 5;
    [self setThirdLoginButtonWithImageName:@"qq" andRect:CGRectMake(xPoint, yPoint, width, height) andButtonTag:413];
    
    CGFloat offset = 20.0;
    CGFloat qqX = xPoint;
    xPoint = qqX - offset - width;
    [self setThirdLoginButtonWithImageName:@"微信" andRect:CGRectMake(xPoint, yPoint, width, height) andButtonTag:414];
    
    xPoint = qqX + offset + width;
//    [self setThirdLoginButtonWithImageName:@"微博" andRect:CGRectMake(xPoint, yPoint, width, height) andButtonTag:415];
    
    height = 49;
    yPoint = kMainHeight - height;
    if([kUserDefaults boolForKey:@"viewAll"] || [kUserDefaults boolForKey:@"viewDoc"]){
        // 切换为医生版按钮
        UIButton *changedButton = [[UIButton alloc]initWithFrame:CGRectMake(0, yPoint, kMainWidth, height)];
        [changedButton buttonWithTitle:@"切换到专家版" andTitleColor:[UIColor whiteColor] andBackgroundImageName:nil andFontSize:KFont - 2];
        changedButton.backgroundColor = [UIColor colorWithHexString:@"#05b7c3"];
        [changedButton addTarget:self action:@selector(changedButtonAction)];
        [self.view addSubview:changedButton];
    }
    
}
-(void)setThirdLoginButtonWithImageName:(NSString*)imageName andRect:(CGRect)ButotnFrame andButtonTag:(int)buttonTag {
    
    UIButton *button = [[UIButton alloc]initWithFrame:ButotnFrame];
    [button setImage:[UIImage imageFileNamed:imageName andType:YES] forState:0];
    button.tag = buttonTag;
    [button.layer setCornerRadius:ButotnFrame.size.width / 2.0];
    button.clipsToBounds = YES;
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(thirdLoginAction:)];
    [self.view addSubview:button];
}

#pragma mark - 第三方登录
-(void)thirdLoginAction:(UIButton*)button {
    if (button.tag == 413) {
        // QQ
        NSLog(@"QQ");
        //免登录
        [ShareSDK authorize:SSDKPlatformTypeQQ settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
            
        }];
//        BOOL isAuthorized = [ShareSDK hasAuthorized:SSDKPlatformTypeQQ];
        
        [ShareSDK getUserInfo:SSDKPlatformTypeQQ
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
         {
             if (state == SSDKResponseStateSuccess)
             {
                 NSLog(@"QQuser=============%@",user);//头像figureurl_qq_2  性别gender 昵称nickname
                 NSMutableDictionary * args = [NSMutableDictionary dictionary];
                 args[@"id"] = user.uid;
                 args[@"other"] = kToken;
                 args[@"patientName"]=user.nickname;
                 args[@"avatar"]=user.icon;
                 NSLog(@"user.icon========%@",user.icon);
                 NSLog(@"QQuser.uid==========%@",user.uid);
                 [httpUtil doPostRequest:@"api/ZhengheDoctor/Oauth" args:args targetVC:self response:^(ResponseModel *responseMd) {
                     if (responseMd.isResultOk) {
                         // 将返回的账号字典数据 --> 模型
                         LoginResponseAccount *account = [LoginResponseAccount mj_objectWithKeyValues:responseMd.response];
                         // 归档进沙盒
                         [LoginResponseAccount encode:account];
                         [RongYunHttp loadRongYunTokenType:@"1" userId:account.Id completion:nil];
                         [self skipToHomePage];
                     }
                     
                 }];
                 
             }else
             {
                 NSLog(@"%@",error);
             }
             
         }];
        
    }else if (button.tag == 414) {
        // 微信
        NSLog(@"微信");
       
        [ShareSDK getUserInfo:SSDKPlatformTypeWechat
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
         {
             if (state == SSDKResponseStateSuccess)
             {
                 NSLog(@"weixinuser=============%@",user);
                 NSMutableDictionary * args = [NSMutableDictionary dictionary];
                 args[@"id"] = user.uid;
                 args[@"other"] = kToken;
                 args[@"patientName"]=user.nickname;
                 args[@"avatar"]=user.icon;
                 NSLog(@"weixinuser.uid==========%@",user.uid);
                 [httpUtil doPostRequest:@"api/ZhengheDoctor/Oauth" args:args targetVC:self response:^(ResponseModel *responseMd) {
                     if (responseMd.isResultOk) {
                         // 将返回的账号字典数据 --> 模型
                         LoginResponseAccount *account = [LoginResponseAccount mj_objectWithKeyValues:responseMd.response];
                         // 归档进沙盒
                         [LoginResponseAccount encode:account];
                         [RongYunHttp loadRongYunTokenType:@"1" userId:account.Id completion:nil];
                         [self skipToHomePage];
                     }
                     
                 }];
             }else
             {
                 NSLog(@"%@",error);
             }
             
         }];
        
    }else if (button.tag == 415) {
        // 微博
        NSLog(@"微博");
    
        [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
         {
             if (state == SSDKResponseStateSuccess)
             {
                 NSLog(@"weibouser=============%@",user);
                 NSMutableDictionary * args = [NSMutableDictionary dictionary];
                 args[@"id"] = user.uid;
                 args[@"other"] = kToken;
                 args[@"patientName"]=user.nickname;
                 args[@"avatar"]=user.icon;
                 NSLog(@"weibouser.uid==========%@",user.uid);
                 [httpUtil doPostRequest:@"api/ZhengheDoctor/Oauth" args:args targetVC:self response:^(ResponseModel *responseMd) {
                     if (responseMd.isResultOk) {
                         // 将返回的账号字典数据 --> 模型
                         LoginResponseAccount *account = [LoginResponseAccount mj_objectWithKeyValues:responseMd.response];
                         // 归档进沙盒
                         [LoginResponseAccount encode:account];
                         [RongYunHttp loadRongYunTokenType:@"1" userId:account.Id completion:nil];
                         [self skipToHomePage];
                     }
                     
                 }];
             }
             else
             {
                 NSLog(@"%@",error);
             }
             
         }];
        
    }
}

#pragma mark - 登录
-(void)loginButtonAction {
    // 验证手机号
    if ([RegExpValidate validateMobile:self.phoneTF.text]) {
        [AppConfig saveLoginType:kPatient];
        // 请求登录参数
        NSMutableDictionary *args = [NSMutableDictionary dictionary];
        args[@"phone"] = self.phoneTF.text;
        NSString *passwordTF = [iOSMD5 md5:self.passwordTF.text];
        args[@"password"] = passwordTF;
        args[@"tokenName"] = kToken;
        [httpUtil doPostRequest:@"api/ZhenghePatient/patientLogin" args:args targetVC:self response:^(ResponseModel *responseMd) {
        
            NSLog(@"%@",responseMd.resultCode);
            NSLog(@"%@",responseMd.msg);
            if (responseMd.isResultOk) {
                // 将返回的账号字典数据 --> 模型
                LoginResponseAccount *account = [LoginResponseAccount mj_objectWithKeyValues:responseMd.response];
                // 归档进沙盒
                NSLog(@"huanzheID============%@",account.Id);
                [LoginResponseAccount encode:account];
                [AppConfig saveUserId:account.Id];
                [RongYunHttp loadRongYunTokenType:@"1" userId:account.Id completion:nil];
                [self skipToHomePage];
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = responseMd.msg;
                hud.margin = 10.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:3];
            }
        }];
    }else{
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入正确的手机号码";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:3];

    }
}
#pragma mark - 忘记密码
-(void)forgetButtonAction {
    
    WcrModifyPasswViewController *modifyPass = [[WcrModifyPasswViewController alloc]init];
    modifyPass.titleString = self.title;
    [self.navigationController pushViewController:modifyPass animated:YES];
    
}

#pragma mark - 切换到医生版
-(void)changedButtonAction {
    HLTLoginViewController *doctorLoginVC = [[HLTLoginViewController alloc] init];
    [self.navigationController pushViewController:doctorLoginVC animated:YES];
}

#pragma mark - textField Delegate
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_phoneTF resignFirstResponder];
    [_passwordTF resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _phoneTF) {
        [_passwordTF becomeFirstResponder];
    }else if (textField == _passwordTF) {
        [_passwordTF resignFirstResponder];
        // 登录

        
    }
    return YES;
}

@end
