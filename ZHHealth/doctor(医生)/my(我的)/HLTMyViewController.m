//
//  HLTMyViewController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/15.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTMyViewController.h"
#import "HLTMyList.h"
#import "WcrMyListCell.h"
#import "HLTEditViewController.h"//编辑资料
#import "HLTCollectViewController.h"//收藏
#import "HLTInfoViewController.h"//系统
#import "HLTShareViewController.h"//分享
#import "BZIdeaFeedBackController.h"//意见
#import "HLTSetViewController.h"//设置


/*分享*/
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"


@interface HLTMyViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *firstSection;
@property (nonatomic, strong) NSArray *secondSection;
@property (nonatomic, strong) NSArray *thirdSection;

@property (nonatomic, strong) UIImageView *iconIV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *zhiYeLabel;

@end

@implementation HLTMyViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //请求医生详细资料
    [self RequestDoctorInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //若为登录则跳到登录页面
    if (![HLTLoginResponseAccount isLogin]) {
        HLTLoginViewController * login = [[HLTLoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    }
    // 有tableView看情况设置，高度可能要减去49
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _firstSection = [HLTMyList returnFirstLists];
    _secondSection = [HLTMyList returnSecondLists];
    _thirdSection = [HLTMyList returnThirdLists];
    self.view.backgroundColor = [UIColor whiteColor];
    
     [self setTableViewProperty];
}


#pragma mark - 请求医生详细资料
-(void)RequestDoctorInfo
{
    //将所需的参数id解档出来
    HLTLoginResponseAccount * account = [HLTLoginResponseAccount decode];
    
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"id"] = account.Id;
    __weak typeof(self) weakSelf = self;
    [httpUtil doPostRequest:@"api/ZhengheDoctor/doctorDetails" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            weakSelf.editModel = [HLTEditModel mj_objectWithKeyValues:responseMd.response];

            [_iconIV sd_setImageWithURL:[NSURL URLWithString:_editModel.avatar] placeholderImage:[UIImage imageNamed:@"ic_error"]];
            [_nameLabel labelWithText:_editModel.doctor andTextColor:[UIColor whiteColor] andFontSize:KFont - 2 andBackgroundColor:nil];
            [_zhiYeLabel labelWithText:_editModel.professional andTextColor:[UIColor whiteColor] andFontSize:KFont - 4 andBackgroundColor:nil];
            [_tableView reloadData];
        }
    }];
}


#pragma mark - 添加头部视图
-(void)setTableViewProperty {
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KTopLayoutGuideHeight, kMainWidth, kMainHeight - KBottomLayoutGuideHeight - KTopLayoutGuideHeight) style:UITableViewStyleGrouped];
    [self initializationTableViewWithTableView:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // 头视图
    CGFloat heightOfHeader = 140.0f;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, heightOfHeader)];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.opaque = YES;
    
    UIImageView *headerIV = [[UIImageView alloc]initWithFrame:headerView.frame];
    //headerIV.backgroundColor = [UIColor clearColor];
    UIImage *bgImage = [UIImage imageFileNamed:@"u=1300738000,3023233166&fm=21&gp=0" andType:YES];
    headerIV.image = bgImage;
    [headerView addSubview:headerIV];
    
    // 头像
    CGFloat heightOfIcon = 60.0f;
    CGFloat heightOfName = 40.0f;
    CGFloat xPoint = 15.0f;
    _iconIV = [[UIImageView alloc]initWithFrame:CGRectMake(xPoint,(heightOfHeader-heightOfIcon)/2, heightOfIcon, heightOfIcon)];
    _iconIV.backgroundColor = [UIColor clearColor];
    _iconIV.contentMode = UIViewContentModeScaleAspectFill;
    [_iconIV.layer setCornerRadius:heightOfIcon / 2.0];
    _iconIV.clipsToBounds = YES;
    [_iconIV sd_setImageWithURL:[NSURL URLWithString:_editModel.avatar] placeholderImage:[UIImage imageNamed:@"ic_error"]];
    [headerView addSubview:_iconIV];
    
    // 名字
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_iconIV.maxX_wcr+xPoint , (heightOfHeader-heightOfName)/2, heightOfName+40, heightOfName)];
    [_nameLabel labelWithText:_editModel.doctor andTextColor:[UIColor whiteColor] andFontSize:KFont - 2 andBackgroundColor:nil];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.opaque = YES;
    [headerView addSubview:_nameLabel];
    
    _zhiYeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.maxX_wcr+10 , (heightOfHeader-heightOfName)/2, heightOfIcon+30, heightOfName)];
    [_zhiYeLabel labelWithText:_editModel.professional andTextColor:[UIColor whiteColor] andFontSize:KFont - 4 andBackgroundColor:nil];
    _zhiYeLabel.textAlignment = NSTextAlignmentCenter;
    _zhiYeLabel.opaque = YES;
    [headerView addSubview:_zhiYeLabel];
    
    _tableView.tableHeaderView = headerView;
    
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
        return 0.0f;
    }else {
        return AUTO_MATE_HEIGHT(3.0f);
    }
    
}
#pragma mark - 判断点击的tableviewcell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HLTMyList *list1 = (HLTMyList *)[HLTMyList returnFirstLists];
    HLTMyList *list2 = (HLTMyList *)[HLTMyList returnSecondLists];
    HLTMyList *list3 = (HLTMyList *)[HLTMyList returnThirdLists];
    
    if (indexPath.section == 0)
    {
        list1 = _firstSection[indexPath.row];
        
        if ([list1.name isEqualToString:@"编辑资料"])
        {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            HLTEditViewController * edit = [[HLTEditViewController alloc] init];
            edit.editModel =_editModel;
            edit.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:edit animated:NO];
        }
        else if([list1.name isEqualToString:@"我的收藏"])
        {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            HLTCollectViewController * collect = [[HLTCollectViewController alloc] init];
            collect.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:collect animated:NO];
        }
        else if ([list1.name isEqualToString:@"免打扰时间"])
        {
        }
    }
    else if (indexPath.section == 1)
    {
        list2 = _secondSection[indexPath.row];
        
        if ([list2.name isEqualToString:@"系统通知"])
        {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            HLTInfoViewController * info = [[HLTInfoViewController alloc] init];
            info.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:info animated:NO];
        }
        else if ([list2.name isEqualToString:@"分享"])
        {
            [self share];
            
        }
        else if ([list2.name isEqualToString:@"意见反馈"])
        {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            BZIdeaFeedBackController * yijian = [[BZIdeaFeedBackController alloc] init];
            yijian.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:yijian animated:NO];
        }
    }
    else if (indexPath.section == 2)
    {
        list3 = _thirdSection[indexPath.row];
        
        if ([list3.name isEqualToString:@"设置"])
        {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            HLTSetViewController * set = [[HLTSetViewController alloc] init];
            set.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:set animated:NO];
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
            [shareParams SSDKSetupShareParamsByText:@"正合app,与医生在线交流"
                                             images:[UIImage imageNamed:@"512"]
                                                url:[NSURL URLWithString:dic[@"url"]]
                                              title:@"正合医疗"
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
