//
//  BZDoctorListController.m
//  ZHHealth
//
//  Created by pbz on 15/12/28.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZDoctorListController.h"
#import "BZDoctorModel.h"
#import "WcrDoctorCell.h"
#import "BZAddressModel.h"
#import "BZEnsureOrderController.h"
#import "WcrEditAddressViewController.h"
@interface BZDoctorListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)  NSMutableArray *myDoctorModelArray;
@property (nonatomic,strong)  UITableView *tableView;
@end

@implementation BZDoctorListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addLeftBackBtn];
    self.title = @"选择医生";
    // 请求我的医生数据
    [self requestMyDoctorInfos];
    [self initTableView];
}
// 取消按钮
- (void)addLeftBackBtn{
    float width = 50;
    float height = 50;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    [button setTitle:@"取消" forState:UIControlStateNormal];
//    [button setEnlargeEdgeWithTop:10 right:20 bottom:0 left:20];
    [button addTarget:self action:@selector(backLeftNavItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
}
-(void)backLeftNavItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}
// 请求我的医生数据
- (void)requestMyDoctorInfos{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    LoginResponseAccount *account = [LoginResponseAccount decode];
    args[@"id"] = account.Id;
    __weak typeof(self) weakSeaf = self;
    [httpUtil doPostRequest:@"api/ZhengheDoctor/myDoctor" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            weakSeaf.myDoctorModelArray = [BZDoctorModel mj_objectArrayWithKeyValuesArray:responseMd.response];
            [weakSeaf.tableView reloadData];
        }
    }];
}
- (void)initTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainWidth, kMainHeight) style:UITableViewStylePlain];
    _tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:tableView];
}

#pragma mark - tableViewDelegate 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _myDoctorModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 创建可重用cell
    static NSString *reuseID = @"doctorCell";
    WcrDoctorCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[WcrDoctorCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
    }
    
    // 给cell内部子控件赋值
    cell.doctorModel = _myDoctorModelArray[indexPath.row];
    
    // 返回cell
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     BZDoctorModel *doctorModel = _myDoctorModelArray[indexPath.row];
    if (_isAddToShoppingcart == YES) {
        // 加入购物车
        if ([_delegate respondsToSelector:@selector(pushBZProductDetailVCWithDoctorID:)]) {
            [_delegate pushBZProductDetailVCWithDoctorID:doctorModel.ID];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        // 立即购买
        if ([BZAddressModel isAddress]) {
            BZEnsureOrderController *ensureOrderVC = [[BZEnsureOrderController alloc] init];
            ensureOrderVC.doctorID = doctorModel.ID;
            ensureOrderVC.isFormAddress = NO;
            [self.navigationController pushViewController:ensureOrderVC animated:YES];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有设置收货地址，请点击这里设置!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 跳到新建地址界面
                WcrEditAddressViewController *editVC = [[WcrEditAddressViewController alloc]init];
                editVC.isFromCell = NO;
                [self.navigationController pushViewController:editVC animated:YES];
            }];
            [alert addAction:cancelAction];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}


@end
