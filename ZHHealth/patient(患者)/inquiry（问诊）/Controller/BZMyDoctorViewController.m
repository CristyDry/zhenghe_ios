//
//  BZMyDoctorViewController.m
//  ZHHealth
//
//  Created by pbz on 15/12/10.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZMyDoctorViewController.h"
#import "WcrDoctorCell.h"
#import "BZRequestTableViewController.h"
#import "RCDChatViewController.h"
#import "WCRDoctorDetailController.h"

@interface BZMyDoctorViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)  UITableView *doctorTableView;
@property (nonatomic,strong)  NSArray *myDocter;

@end

@implementation BZMyDoctorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加一个UITableView
    [self addTableView];
}
- (void)viewWillAppear:(BOOL)animated{
    // 请求数据
    [self resquestMyDoctor];
}
// 请求我的医生数据
- (void)resquestMyDoctor{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    // 取出患者id
    LoginResponseAccount *account = [LoginResponseAccount decode];
    args[@"id"] = account.Id;
    __weak typeof(self) weakSelf = self;
    [httpUtil doPostRequest:@"api/ZhengheDoctor/myDoctor" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {

            weakSelf.myDocter = [BZDoctorModel mj_objectArrayWithKeyValuesArray:responseMd.response];
            [self.doctorTableView reloadData];
            
        }
    }];
}
// 添加一个UITableView
- (void)addTableView{
    UITableView *doctorTableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kMainWidth, kMainHeight - 104) style:UITableViewStyleGrouped];
    _doctorTableView = doctorTableView;// 多分区的话要设置
    [self initializationTableViewWithTableView:doctorTableView];
    doctorTableView.delegate = self;
    doctorTableView.dataSource = self;
    doctorTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, 0.1f)];
}
#pragma mark - UITableView代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_myDocter.count < 1){
        return 1;
    }
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return _myDocter.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        static NSString *cellIdentifier1 = @"requestCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier1];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            // 头像
            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(kBorder, 7, 46, 46)];
            iconView.image = [UIImage imageNamed:@"shape-16"];
            iconView.layer.cornerRadius = iconView.bounds.size.width * 0.5;
            iconView.layer.masksToBounds = YES;
            [cell.contentView addSubview:iconView];
            // 标题
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:20];
            label.frame = CGRectMake(CGRectGetMaxX(iconView.frame) + 20, 0, kMainWidth, 60);
            label.text = @"申请与通知";
            [cell.contentView addSubview:label];
            
        }
        return cell;
    }else{
        static NSString *cellIdentifier = @"doctorCell";
        WcrDoctorCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[WcrDoctorCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.doctorModel = _myDocter[indexPath.row];
        return cell;
        
    }
}

// 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        BZRequestTableViewController *requestTableViewController = [[BZRequestTableViewController alloc] init];
        [self.navigationController pushViewController:requestTableViewController animated:YES];
    }
    else{
        
        BZDoctorModel *doctor = _myDocter[indexPath.row];
        WCRDoctorDetailController *doctorVC = [[WCRDoctorDetailController alloc] init];
        doctorVC.doctor = doctor;
        doctorVC.hidesBottomBarWhenPushed = YES;
        doctorVC.isFormMyDoctor = YES;
        [self.navigationController pushViewController:doctorVC animated:YES];
        
    }
    
}
// 组头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0.0;
    }return 30;
}

// 组头内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return nil;
    }else{
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:KFont - 2];
        label.textColor = kBlackColor;
        label.frame = CGRectMake(30, 0, kMainWidth, 30);
        label.text = @"     我的专家";
        return label;
    }
}

// cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60;
    }
    return kWcrDoctorCellHeight;
}





@end
