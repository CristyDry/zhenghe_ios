//
//  HLTLoginViewController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/15.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTLoginViewController.h"
#import "WcrModifyPasswViewController.h"
#import "RongYunTools.h"

@interface HLTLoginViewController () <UITextFieldDelegate>
@property (nonatomic,strong)  HLTLoginResponseAccount *loginAccount;
@property (nonatomic,strong)  NSArray *channelListModelA;
@end

@implementation HLTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专家登录";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addLeftBackItem];
    
    [self setNavigationBarProperty];
    
    [self customLoginUI];
    
}

#pragma mark - 取消按钮
-(void)addLeftBackItem
{
    // KFont - 3
    UIButton *leftButton = [self getButtonWithButtonTitle:@"" andWith:40 andTag:308];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
}

-(UIButton*)getButtonWithButtonTitle:(NSString*)buttonTitle andWith:(CGFloat)width andTag:(int)buttonTag {
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
    [button buttonWithTitle:buttonTitle andTitleColor:[UIColor whiteColor] andBackgroundImageName:nil andFontSize:KFont - 3];
    button.tag = buttonTag;
    [button addTarget:self action:@selector(LeftAction)];
    return button;
    
}

-(void)LeftAction {
    [self skipToHomePage];
}
- (void)viewWillAppear:(BOOL)animated{
    _phoneTF.text = _phoneNumber;
}

#pragma mark - 取消登录按钮
-(void)skipToHomePage {

    UIFont *fontSize = [UIFont systemFontOfSize:KFont - 7];
    
    NSArray *norArray = @[@"图层-10",@"图层-12",@"iconfont-zhishiku",@"shape-23"];
    NSArray *selArray = @[@"形状-2",@"形状-1",@"形状-12",@"shape-232"];
    NSArray *titles = @[@"在线接诊",@"我的诊室",@"知识",@"个人中心"];
    NSArray *classNames = @[@"HLTAdmissionsViewController",@"HLTDiagnoseViewController",@"KnowledgeViewController",@"HLTMyViewController"];
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
    //BaseTabBarController *tabBarVC = [BaseTabBarController sharedTabBarController];
    //设置整个tabBar的每个item选中时的颜色
    tabBarVC.tabBar.tintColor = [UIColor colorWithHexString:@"#05b7c3"];
    
    UIImage *tabBarImage = [UIImage imageFileNamed:@"底部栏" andType:YES];
    tabBarVC.tabBar.barTintColor = [UIColor colorWithPatternImage:tabBarImage];
    
    tabBarVC.viewControllers = vcArray;
    tabBarVC.selectedIndex = 0;
    [self presentViewController:tabBarVC animated:YES completion:nil];
    
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
    
    //联系客服
    yPoint = forgetButton.maxY_wcr+kMainWidth*0.5;
    UILabel * keFuLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yPoint, kMainWidth, 20)];
    keFuLabel.text = @"联系客服注册成为咨询专家";
    keFuLabel.textAlignment = NSTextAlignmentCenter;
    keFuLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:keFuLabel];
    
    //联系客服电话按钮
    width = 90;
    yPoint = keFuLabel.maxY_wcr+10;
    xPoint = (kMainWidth - width)*0.5;
    UIButton * KtelButton = [[UIButton alloc] initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    [KtelButton setTitle:@"400-123-123" forState:UIControlStateNormal];
    KtelButton.font = [UIFont systemFontOfSize:13];
    [KtelButton addTarget:self action:@selector(KtelButton) forControlEvents:UIControlEventTouchUpInside];
    [KtelButton setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [self.view addSubview:KtelButton];
    
    //下划线
    yPoint = KtelButton.maxY_wcr;
    UIImageView * LineImageview = [[UIImageView alloc] initWithFrame:CGRectMake(xPoint, yPoint, width, 1)];
    LineImageview.backgroundColor = kNavigationBarColor;
    [self.view addSubview:LineImageview];
 
    height = 49;
    yPoint = kMainHeight - height;
    // 切换为患者版按钮
    UIButton *changedButton = [[UIButton alloc]initWithFrame:CGRectMake(0, yPoint, kMainWidth, height)];
    [changedButton buttonWithTitle:@"切换到用户版" andTitleColor:[UIColor whiteColor] andBackgroundImageName:nil andFontSize:KFont - 2];
    changedButton.backgroundColor = [UIColor colorWithHexString:@"#05b7c3"];
    [changedButton addTarget:self action:@selector(changedButtonAction)];
    [self.view addSubview:changedButton];
    
}

#pragma mark - 拨打客服电话
-(void)KtelButton
{
    NSLog(@"拨打客服电话");
    UIWebView *callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:@"tel:400-123-123"];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}
#pragma mark - 登录
-(void)loginButtonAction {
    
    [AppConfig saveLoginType:kDoctor];
    // 请求登录参数
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
     NSString *passwordTF = [iOSMD5 md5:self.passwordTF.text];
    args[@"phone"] = self.phoneTF.text;
    args[@"password"] = passwordTF;
    args[@"tokenName"] = kToken;
    NSLog(@"kToken==========%@",kToken);
    [httpUtil doPostRequest:@"api/ZhengheDoctor/loginDoctor" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            
            // 将返回的账号字典数据 --> 模型
            HLTLoginResponseAccount *account = [HLTLoginResponseAccount mj_objectWithKeyValues:responseMd.response];
            // 归档进沙盒
            [HLTLoginResponseAccount encode:account];
            [AppConfig saveUserId:account.Id];
            [RongYunHttp loadRongYunTokenType:@"2" userId:account.Id completion:nil];
            [self skipToHomePage];
        }
    }];
    
}
#pragma mark - 忘记密码
-(void)forgetButtonAction {
    
    WcrModifyPasswViewController *modifyPass = [[WcrModifyPasswViewController alloc]init];
    modifyPass.titleString = self.title;
    [self.navigationController pushViewController:modifyPass animated:YES];
    
}

#pragma mark - 切换到患者版
-(void)changedButtonAction {
    UIFont *fontSize = [UIFont systemFontOfSize:KFont - 7];
    
    NSArray *norArray = @[@"图层-8",@"图层-9",@"iconfont-zhishiku",@"shape-23"];
    NSArray *selArray = @[@"形状-3",@"形状-8",@"形状-12",@"shape-232"];
    NSArray *titles = @[@"咨询",@"问诊",@"知识",@"我的"];
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
        if ([titles[i] isEqualToString:@"知识"]) {
            // 知识百科
            vc.navigationItem.title = @"知识百科";
        }
        
        [vcArray addObject:navc];
    }
    
    UITabBarController *tabBarVC = [[UITabBarController alloc]init];
    //BaseTabBarController *tabBarVC = [BaseTabBarController sharedTabBarController];
    
    //设置整个tabBar的每个item选中时的颜色
    tabBarVC.tabBar.tintColor = [UIColor colorWithHexString:@"#05b7c3"];
    
    UIImage *tabBarImage = [UIImage imageFileNamed:@"底部栏" andType:YES];
    tabBarVC.tabBar.barTintColor = [UIColor colorWithPatternImage:tabBarImage];
    
    tabBarVC.viewControllers = vcArray;
    tabBarVC.selectedIndex = 0;
    [self presentViewController:tabBarVC animated:NO completion:nil];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
