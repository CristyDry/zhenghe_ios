//
//  WCRDoctorDetailController.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/17.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#define kSectionHeader 50.0

#import "WCRDoctorDetailController.h"

#import "WcrDoctorCell.h"

#import "WCRAuthenticationController.h"

#import "KxMenu.h"

#import "RCDChatViewController.h"
@interface WCRDoctorDetailController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WCRDoctorDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftBackItem];
    
    [self setNavigationBarProperty];
    
    self.title = @"医生详情";
    
    [self customDetailUI];
    
    [self addRightBarButton];
}

-(void)customDetailUI {

    CGFloat heightOfBtn = 40;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, kMainHeight - heightOfBtn) style:UITableViewStyleGrouped];
    [self initializationTableViewWithTableView:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // 底部view
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kMainHeight - heightOfBtn, kMainWidth, heightOfBtn)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    // 申请咨询
    UIButton *requestBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, heightOfBtn)];
    [requestBtn buttonWithTitle:@"申请咨询" andTitleColor:kBackgroundColor andBackgroundImageName:nil andFontSize:KFont - 3];
    requestBtn.layer.cornerRadius = 4;
    requestBtn.clipsToBounds = YES;
    [requestBtn addTarget:self action:@selector(applyAction)];
    requestBtn.backgroundColor = [UIColor colorWithHexString:@"05b7c3"];
    [bottomView addSubview:requestBtn];
    
    // 图文咨询
    UIButton *consultBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 5, kMainWidth * 0.5 - 60, heightOfBtn - 10)];
    [consultBtn buttonWithTitle:@"图文咨询" andTitleColor:kBackgroundColor andBackgroundImageName:nil andFontSize:KFont - 3];
    consultBtn.layer.cornerRadius = 4;
    consultBtn.clipsToBounds = YES;
    [consultBtn addTarget:self action:@selector(consult)];
    consultBtn.backgroundColor = [UIColor colorWithHexString:@"05b7c3"];
    [bottomView addSubview:consultBtn];
    // 删除医生
    UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(kMainWidth * 0.5 + 30, 5, kMainWidth * 0.5 - 60, heightOfBtn - 10)];
    [deleteBtn buttonWithTitle:@"删除医生" andTitleColor:kBackgroundColor andBackgroundImageName:nil andFontSize:KFont - 3];
    deleteBtn.layer.cornerRadius = 4;
    deleteBtn.clipsToBounds = YES;
    [deleteBtn addTarget:self action:@selector(deleteDoctor)];
    deleteBtn.backgroundColor = [UIColor colorWithHexString:@"05b7c3"];
    [bottomView addSubview:deleteBtn];
    if (_isFormMyDoctor == YES) {
        requestBtn.hidden = YES;
        consultBtn.hidden = NO;
        deleteBtn.hidden = NO;
    }else{
        requestBtn.hidden = NO;
        consultBtn.hidden = YES;
        deleteBtn.hidden = YES;
    }
}
#pragma mark -  申请咨询
-(void)applyAction {
    // 判断是否已经登录
    
    if ([LoginResponseAccount isLogin]) {
        NSMutableDictionary *args = [NSMutableDictionary dictionary];
        LoginResponseAccount *account = [LoginResponseAccount decode];
        args[@"doctorId"] = _doctor.ID;
        args[@"patientId"] = account.Id;
        [httpUtil doPostRequest:@"api/ZhengheDoctor/applyConsult" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                NSString *status = [responseMd.response objectForKey:@"status"];
                if ([status isEqualToString:@"1"]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该医生已是您好友" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }else{
                    WCRAuthenticationController *authenticationVC = [[WCRAuthenticationController alloc]init];
                    authenticationVC.doctorID = _doctor.ID;
                    [self.navigationController pushViewController:authenticationVC animated:YES];
                }
            }
        }];
    }else{
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];}

}
// 图文咨询
- (void)consult{
    
    RCDChatViewController *conversationVC = [[RCDChatViewController alloc]init];
    conversationVC.conversationType =  ConversationType_PRIVATE;
    conversationVC.targetId = _doctor.ID;
    conversationVC.title =  _doctor.doctor;
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:conversationVC];
    [self presentViewController:nvc animated:YES completion:nil];
}
// 删除医生
- (void)deleteDoctor{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除医生" message:@"同时会将我从对方的列表中删除" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *args = [NSMutableDictionary dictionary];
        LoginResponseAccount *account = [LoginResponseAccount decode];
        args[@"patientId"] = account.Id;
        args[@"doctorId"] = _doctor.ID;
        [httpUtil doPostRequest:@"api/ZhengheDoctor/deleteFriend" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                self.tabBarController.selectedIndex = 1;
                
            }
        }];
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
// 添加addRightBarButton
- (void)addRightBarButton{
    
    UIButton *rightBarButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainWidth - 30, 0, 30, 5)];
    rightBarButton.contentMode = UIViewContentModeScaleAspectFit;
    [rightBarButton setBackgroundImage:[UIImage imageNamed:@"iconfont-gengduo-2@2x"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [rightBarButton addTarget:self action:@selector(showRightMenu:) forControlEvents:UIControlEventTouchUpInside];

}
- (void)showRightMenu:(UIButton *)sender{
    // 盲板背景
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, kMainHeight)];
    bgView.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.5];
    _bgView = bgView;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:bgView];
    UITapGestureRecognizer *tapBgView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBgView)];
    [bgView addGestureRecognizer:tapBgView];
    
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"咨询"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"问诊"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"知识"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"我的"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      ];
    
    [KxMenu showMenuInView:bgView
                  fromRect:CGRectMake(kMainWidth - 90, 64, 90, 0)
                 menuItems:menuItems];
    [KxMenu setTintColor:[UIColor whiteColor]];
    
}
- (void) pushMenuItem:(KxMenuItem *)sender
{
    [self removeBgView];
    
    if ([sender.title isEqualToString:@"咨询"]) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else if ([sender.title isEqualToString:@"问诊"]){
        
        BaseTabBarController *tabBarVC = [BaseTabBarController sharedTabBarController];
        tabBarVC.selectedIndex = 1;
        
    }else if ([sender.title isEqualToString:@"知识"]){
        BaseTabBarController *tabBarVC = [BaseTabBarController sharedTabBarController];
        tabBarVC.selectedIndex = 2;
    }else if ([sender.title isEqualToString:@"我的"]){
        BaseTabBarController *tabBarVC = [BaseTabBarController sharedTabBarController];
        tabBarVC.selectedIndex = 3;
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)removeBgView {
    [_bgView removeFromSuperview];
}
// 另一种addRightBarButton（备用）
- (void)rightBarButton{
    //-(void)addRightBarButton {
    //
    //    UIButton *rightButton = [self addRightBarButtomWithImageName:@"iconfont-gengduo-2"];
    //    [rightButton addTarget:self action:@selector(rightBarButtonAction)];
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    //
    //}
    //
    //-(void)rightBarButtonAction {
    //
    //    // 背景
    //    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, kMainHeight)];
    //    bgView.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.5];
    //    _bgView = bgView;
    //
    //    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    //
    //    [window addSubview:bgView];
    //
    //    UITapGestureRecognizer *tapBgView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBgView)];
    //    [bgView addGestureRecognizer:tapBgView];
    //
    //    // 弹出一个视图
    //    CGFloat width = 100;
    //    CGFloat xPoint = kMainWidth - width - 5.0;
    //    CGFloat height = 150;
    //    CGFloat yPoint = KTopLayoutGuideHeight - 20;
    //
    //    UIView *popView = [[UIView alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    //    UIImage *bgImage = [UIImage imageFileNamed:@"快速导航栏" andType:YES];
    //    popView.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    //    [bgView addSubview:popView];
    //
    //    NSArray *titles = @[@"寻医",@"问诊",@"知识",@"我的"];
    //    xPoint = 0.0;
    //    height = height / 4.0;
    //    yPoint = 10.0;
    //    for(int i = 0; i < titles.count; i++) {
    //
    //        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0.0, yPoint, width, height)];
    //        [button buttonWithTitle:titles[i] andTitleColor:kBlackColor andBackgroundImageName:nil andFontSize:KFont - 4];
    //        [button addTarget:self action:@selector(tabBarTitle:)];
    //        button.backgroundColor = [UIColor whiteColor];
    //        [popView addSubview:button];
    //
    //        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, button.maxY_wcr - 1, width, 1)];
    //        line.backgroundColor = KLineColor;
    //        [popView addSubview:line];
    //
    //        yPoint = button.maxY_wcr;
    //    }
    //
    //    [UIView animateWithDuration:0.5 animations:^{
    //        popView.y_wcr = KTopLayoutGuideHeight + 5.0;
    //    }];
    //
    //}
    //
    //
    //-(void)tabBarTitle:(UIButton*)button {
    //    // [@"寻医",@"问诊",@"知识",@"我的"]
    //    if ([button.titleLabel.text isEqualToString:@"寻医"]) {
    //        NSLog(@"寻医");
    //
    //    }else if ([button.titleLabel.text isEqualToString:@"问诊"]) {
    //        NSLog(@"问诊");
    //
    //    }else if ([button.titleLabel.text isEqualToString:@"知识"]) {
    //
    //    }else if ([button.titleLabel.text isEqualToString:@"我的"]) {
    //
    //    }
    //
    //}
    //
    //-(void)removeBgView {
    //
    //    [_bgView removeFromSuperview];
    //
    //}
}
#pragma mark - Table View Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat xPoint = 20.0;
    CGFloat yPoint = 0.0;
    CGFloat width = kMainWidth - 40.0;
    
    if (indexPath.section == 0) {
        
        WcrDoctorCell *cell = [[WcrDoctorCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.doctorModel = _doctor;
        
        return cell;
        
    }else if(indexPath.section == 1) {
       
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        CGFloat height = [Tools calculateLabelHeight:_doctor.professionalField font:[UIFont systemFontOfSize:KFont - 4] AndWidth:width];
//        CGFloat height = [Tools heightForString:_doctor.professionalField font:[UIFont systemFontOfSize:KFont - 4] andWidth:width];
        height += 40;
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
        lable.text = _doctor.professionalField;
        lable.font = [UIFont systemFontOfSize:KFont - 6];
        lable.textColor = kGrayColor;
        lable.backgroundColor = [UIColor clearColor];
        lable.numberOfLines = 0;
        [cell.contentView addSubview:lable];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else {
        
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        CGFloat height = [Tools calculateLabelHeight:_doctor.intro font:[UIFont systemFontOfSize:KFont - 4] AndWidth:width];
//        CGFloat height = [Tools heightForString:_doctor.intro font:[UIFont systemFontOfSize:KFont - 4] andWidth:width];
        height += 40;
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
        lable.numberOfLines = 0;
        lable.text = _doctor.intro;
        lable.backgroundColor = [UIColor clearColor];
        lable.font = [UIFont systemFontOfSize:KFont - 6];
        lable.textColor = kGrayColor;
        [cell.contentView addSubview:lable];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
}

// 返回行高
-(CGFloat)setCellContentWithText:(NSString*)text{
    
    CGFloat width = kMainWidth - 40.0;
    CGFloat height = [Tools calculateLabelHeight:text font:[UIFont systemFontOfSize:KFont - 4] AndWidth:width];
//    CGFloat height = [Tools heightForString:text font:[UIFont systemFontOfSize:KFont - 4] andWidth:width];
    height += 40 + 20;
    
    return height;
}

#pragma mark - Table View Delegate 
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1f;
    }
    return kSectionHeader;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kWcrDoctorCellHeight;
    }else if (indexPath.section == 1) {
        return [self setCellContentWithText:_doctor.professionalField];
    }else {
        return [self setCellContentWithText:_doctor.intro];
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return nil;
    }else if (section == 1) {
        return [self sectionViewWithText:@"专业领域"];
        
    }else if (section == 2) {
        return [self sectionViewWithText:@"医生简介"];
    }else {
        return nil;
    }
    
}

-(UIView*)sectionViewWithText:(NSString*)text {
    
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, kSectionHeader)];
    sectionView.backgroundColor = [UIColor clearColor];
    
    CGFloat xPoint = 0.0;
    CGFloat yPoint = 10.0f;
    CGFloat width = kMainWidth;
    CGFloat height = sectionView.height_wcr - 10.0;
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [sectionView addSubview:whiteView];
    
    xPoint = kBorder;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    [sectionView addSubview:label];
    
    xPoint = kBorder;
    yPoint = label.maxY_wcr - 1;
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(xPoint, yPoint, kMainWidth, 1)];
    line.backgroundColor = KLineColor;
    [sectionView addSubview:line];
    
    return sectionView;
    
}



@end
