//
//  WCRKnowledgeDetailController.m
//  ZHHealth
//
//  Created by U1KJ on 15/11/18.
//  Copyright © 2015年 U1KJ. All rights reserved.
//


#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"

#import "WCRKnowledgeDetailController.h"
#import "BZArticleContentModel.h"
#import "LoginResponseAccount.h"
#import "LoginViewController.h"

@interface WCRKnowledgeDetailController ()
@property (nonatomic,strong)  BZArticleContentModel *articleContentModel;
@property (nonatomic,strong)  UIImageView *imageView;
@property (nonatomic,strong)  UIView *topView;
@property (nonatomic,strong)  UIButton *collectBtn;
@end

@implementation WCRKnowledgeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
//    [self setNavigationBarProperty];
    // 请求文章内容数据
    [self requestArticleContent];
    // 设置导航栏
    [self setNavigationBar];
//    [self addLeftBackItem];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}
#pragma mark - 设置导航栏
- (void)setNavigationBar{
    // 白色背景
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, 44)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:topView];
    _topView = topView;
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(kMainWidth * 0.7, 0, kMainWidth * 0.3, 44)];
    [topView addSubview:rightView];
    CGFloat rightViewW = rightView.bounds.size.width;
    CGFloat rightViewH = rightView.bounds.size.height;
    // 右边的返回按钮
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backBtn setImage:[UIImage imageNamed:@"12"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backLeftNavItemAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    // 添加右上角点赞，分享，收藏按钮
    // 分享
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, rightViewW * 0.4, rightViewH)];
    [shareBtn setImage:[UIImage imageNamed:@"iconfont-fenxiang-2"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"iconfont-fenxiang-2"] forState:UIControlStateHighlighted];
    [shareBtn setImage:[UIImage imageNamed:@"iconfont-fenxiang-2-拷贝"] forState:UIControlStateSelected];
    [shareBtn setImage:[UIImage imageNamed:@"iconfont-fenxiang-2-拷贝"] forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:shareBtn];
    // 收藏
    UIButton *collectBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(shareBtn.frame), 0, rightViewW * 0.4, rightViewH)];
    [collectBtn setImage:[UIImage imageNamed:@"iconfont-collect@3x"] forState:UIControlStateNormal];
    [collectBtn setImage:[UIImage imageNamed:@"iconfont-collect@3x"] forState:UIControlStateHighlighted];
    [collectBtn setImage:[UIImage imageNamed:@"iconfont-collect-拷贝@3x"] forState:UIControlStateSelected];
    [collectBtn setImage:[UIImage imageNamed:@"iconfont-collect-拷贝@3x"] forState:UIControlStateHighlighted];
    [collectBtn addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:collectBtn];
    _collectBtn = collectBtn;
    
}
-(void)backLeftNavItemAction{
    [_topView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 分享
- (void)share:(UIButton *)shareBtn{
    
    //1、创建分享参数
    // NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
    //if (imageArray) {
    
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:_articleContentModel.title
                                     images:_articleContentModel.avatar
                                        url:[NSURL URLWithString:_articleContentModel.url]
                                      title:_articleContentModel.title
                                       type:SSDKContentTypeAuto];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:[NSString stringWithFormat:@"%@",error]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                       default:
                           break;
                   }
               }
     ];//}
}



// 点击收藏
- (void)collect:(UIButton *)btn{
    
    // 判断是医生还是患者
    NSInteger userState = [CoreArchive intForKey:@"userState"];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    
    if (userState == kPatient) {//患者
        if ([LoginResponseAccount isLogin]) {//患者已登录
            LoginResponseAccount *userAccount = [LoginResponseAccount decode];
            args[@"userId"] = userAccount.Id;
            args[@"thingType"] = @"a";
            args[@"thingId"] = _articleId;
            args[@"userType"] = @"1";
            if (btn.selected == NO) {
                // 收藏
                args[@"status"] = @"1";
                [httpUtil doPostRequest:@"api/ZhengheDoctor/collectThing" args:args targetVC:self response:^(ResponseModel *responseMd) {
                    if (responseMd.isResultOk) {
                        btn.selected = YES;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self isCollect:@"收藏成功"];
                        });
                    }
                }];
            }else{
                // 取消收藏
                args[@"status"] = @"0";
                [httpUtil doPostRequest:@"api/ZhengheDoctor/collectThing" args:args targetVC:self response:^(ResponseModel *responseMd) {
                    if (responseMd.isResultOk) {
                        btn.selected = NO;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self isCollect:@"取消收藏成功"];
                        });
                    }
                }];
            }
            
        }else{//患者没登录
            // 跳转到患者登录界面
            [_topView removeFromSuperview];
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }else{
        
        if ([HLTLoginResponseAccount isLogin]) {//如果医生已登录
            HLTLoginResponseAccount *userAccount = [HLTLoginResponseAccount decode];
            args[@"userId"] = userAccount.Id;
            args[@"thingType"] = @"a";
            args[@"thingId"] = _articleId;
            args[@"userType"] = @"2";
            if (btn.selected == NO) {
                // 收藏
                args[@"status"] = @"1";
                [httpUtil doPostRequest:@"api/ZhengheDoctor/collectThing" args:args targetVC:self response:^(ResponseModel *responseMd) {
                    if (responseMd.isResultOk) {
                        btn.selected = YES;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self isCollect:@"收藏成功"];
                        });
                        
                    }
                }];
            }else{
                // 取消收藏
                args[@"status"] = @"0";
                [httpUtil doPostRequest:@"api/ZhengheDoctor/collectThing" args:args targetVC:self response:^(ResponseModel *responseMd) {
                    if (responseMd.isResultOk) {
                        btn.selected = NO;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self isCollect:@"取消收藏成功"];
                        });
                    }
                }];
            }
            
        }else{//医生没登录
            // 跳转到医生登录界面
            [_topView removeFromSuperview];
            HLTLoginViewController *loginVC = [[HLTLoginViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }
}

// 提示框-收藏成功/取消收藏成功
- (void)isCollect:(NSString *)str{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1];
}

// 请求文章内容数据
- (void)requestArticleContent{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"articleId"] = _articleId;
    
    NSInteger userState = [CoreArchive intForKey:@"userState"];
    //患者
    if (userState == kPatient){
        // 判断是否已登录
        if ([LoginResponseAccount isLogin]) {
            // 已登录
            LoginResponseAccount *userAccount = [LoginResponseAccount decode];
            // 患者
            args[@"userId"] = userAccount.Id;
            args[@"userType"] = @"1";
            __weak typeof(self) weakSelf = self;
            [httpUtil doPostRequest:@"api/ZhengheDoctor/articleDetails" args:args targetVC:self response:^(ResponseModel *responseMd) {
                weakSelf.articleContentModel = [BZArticleContentModel mj_objectWithKeyValues:responseMd.response];
                [self customDetailUI];
                // 设置收藏按钮的状态
                if ([weakSelf.articleContentModel.isCollect isEqualToString:@"0"]) {
                    NSLog(@"weakSelf.articleContentModel.isCollect:%@",weakSelf.articleContentModel.isCollect);
                    weakSelf.collectBtn.selected = NO;
                }else if ([weakSelf.articleContentModel.isCollect isEqualToString:@"1"]){
                    NSLog(@"weakSelf.articleContentModel.isCollect:%@",weakSelf.articleContentModel.isCollect);
                    weakSelf.collectBtn.selected = YES;
                }
                
            }];
        }else{
            // 未登录
            __weak typeof(self) weakSelf = self;
            [httpUtil doPostRequest:@"api/ZhengheDoctor/articleDetails" args:args targetVC:self response:^(ResponseModel *responseMd) {
                weakSelf.articleContentModel = [BZArticleContentModel mj_objectWithKeyValues:responseMd.response];
                [self customDetailUI];
            }];
        }
    }else{
        if ([HLTLoginResponseAccount isLogin]) {
            // 已登录
            HLTLoginResponseAccount *userAccount = [HLTLoginResponseAccount decode];
            // 患者
            args[@"userId"] = userAccount.Id;
            // 医生
            args[@"userType"] = @"2";
            __weak typeof(self) weakSelf = self;
            [httpUtil doPostRequest:@"api/ZhengheDoctor/articleDetails" args:args targetVC:self response:^(ResponseModel *responseMd) {
                weakSelf.articleContentModel = [BZArticleContentModel mj_objectWithKeyValues:responseMd.response];
                [self customDetailUI];
                // 设置收藏按钮的状态
                if ([weakSelf.articleContentModel.isCollect isEqualToString:@"0"]) {
                    weakSelf.collectBtn.selected = NO;
                }else if ([weakSelf.articleContentModel.isCollect isEqualToString:@"1"]){
                    weakSelf.collectBtn.selected = YES;
                }
            }];
        }else{
            // 未登录
            __weak typeof(self) weakSelf = self;
            [httpUtil doPostRequest:@"api/ZhengheDoctor/articleDetails" args:args targetVC:self response:^(ResponseModel *responseMd) {
                weakSelf.articleContentModel = [BZArticleContentModel mj_objectWithKeyValues:responseMd.response];
                [self customDetailUI];
            }];
        }
    }
}



-(void)customDetailUI {
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, KTopLayoutGuideHeight, kMainWidth, kMainHeight - KTopLayoutGuideHeight)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    CGFloat xPoint = kBorder;
    CGFloat yPoint = 10.0;
    CGFloat width = kMainWidth - xPoint * 2;
    // 计算实际的高度
    CGFloat height = [Tools calculateLabelHeight:_articleContentModel.title font:[UIFont systemFontOfSize:KFont - 2] AndWidth:width];
    
    // 标题
    UILabel *tileLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    [tileLabel labelWithText:_articleContentModel.title andTextColor:kBlackColor andFontSize:KFont - 2 andBackgroundColor:nil];
    tileLabel.numberOfLines = 0;
    tileLabel.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:tileLabel];
    
    // 文章出处
    yPoint = tileLabel.maxY_wcr + 5;
    height = 40;
    NSString *publish = _articleContentModel.publish;
    UILabel *publishLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [publishLabel setNumberOfLines:0];
    UIFont *font = [UIFont fontWithName:@"Arial" size:13];
    CGSize size = CGSizeMake(kMainWidth, 2000);
    CGSize labelSize = [publish sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    publishLabel.frame = CGRectMake(xPoint, yPoint , labelSize.width, 10);
    publishLabel.text = publish;
    publishLabel.font = font;
    publishLabel.textColor = kNavigationBarColor;
    [scrollView addSubview:publishLabel];
    // 时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(publishLabel.frame) + 10, yPoint , kMainWidth - CGRectGetMaxX(publishLabel.frame) - 20, 10)];
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.text = _articleContentModel.createDate;
    timeLabel.textColor = kGrayColor;
    [scrollView addSubview:timeLabel];

    // 大图
    if (_articleContentModel.avatar) {
        yPoint = publishLabel.maxY_wcr + 10;
        height = width * (340 / 580.0);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
        imageView.backgroundColor = [UIColor clearColor];
        [imageView sd_setImageWithURL:[NSURL URLWithString:_articleContentModel.avatar]];
        [scrollView addSubview:imageView];
        _imageView = imageView;
    }
    // 内容
    height = [Tools calculateLabelHeight:_articleContentModel.content font:[UIFont systemFontOfSize:KFont - 4] AndWidth:width] + 20;
    yPoint = _imageView.maxY_wcr;
    UILabel *contentlabel = [[UILabel alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    [contentlabel labelWithText:_articleContentModel.content andTextColor:kGrayColor andFontSize:KFont - 4 andBackgroundColor:nil];
    contentlabel.numberOfLines = 0;
    [scrollView addSubview:contentlabel];
    
  
    scrollView.contentSize = CGSizeMake(kMainWidth, contentlabel.maxY_wcr);
    
}

@end
