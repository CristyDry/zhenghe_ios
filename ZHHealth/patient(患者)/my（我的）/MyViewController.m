//
//  MyViewController.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/10.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "MyViewController.h"
#import "WcrMyList.h"
#import "WcrMyListCell.h"
#import "WcrMyInfoViewController.h"
#import "WcrSettingViewController.h"
#import "WcrSystemInfoViewController.h"
#import "BZShoppingCartViewController.h"
#import "BZMyOrderController.h"
#import "BZMedicalRecordController.h"
#import "BZHealthRecordController.h"
#import "BZLeftRecordController.h"
#import "BZMyCollectController.h"
#import "BZIdeaFeedBackController.h"
#import "LoginViewController.h"
#import "HLTInfoViewController.h"

/*分享*/
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"

@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *firstSection;
@property (nonatomic, strong) NSArray *secondSection;
@property (nonatomic, strong) NSArray *thirdSection;
@property (nonatomic,strong)  UIImageView *iconIV;// 患者头像
@property (nonatomic,strong)  UILabel *nameLabel;// 患者名字
@property (nonatomic,strong)  LoginResponseAccount *account;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 有tableView看情况设置，高度可能要减去49
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _firstSection = [WcrMyList returnFirstLists];
    if([kUserDefaults boolForKey:@"viewAll"]){
        _secondSection = [WcrMyList returnSecondLists];
    }
    _thirdSection = [WcrMyList returnThirdLists];
    
    // 设置tableView 属性
    [self setTableViewProperty];
    
    // 隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // 设置左右两边的button
    [self setLeftAndRightButton];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if ([LoginResponseAccount isLogin]) {
        LoginResponseAccount *account = [LoginResponseAccount decode];
        [_iconIV sd_setImageWithURL:[NSURL URLWithString:account.avatar] placeholderImage:[UIImage imageNamed:@"ic_error"]];
        [_nameLabel labelWithText:account.patientName andTextColor:[UIColor whiteColor] andFontSize:KFont - 4 andBackgroundColor:nil];
    }else{
        // 未登录，跳转到登录界面
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }

}

#pragma mark - 设置tableView 属性，头视图
-(void)setTableViewProperty {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, kMainHeight - KBottomLayoutGuideHeight) style:UITableViewStyleGrouped];
    [self initializationTableViewWithTableView:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // 头视图
    CGFloat heightOfHeader = 160.0f;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, heightOfHeader)];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.opaque = YES;
    
    UIImageView *headerIV = [[UIImageView alloc]initWithFrame:headerView.frame];
    headerIV.backgroundColor = [UIColor clearColor];
    UIImage *bgImage = [UIImage imageFileNamed:@"background" andType:YES];
    headerIV.image = bgImage;
    [headerView addSubview:headerIV];
    
    // 头像
    CGFloat heightOfIcon = 60.0f;
    CGFloat heightOfName = 40.0f;
    CGFloat yPoint = headerView.height_wcr - heightOfIcon - heightOfName;
    CGFloat xPoint = (kMainWidth - heightOfIcon) / 2.0;
    UIImageView *iconIV = [[UIImageView alloc]initWithFrame:CGRectMake(xPoint, yPoint, heightOfIcon, heightOfIcon)];
    _iconIV = iconIV;
    _iconIV.backgroundColor = [UIColor clearColor];
    _iconIV.contentMode = UIViewContentModeScaleAspectFill;
    [_iconIV.layer setCornerRadius:heightOfIcon / 2.0];
    _iconIV.clipsToBounds = YES;
    if ([LoginResponseAccount isLogin]) {
        _account = [LoginResponseAccount decode];
       
    }
     [_iconIV sd_setImageWithURL:[NSURL URLWithString:_account.avatar] placeholderImage:[UIImage imageNamed:@"ic_error"]];
    _iconIV.opaque = YES;
    [headerView addSubview:_iconIV];
    
    // 名字
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, iconIV.maxY_wcr, kMainWidth, heightOfName)];
    _nameLabel = nameLabel;
    [nameLabel labelWithText:_account.patientName andTextColor:[UIColor whiteColor] andFontSize:KFont - 4 andBackgroundColor:nil];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.opaque = YES;
    [headerView addSubview:nameLabel];
    
    UIButton *button = [[UIButton alloc]initWithFrame:iconIV.frame];
    [button addTarget:self action:@selector(clickIcon:)];
    button.backgroundColor = [UIColor clearColor];
    button.opaque = YES;
    [headerView addSubview:button];
    
    _tableView.tableHeaderView = headerView;
    
}
// 点击头像
-(void)clickIcon:(UIButton*)button {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    // 判断是否已登录
    if ([LoginResponseAccount isLogin]) {
        // 已经登录
        WcrMyInfoViewController *wcrMyInfoVC = [[WcrMyInfoViewController alloc]init];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:wcrMyInfoVC];
        [self presentViewController:navi animated:YES completion:nil];
    }else{
        // 未登录，跳转到登录界面
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }

    
}


#pragma mark - 设置左右两边的button
-(void)setLeftAndRightButton {
    // UIButton *leftButton =
    [self getOneButtonWithImageName:@"iconfont-pinglun" andTag:1001 andXpoint:kBorder];
    
    // UIButton *rightButton =
    CGFloat height = 22.0f;
    CGFloat xPoint = kMainWidth - kBorder - height;
    [self getOneButtonWithImageName:@"设置" andTag:1002 andXpoint:xPoint];
    
    
}

-(UIButton*)getOneButtonWithImageName:(NSString*)imageName andTag:(int)buttonTag andXpoint:(CGFloat)xPoint{
    
    CGFloat width = 22.0f;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(xPoint, 30, width, width)];
    button.backgroundColor = [UIColor clearColor];
    [button setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    
    [button setImage:[UIImage imageFileNamed:imageName andType:YES] forState:0];
    
    button.tag = buttonTag;
    [button addTarget:self action:@selector(buttonAction:)];
    
    [self.view addSubview:button];
    
    return button;
}

-(void)buttonAction:(UIButton*)button {
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if (button.tag == 1001) {
        // 系统消息
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        HLTInfoViewController * info = [[HLTInfoViewController alloc] init];
        info.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:info animated:NO];
//        WcrSystemInfoViewController *systemInfoVC = [[WcrSystemInfoViewController alloc]init];
//        systemInfoVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:systemInfoVC animated:YES];
        
    }else if (button.tag == 1002) {
        // 设置
        WcrSettingViewController *setting = [[WcrSettingViewController alloc]init];
        setting.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:setting animated:YES];
        
    }
    
}

#pragma mark - Table View Data Source 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _firstSection.count;
    }else if (section == 1) {
        return _secondSection.count;
    }else {
        return _thirdSection.count;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"myListCell";
    
    WcrMyListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[WcrMyListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        cell.myList = _firstSection[indexPath.row];
    }else if (indexPath.section == 1) {
        cell.myList = _secondSection[indexPath.row];
        
    }else if (indexPath.section == 2) {
        cell.myList = _thirdSection[indexPath.row];
    }
    
    return cell;
}

#pragma mark - Table View Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0.1f;
    }else {
        return 20.0f;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}



// 判断点击了哪一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    WcrMyList *list1 = (WcrMyList *)[WcrMyList returnFirstLists];
    WcrMyList *list2 = (WcrMyList *)[WcrMyList returnSecondLists];
    WcrMyList *list3 = (WcrMyList *)[WcrMyList returnThirdLists];
    
    if (indexPath.section == 0){
        list1 = _firstSection[indexPath.row];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        if ([list1.name isEqualToString:@"电子档案"]) {
            
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            BZMedicalRecordController *medicalRecordVC = [[BZMedicalRecordController alloc] init];
            medicalRecordVC.isPatient = YES;
            medicalRecordVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:medicalRecordVC animated:false];

        }else if ([list1.name isEqualToString:@"健康记录"]){
            
            //[self.navigationController setNavigationBarHidden:NO animated:NO];
            BZHealthRecordController *healthRecordVC = [[BZHealthRecordController alloc] init];
            healthRecordVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:healthRecordVC animated:YES];
            
        }else if ([list1.name isEqualToString:@"生活日志"]){
            
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            BZLeftRecordController *leftRecordVC = [[BZLeftRecordController alloc] init];
            leftRecordVC.hidesBottomBarWhenPushed = YES;
            [self jumpVC:leftRecordVC];
        
        }
    
    }else if (indexPath.section == 1){
        list2 = _secondSection[indexPath.row];
        if ([list2.name isEqualToString:@"我的订单"]) {
            // 点击了我的订单
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            BZMyOrderController *myOrderVC = [[BZMyOrderController alloc] init];
            myOrderVC.hidesBottomBarWhenPushed = YES;
            [self jumpVC:myOrderVC];
            
        }else if ([list2.name isEqualToString:@"购物车"]){
            // 点击购物车
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            BZShoppingCartViewController *shoppingCartController = [[BZShoppingCartViewController alloc] init];
            shoppingCartController.hidesBottomBarWhenPushed = YES;
            [self jumpVC:shoppingCartController];
        }
    }else if (indexPath.section == 2){
        list3 = _thirdSection[indexPath.row];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        if ([list3.name isEqualToString:@"我的收藏"]) {
            
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            BZMyCollectController *myCollectVC = [[BZMyCollectController alloc] init];
            myCollectVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myCollectVC animated:YES];
        }else if ([list3.name isEqualToString:@"分享"]){

            [self share];
            self.navigationController.navigationBarHidden = YES;
            
        }else if ([list3.name isEqualToString:@"意见反馈"]){
            
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            BZIdeaFeedBackController *ideaFeedBackVC = [[BZIdeaFeedBackController alloc] init];
            ideaFeedBackVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ideaFeedBackVC animated:YES];
        }
    }    
}


#pragma mark - 分享
- (void)share{
    
    
    [httpUtil doPostRequest:@"api/ZhengheDoctor/shareApp" args:nil targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            
            NSDictionary * dic = responseMd.response;
            //1、创建分享参数
            // NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
            //if (imageArray) {
            
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:@"正弘app,与专家在线交流"
                                             images:[UIImage imageNamed:@"512"]
                                                url:[NSURL URLWithString:dic[@"url"]]
                                              title:@"正弘健康"
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
    }];
    
}

// 跳转控制器
- (void)jumpVC:(UIViewController *)VC{
    // 判断是否已登录
    if ([LoginResponseAccount isLogin]) {
        // 已经登录
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        // 未登录，跳转到登录界面
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}





@end
