//
//  BZPayController.m
//  ZHHealth
//
//  Created by pbz on 15/12/31.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZPayController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "Order.h"
#import "BZAliPayModel.h"
#import "WeixinPayModel.h"
#import "DataSigner.h"
#import "BZMyOrderController.h"
#import "BZHealthShopViewController.h"
@interface BZPayController ()<UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic,strong)  BZAliPayModel  *aliPayModel;
@end

@implementation BZPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRGB:240 G:240 B:240];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addLeftBackBtn];
    self.title = @"收银台";
    [self addRightView];
    [self setTopView];
    [self initTableView];
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
    // 跳到我的订单界面
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    BZMyOrderController *myOrderVC = [[BZMyOrderController alloc] init];
    myOrderVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myOrderVC animated:YES];

}
// 添加右边按钮
- (void)addRightView{
    float width = 80;
    float height = 30;
    UIButton *acontBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    [acontBtn setTitle:[NSString stringWithFormat:@"%@",_count] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:acontBtn];
    self.navigationItem.rightBarButtonItem = leftItem;
}
// 顶部view
- (void)setTopView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kMainWidth, 40)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 40)];
    [topView addSubview:payLabel];
    payLabel.text = @"请支付";
    payLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel *payNum = [[UILabel alloc] initWithFrame:CGRectMake(kMainWidth - 150, 0, 130, 40)];
    [topView addSubview:payNum];
    _expenseCost = @"";
    CGFloat expenseCost = [_expenseCost floatValue];
//    CGFloat totalAmount = [_orderModel.totalAmount intValue];
    CGFloat totalCost = expenseCost + [_totalCost floatValue];
    payNum.text = [NSString stringWithFormat:@"￥ %0.2f",totalCost];
    payNum.textColor = [UIColor redColor];
    payNum.textAlignment = NSTextAlignmentRight;
    
}
- (void)initTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, kMainWidth, kMainHeight - 120) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}
//支付宝支付
- (void)aliPay{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"id"] = _orderID;
    [httpUtil doPostRequest:@"api/orderApiController/aliPay" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            NSString *appScheme = @"FSZHHealth";
            [[AlipaySDK defaultService] payOrder:responseMd.response fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"支付返回：%@",resultDic);
                NSString *status = [resultDic objectForKey:@"resultStatus"];
                if ([status isEqualToString:@"9000"]) {
                    //支付成功
                    [self paySuccess];
                }else{
                    [self payFaile:@"未完成支付"];
                }
                
            }];
        }else{
            [self payFaile:responseMd.msg];
        }
    }];

}
//微信支付
- (void) payWechat{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"id"] = _orderID;
    [httpUtil doPostRequest:@"api/orderApiController/weixin" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            WeixinPayModel *model = [WeixinPayModel mj_objectWithKeyValues:responseMd.response];
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = model.partnerId;
            request.prepayId= model.prepayId;
            request.package = model.packageValue;
            request.nonceStr= model.nonceStr;
            request.timeStamp= [model.timeStamp intValue];
            request.sign= model.sign;
            [WXApi sendReq:request];
        }else{
            [self payFaile:responseMd.msg];
        }
    }];
}

//货到付款支付
- (void) payTrade{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"id"] = _orderID;
    [httpUtil doPostRequest:@"api/orderApiController/trade" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            [self paySuccess];
        }else{
            [self payFaile:responseMd.msg];
        }
    }];
}
//支付成功
- (void)paySuccess{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"恭喜您，支付成功！" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction1 = [UIAlertAction actionWithTitle:@"继续购药" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        BZHealthShopViewController *healthShopVC = [[BZHealthShopViewController alloc] init];
        healthShopVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:healthShopVC animated:YES];
    }];
    UIAlertAction *okAction2 = [UIAlertAction actionWithTitle:@"查看订单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        BZMyOrderController *myOrderVC = [[BZMyOrderController alloc] init];
        myOrderVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myOrderVC animated:YES];
    }];
    [alert addAction:okAction1];
    [alert addAction:okAction2];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//支付失败
- (void)payFaile:(NSString *) msg{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:3];
}
#pragma tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([kUserDefaults boolForKey:@"viewOnlinePay"]){
        //显示在线付款
        return 3;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 创建cell
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    // 赋值
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"开箱验货"];
        cell.textLabel.text = @"在线登记";
        cell.detailTextLabel.text = @"登记商品后，需要门店审核！";
    }else if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"201579103655"];
        cell.textLabel.text = @"支付宝支付";
        cell.detailTextLabel.text = @"推荐安装支付宝客户端的用户使用";
    }else if (indexPath.row == 2){
    
       cell.imageView.image = [UIImage imageNamed:@"u=1000341566,1853476192&fm=21&gp=0@3x"];
        cell.textLabel.text = @"微信支付";
        cell.detailTextLabel.text = @"推荐安装微信5.0以上版本的用户使用";
    }
    cell.accessoryType = UITableViewCellStyleValue1;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    // 返回cell
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0) {
        //货到
        [self payTrade];
    }else if (indexPath.row == 1) {
        //支付宝支付
        [self aliPay];
    }else if (indexPath.row == 2){
        //微信支付
        [self payWechat];
    }
    
}

#pragma mark 监听通知
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //检测是否装了微信软件
    if ([WXApi isWXAppInstalled])
    {
        //监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:@"WXPay" object:nil];
    }
}
#pragma mark - 事件
- (void)getOrderPayResult:(NSNotification *)notification
{
    NSLog(@"userInfo: %@",notification.userInfo);
    
    if ([notification.object isEqualToString:@"success"]){
        [self paySuccess];
    }
    else{
        [self payFaile:@"未完成支付"];
    }
}

#pragma mark 移除通知
- (void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
