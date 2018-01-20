//
//  AppDelegate.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/6.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

//分享
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"


#import "AppDelegate.h"
#import "GuideViewController.h"
#import "MedicineViewController.h"
#import "MyViewController.h"
#import "KnowledgeViewController.h"
#import "InquiryViewController.h"
#import "ViewModel.h"
//融云
#define RONGCLOUD_IM_APPKEY @"k51hidwqknr5b"//sfci50a7czyhi
#import "RongYunTools.h"

//短信验证
#import <SMS_SDK/SMSSDK.h>
#define SMS_APPKEY @"d9a5e81c9977"
#define SMS_APPSecret @"b32fe4b58a1e579d92803674333e4088"

//小米推送
#import "MiPushSDK.h"

// 支付宝
#import <AlipaySDK/AlipaySDK.h>
@interface AppDelegate () <RCIMConnectionStatusDelegate,MiPushSDKDelegate>


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [kUserDefaults setBool:NO forKey:@"viewAll"];
    [kUserDefaults setBool:NO forKey:@"viewDoc"];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    [httpUtil loadDataPostWithURLString:@"api/ZhengheView/view" args:args response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            
            ViewModel *viewModel = [ViewModel mj_objectWithKeyValues:responseMd.response];
            if([viewModel.view isEqual: @"1"]){
                [kUserDefaults setBool:YES forKey:@"viewAll"];
            }else if([viewModel.view isEqual: @"2"]){
                [kUserDefaults setBool:NO forKey:@"viewAll"];
                [kUserDefaults setBool:YES forKey:@"viewDoc"];
            }else{
                [kUserDefaults setBool:NO forKey:@"viewAll"];
            }
            
        }
    }];
    // 初始化第三方分享平台
    [self shareSDK];
    //向微信注册
    [WXApi registerApp:@"wx017e2e3ae3a1e866"];

    //初始化融云
    [[RongYunTools shareInstance]starRongYunSdk];
//    [RCIM sharedRCIM].connectionStatusDelegate = self;
    
    //初始化短信验证
    [SMSSDK registerApp:SMS_APPKEY withSecret:SMS_APPSecret];
    
    //小米推送
    [MiPushSDK registerMiPush:self];
    [MiPushSDK registerMiPush:self type:0 connect:YES];
    
    /**
     * 推送处理1
     */
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        //注册推送，用于iOS8之前的系统
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
//    // 是否为第一次登陆
    [self loadCookies];
    [self.window makeKeyAndVisible];
    
    return YES;
}




/**
 *  将得到的devicetoken 传给融云用于离线状态接收push ，您的app后台要上传推送证书
 *
 *  @param application <#application description#>
 *  @param deviceToken <#deviceToken description#>
 */
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
//    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kDeviceToken];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    
    //小米 注册APNS成功, 注册deviceToken
    [MiPushSDK bindDeviceToken:deviceToken];
}


- (void)application:(UIApplication *)app
didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    // 注册APNS失败
    NSLog(@"（小米）注册APNS失败 ＝%@",err);
}

-(void)miPushReceiveNotification:(NSDictionary *)data
{
    NSLog(@"长连接收到消息");
}

- (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data
{
    //    NSLog(@"data:%@,selector:%@",data,selector);
    // 请求成功
    if ([selector isEqualToString:@"bindDeviceToken:"]) {
        NSString * regid =[data objectForKey:@"regid"];
        [AppConfig saveMiPushTokenWithString:regid];
        NSLog(@"小米ID：----->%@",regid);
    }
}

- (void)miPushRequestErrWithSelector:(NSString *)selector error:(int)error data:(NSDictionary *)data
{
    NSLog(@"小米请求失败 == %@",data);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    /**
     * 统计推送打开率2
     */
    [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
    
    // 只要是接收到推送都刷新系统消息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateSystemInfo" object:nil userInfo:nil];
    
    NSLog(@"远程推送：%@",userInfo);
    
    
    // 在后台接收远程通知
    NSString *messageId = [userInfo objectForKey:@"_id_"];
    NSString *alertString = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    NSString *messageString = [userInfo objectForKey:@"message"];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertString message:messageString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    
    if ([alertString isEqualToString:@"下线通知"]) {
        
        /**
         当收到有其他账号登陆的时候：
         1.通知栏通知消息
         2.刷新系统消息（***）
         3.设备登录，挤下线
         */
        if ([LoginResponseAccount isLogin]) {
            [LoginResponseAccount remove];
            [AppConfig removeLoginType:kPatient];
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            UINavigationController * nvc = [[UINavigationController alloc] initWithRootViewController:loginVC];
            self.window.rootViewController = nvc;
            
        }
        
        if ([HLTLoginResponseAccount isLogin]) {
            [HLTLoginResponseAccount remove];
            [AppConfig removeLoginType:kDoctor];
            HLTLoginViewController *loginVC = [[HLTLoginViewController alloc]init];
            UINavigationController * nvc = [[UINavigationController alloc] initWithRootViewController:loginVC];
            self.window.rootViewController = nvc;
        }
        [RongYunTools logout];
    }
    
    [ MiPushSDK handleReceiveRemoteNotification :userInfo];
    // 使用此方法后，所有消息会进行去重，然后通过miPushReceiveNotification:回调返回给App
    
    [MiPushSDK openAppNotify:messageId];
    
}


#pragma mark - 监听融云状态变化的代理
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    
    if (status == 6) {
        //6 为在别的地方登陆
        
        //        [AppConfig logOut];
        //        [self againShowLoginPageAtMessage:@"您的账号在别的地方登陆！您被迫下线！"];
    }
}


#pragma mark - 初始化第三方分享平台
- (void)shareSDK{
    

    /*[ShareSDK registerApp:@"215a05ab5be0b" activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"2619860637"
                                           appSecret:@"08e73654c6cdc52171932056b6431913"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx017e2e3ae3a1e866"
                                       appSecret:@"8112d9907ae73ccf4ce1e97dd66343a2"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1104884133"
                                      appKey:@"ep97cRxtGuhiSgGQ"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];*/
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ)
                                        ]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"2619860637"
                                           appSecret:@"08e73654c6cdc52171932056b6431913"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx017e2e3ae3a1e866"
                                       appSecret:@"8112d9907ae73ccf4ce1e97dd66343a2"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1104884133"
                                      appKey:@"ep97cRxtGuhiSgGQ"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
      }];
   
}

#pragma mark - 首次登录
- (void)loadCookies{
    
    // 第一次登陆有导航页
    if (![kUserDefaults boolForKey:@"everLaunched"]) {
        
        // 首次登陆，有导航页
        [kUserDefaults setBool:YES forKey:@"everLaunched"];
        [kUserDefaults setBool:YES forKey:@"firstLaunch"];
        
        GuideViewController *guide = [[GuideViewController alloc]init];
        self.window.rootViewController = guide;
        
    } else {
        
        // [self loginRongCloud];
        [self setTabBarController];
        
    }
    
}

#pragma mark - tabbar
- (void)setTabBarController{
    // 不是首次登陆，跳过导航页
    [kUserDefaults setBool:NO forKey:@"firstLaunch"];
    
    NSInteger userState = [CoreArchive intForKey:@"userState"];
    if (userState == kPatient) {
        LoginResponseAccount * account = [LoginResponseAccount decode];
        [RongYunHttp loadRongYunTokenType:@"1" userId:account.Id completion:nil];
        
        UIFont *fontSize = [UIFont systemFontOfSize:KFont - 7];
        
        NSArray *norArray = @[@"图层-8",@"图层-9",@"iconfont-zhishiku",@"shape-23"];
        NSArray *selArray = @[@"形状-3",@"形状-8",@"形状-12",@"shape-232"];
        NSArray *titles = @[@"健康",@"咨询",@"知识",@"我的"];
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
        
//        UITabBarController *tabBarVC = [[UITabBarController alloc]init];
        BaseTabBarController *tabBarVC = [BaseTabBarController sharedTabBarController];
        
        //设置整个tabBar的每个item选中时的颜色
        tabBarVC.tabBar.tintColor = [UIColor colorWithHexString:@"#05b7c3"];
        
        UIImage *tabBarImage = [UIImage imageFileNamed:@"底部栏" andType:YES];
        tabBarVC.tabBar.barTintColor = [UIColor colorWithPatternImage:tabBarImage];
        
        tabBarVC.viewControllers = vcArray;
        
        self.window.rootViewController = tabBarVC;
    }else {
        // 医生
        NSLog(@"医生");
        
        HLTLoginResponseAccount * account = [HLTLoginResponseAccount decode];
        [RongYunHttp loadRongYunTokenType:@"2" userId:account.Id completion:nil];
        
        UIFont *fontSize = [UIFont systemFontOfSize:KFont - 7];
        
        NSArray *norArray = @[@"图层-10",@"图层-12",@"iconfont-zhishiku",@"shape-23"];
        NSArray *selArray = @[@"形状-2",@"形状-1",@"形状-12",@"shape-232"];
        NSArray *titles = @[@"健康在线",@"我的咨询",@"知识",@"个人中心"];
        NSArray *classNames = @[@"MMSChatViewController",@"HLTDiagnoseViewController",@"KnowledgeViewController",@"HLTMyViewController"];
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
        
            //        UITabBarController *tabBarVC = [[UITabBarController alloc]init];
            BaseTabBarController *tabBarVC = [BaseTabBarController sharedTabBarController];
            
            //设置整个tabBar的每个item选中时的颜色
            tabBarVC.tabBar.tintColor = [UIColor colorWithHexString:@"#05b7c3"];
            
            UIImage *tabBarImage = [UIImage imageFileNamed:@"底部栏" andType:YES];
            tabBarVC.tabBar.barTintColor = [UIColor colorWithPatternImage:tabBarImage];
            
            tabBarVC.viewControllers = vcArray;
            
            self.window.rootViewController = tabBarVC;
            
    }
    

}

/*- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}*/


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [RongYunTools setUnreadMsgCountOnIconBadgeNumber];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }else{
        [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }else{
        [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString * wxPayResult;
        switch (resp.errCode) {
            case WXSuccess:
                wxPayResult = @"success";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                wxPayResult = @"faile";
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        //发出通知 从微信回调回来之后,发一个通知,让请求支付的页面接收消息,并且展示出来,或者进行一些自定义的展示或者跳转
        NSNotification * notification = [NSNotification notificationWithName:@"WXPay" object:wxPayResult];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    
}


@end
