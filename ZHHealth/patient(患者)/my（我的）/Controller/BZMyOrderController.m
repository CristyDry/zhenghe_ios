//
//  BZMyOrderController.m
//  ZHHealth
//
//  Created by pbz on 15/12/30.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZMyOrderController.h"
#import "BZOrderCell.h"
#import "BZAllOrderModel.h"
#import "BZPayController.h"
#import "BZOrderDetailController.h"
@interface BZMyOrderController ()<UITableViewDelegate,UITableViewDataSource,BZOrderCellDelegate>
@property (nonatomic,strong)  UIButton *startBtn;
@property (nonatomic,strong)  UIView *colorLine;
@property (nonatomic,strong)  UIButton *allBtn;
@property (nonatomic,strong)  UITableView *tableView;
@property (nonatomic,strong)  LoginResponseAccount *account;
@property (nonatomic,strong)  NSMutableArray *allOrderMedolArray;
@property (nonatomic,strong)  NSMutableArray *allOrderModelArrayCopy;


@end

@implementation BZMyOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    _account = [LoginResponseAccount decode];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addLeftBackBtn];
    self.title = @"我的订单";
    [self setCustomUI];
    [self initTableView];
    // 请求全部订单数据
    [self requestAllOrderInfos];
    
}
// 左边的返回按钮
-(void)addLeftBackBtn
{
    float width = 17;
    float height = 17;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    UIImage *image = [UIImage imageNamed:@"arrow"];
    
    [button setBackgroundImage:image forState:0];
    [button setEnlargeEdgeWithTop:10 right:20 bottom:0 left:20];
    [button addTarget:self action:@selector(backLeftNavItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
}
-(void)backLeftNavItemAction{
    // 跳转到根控制器
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.tabBarController.selectedIndex = 3;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [self requestAllOrderInfos];
}
// 请求全部订单数据
- (void)requestAllOrderInfos{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"patientId"] = _account.Id;
    args[@"status"] = @"";
    __weak typeof(self) weakSeaf = self;
    [httpUtil doPostRequest:@"api/orderApiController/orderList" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            weakSeaf.allOrderMedolArray = [BZAllOrderModel mj_objectArrayWithKeyValuesArray:responseMd.response];
            NSMutableArray *allOrderModelArrayCopy = [NSMutableArray arrayWithArray:weakSeaf.allOrderMedolArray];
            weakSeaf.allOrderModelArrayCopy = allOrderModelArrayCopy;
            [self.tableView reloadData];
        }
    }];

}
- (void)setCustomUI{
    self.view.backgroundColor = [UIColor colorWithRGB:230 G:230 B:230];
    // 顶部的view
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kMainWidth, 40)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    NSArray *topBtnName = @[@"全部",@"待付款",@"待收货",@"已完成"];
    for (NSInteger i = 0; i < 4; i++) {
        UIButton *topBtn = [[UIButton alloc] initWithFrame:CGRectMake(i * kMainWidth * 0.25, 0, kMainWidth * 0.25, topView.bounds.size.height - 2)];
        topBtn.tag = i + 1;
        [topBtn setTitle:topBtnName[i] forState:UIControlStateNormal];
        [topBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [topBtn setTitleColor:kNavigationBarColor forState:UIControlStateSelected];
        [topBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:topBtn];
        if (i == 0) {
            topBtn.selected = YES;
            _allBtn = topBtn;
        }
    }
    UIView *colorLine = [[UIView alloc] initWithFrame:CGRectMake(10, topView.bounds.size.height - 2, kMainWidth * 0.25 - 20, 2)];
    colorLine.backgroundColor = kNavigationBarColor;
    [topView addSubview:colorLine];
    _colorLine = colorLine;
    
    

    
}

- (void)topBtnClick:(UIButton *) topBtn{
    _allBtn.selected = NO;
    if(topBtn!=self.startBtn){
        
        self.startBtn.selected=NO;
        
        self.startBtn=topBtn;
        
    }
    self.startBtn.selected=YES;
    
    switch (topBtn.tag) {
        case 1:
        {// 点击全部
            _colorLine.x_wcr = 10;
            _allOrderModelArrayCopy = [_allOrderMedolArray mutableCopy];
            [self.tableView reloadData];
        }
            break;
        case 2:
        {// 待付款
            [_allOrderModelArrayCopy removeAllObjects];
            _colorLine.x_wcr = kMainWidth * 0.25 + 10;
            for (BZAllOrderModel *noPayModel in _allOrderMedolArray) {
                if ([noPayModel.status isEqualToString:@"1"]) {
                    [_allOrderModelArrayCopy addObject:noPayModel];
                    [self.tableView reloadData];
                }
            }
        }
            break;
        case 3:
        {// 待收货
            _colorLine.x_wcr = kMainWidth * 0.5 + 10;
            [_allOrderModelArrayCopy removeAllObjects];
            for (BZAllOrderModel *noPayModel in _allOrderMedolArray) {
                if ([noPayModel.status isEqualToString:@"2"] || [noPayModel.status isEqualToString:@"3"]) {
                    [_allOrderModelArrayCopy addObject:noPayModel];
                }
            }
            [self.tableView reloadData];

        }
            break;
        case 4:
        {// 已完成
            _colorLine.x_wcr = kMainWidth * 0.75 + 10;
            [_allOrderModelArrayCopy removeAllObjects];
            for (BZAllOrderModel *noPayModel in _allOrderMedolArray) {
                if ([noPayModel.status isEqualToString:@"4"]) {
                    [_allOrderModelArrayCopy addObject:noPayModel];
                    
                }
            }
            [self.tableView reloadData];

        }
            break;
            
        default:
            break;
    }

}

- (void) initTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 105, kMainWidth, kMainHeight - 105) style:UITableViewStylePlain];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:tableView];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _allOrderModelArrayCopy.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 创建可重用cell
    NSString *reuseID = [NSString stringWithFormat:@"orderCell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    BZOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[BZOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    
    // 给cell内部子控件赋值
    // 取出模型
    cell.allOrderModel = self.allOrderModelArrayCopy[indexPath.row];
    cell.delegate = self;
    // 返回cell
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return kMainWidth * 0.32 + 77;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BZAllOrderModel *orderModel = self.allOrderModelArrayCopy[indexPath.row];
    BZOrderDetailController *orderDetailVC = [[BZOrderDetailController alloc] init];
    orderDetailVC.orderModel = orderModel;
    [self.navigationController pushViewController:orderDetailVC animated:YES];

}

#pragma mark - 跳转到支付界面
- (void)pushToPayViewController:(BZAllOrderModel *)orderModel{
    if ([orderModel.status isEqualToString:@"1"]) {
        BZPayController *payVC = [[BZPayController alloc] init];
        payVC.count = [NSString stringWithFormat:@"共%ld件",(unsigned long)orderModel.items.count];
        payVC.orderID = orderModel.ID;
        payVC.orderNo = orderModel.parentOrderNo;
        payVC.totalCost = [NSString stringWithFormat:@"%@",orderModel.totalAmount];
        [self.navigationController pushViewController:payVC animated:YES];
        
    }else if ([orderModel.status isEqualToString:@"3"]){
        // 确定收货
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否要确认收货" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableDictionary *args = [NSMutableDictionary dictionary];
            args[@"num"] = orderModel.ID;
            [httpUtil doPostRequest:@"api/orderApiController/gotProduct" args:args targetVC:self response:^(ResponseModel *responseMd) {
                if (responseMd.isResultOk) {
                     [self requestAllOrderInfos];
                }
            }];
        }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
// 取消订单
- (void)cancelOeder:(BZAllOrderModel *)orderModel{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否要取消订单，取消后不可恢复" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *args = [NSMutableDictionary dictionary];
        args[@"id"] = orderModel.ID;
        [httpUtil doPostRequest:@"api/orderApiController/cancelOrder" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                [self requestAllOrderInfos];
            }
        }];
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}



@end
