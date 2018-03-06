//
//  MedicineViewController.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/10.
//  Copyright © 2015年 U1KJ. All rights reserved.
//
#import "MedicineViewController.h"

#import "WcrFunctionListCell.h"
#import "WcrFunction.h"

#import "WcrDoctor.h"
#import "WcrDoctorCell.h"
#import "FindDoctorViewController.h"
#import "BZProfessorDetailViewController.h"
#import "WCRExpertController.h"
#import "WCRScanViewController.h"
#import "ViewModel.h"
#import "BZHealthShopViewController.h"

@interface MedicineViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *functions;

@property (nonatomic, strong) NSArray *professors; // 专家数组

@property (nonatomic, strong) ViewModel *viewModel;


@end

@implementation MedicineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 请求专家数据
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self resquestViewInfos];

    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}
// 请求专家数据
- (void)resquestProfessorsInfos{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    [httpUtil doPostRequest:@"api/ZhengheDoctor/expertRecommend" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            
            weakSelf.professors = [BZDoctorModel mj_objectArrayWithKeyValuesArray:responseMd.response];
            // 添加一个tableView
            [self addTableView];
        }
    }];
}

// 请求专家数据
- (void)resquestViewInfos{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    [httpUtil loadDataPostWithURLString:@"api/ZhengheView/view" args:args response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            [kUserDefaults setBool:NO forKey:@"viewAll"];
            [kUserDefaults setBool:NO forKey:@"viewDoc"];
            [kUserDefaults setBool:NO forKey:@"viewInfo"];
            [kUserDefaults setBool:NO forKey:@"viewMall"];
            [kUserDefaults setBool:NO forKey:@"viewDocLogin"];

            ViewModel *viewModel = [ViewModel mj_objectWithKeyValues:responseMd.response];
            if([viewModel.viewInfo isEqualToString:@"1"]){
                [kUserDefaults setBool:YES forKey:@"viewInfo"];
            }
            if([viewModel.view isEqual: @"1"]){
                [kUserDefaults setBool:YES forKey:@"viewAll"];
            }else if([viewModel.view isEqual: @"2"]){
                [kUserDefaults setBool:NO forKey:@"viewAll"];
                [kUserDefaults setBool:YES forKey:@"viewDoc"];
            }else{
                [kUserDefaults setBool:NO forKey:@"viewAll"];
            }
            if([viewModel.viewMall isEqual: @"1"]){
                [kUserDefaults setBool:YES forKey:@"viewMall"];
            }
            if([viewModel.viewDocLogin isEqual: @"1"]){
                [kUserDefaults setBool:YES forKey:@"viewDocLogin"];
            }
            if([viewModel.viewOnlinePay isEqual: @"1"]){
                [kUserDefaults setBool:YES forKey:@"viewOnlinePay"];
            }
            
        }
        if([kUserDefaults boolForKey:@"viewAll"]){
            _functions = [WcrFunction createObjALL];
            [self resquestProfessorsInfos];
        }else{
            
            if([kUserDefaults boolForKey:@"viewDoc"]){
                _functions = [WcrFunction createObjDoc];
                //显示商城
                if([kUserDefaults boolForKey:@"viewMall"]){
                    [_functions addObject:[WcrFunction getMallFunc]];
                }
                [self resquestProfessorsInfos];
            }else{
                _functions = [WcrFunction createObj];
                //显示商城
                if([kUserDefaults boolForKey:@"viewMall"]){
                    [_functions addObject:[WcrFunction getMallFunc]];
                }
                [self addTableView];
                
            }
            
        }
    }];
   
    
}

// 添加一个tableView
- (void)addTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kMainWidth, kMainHeight - 84) style:UITableViewStyleGrouped]; // 多分区的话要设置
//    [self initializationTableViewWithTableView:_tableView];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, 0.1f)];
}
#pragma mark - Table View Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_professors.count==0){
        return 1;
    }
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _functions.count;
    }else {
        return _professors.count;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *cellIdentifier = @"functionCell";
        WcrFunctionListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[WcrFunctionListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.function = _functions[indexPath.row];
        return cell;
    }else {
        
        NSString *cellIdentifier = @"doctorCell";
        WcrDoctorCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[WcrDoctorCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.doctorModel = _professors[indexPath.row];
        return cell;
    }
}

#pragma mark - Table View Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kWcrFunctionCellHeight;
    }else {
        return kWcrDoctorCellHeight;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

// 分区头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1f;
    }
    return 60.0f;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }else {
        CGFloat height = 60.0f;
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, height)];
        bgView.backgroundColor = [UIColor clearColor];
        
        CGFloat heightOfWV = 40.0f;
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, height - heightOfWV, kMainWidth, heightOfWV)];
        whiteView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kBorder, 0, 250, heightOfWV)];
        label.text = @"专家推荐";
        label.textColor = kBlackColor;
        [whiteView addSubview:label];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(kBorder, label.maxY_wcr - 1, kMainWidth - kBorder, 1)];
        line.backgroundColor = KLineColor;
        [whiteView addSubview:line];
        
        [bgView addSubview:whiteView];
        
        return bgView;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        WcrFunctionListCell *cell = (WcrFunctionListCell*)[tableView cellForRowAtIndexPath:indexPath];
        if ([cell.function.name isEqualToString:@"健康咨询"]) {
            FindDoctorViewController *findVC  = [[FindDoctorViewController alloc]init];
            findVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:findVC animated:YES];
        }else if ([cell.function.name isEqualToString:@"专业咨询"]) {
            WCRExpertController *expertVC = [[WCRExpertController alloc]init];
            expertVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:expertVC animated:YES];
        }else if ([cell.function.name isEqualToString:@"扫一扫"]) {
            WCRScanViewController *scanVC = [[WCRScanViewController alloc]init];
            scanVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:scanVC animated:YES];
        }else if ([cell.function.name isEqualToString:@"健康商城"]){
            
            BZHealthShopViewController *healthShopVC = [[BZHealthShopViewController alloc] init];
            healthShopVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:healthShopVC animated:YES];
        }
        
    }else {
        // 医生详情页
        BZProfessorDetailViewController *productDetailVC = [[BZProfessorDetailViewController alloc]init];
        productDetailVC.hidesBottomBarWhenPushed = YES;
        productDetailVC.doctor = _professors[indexPath.row];
        [self.navigationController pushViewController:productDetailVC animated:YES];
        
    }
    
}


@end
