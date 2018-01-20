//
//  BZOrderDetailController.m
//  ZHHealth
//
//  Created by pbz on 16/1/5.
//  Copyright © 2016年 U1KJ. All rights reserved.
//

#import "BZOrderDetailController.h"
#import "WcrAddressViewController.h"
#import "BZShoppingCartModelSelected.h"
#import "BZShoppingCartModel.h"
#import "BZProductListController.h"
#import "BZPayController.h"
#import "KxMenu.h"

@interface BZOrderDetailController ()
@property (nonatomic,strong)  UIView *secondView1;
@property (nonatomic,strong)  UIView *secondView2;
@property (nonatomic,strong)  UIImageView *picView;
@property (nonatomic,strong)  UILabel *titleLabel;
@property (nonatomic,strong)  UILabel *standenLabel;
@property (nonatomic,strong)  UIImageView *picView1;
@property (nonatomic,strong)  UIImageView *picView2;
@property (nonatomic,strong)  NSMutableArray *shoppingCartSelectA;
@property (nonatomic,strong)  NSString *totalCount;//商品总件数
@property (nonatomic,strong)  NSString *yunfeiCost;
@end

@implementation BZOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 设置导航栏
    [self setNavigation];
    [self setCustomUI];
}
// 设置导航栏
- (void)setNavigation{
    [self addLeftBackItem];
    [self setTitle];
    // 右边按钮
    UIButton *rightBarButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainWidth - 30, 0, 30, 5)];
    rightBarButton.contentMode = UIViewContentModeScaleAspectFit;
    [rightBarButton setBackgroundImage:[UIImage imageNamed:@"iconfont-gengduo-2@2x"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [rightBarButton addTarget:self action:@selector(showRightMenu:) forControlEvents:UIControlEventTouchUpInside];
}
// 右边按钮菜单
- (void)showRightMenu:(UIButton *)sender{
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
    
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(kMainWidth - 90, 64, 90, 0)
                 menuItems:menuItems];
    [KxMenu setTintColor:[UIColor whiteColor]];
    
}
- (void) pushMenuItem:(KxMenuItem *)sender
{
    
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

// 设置title
- (void)setTitle{
    if ([_orderModel.status isEqualToString:@"1"]) {
        
         self.title = @"等待付款";
        
    }else if ([_orderModel.status isEqualToString:@"2"] || [_orderModel.status isEqualToString:@"3"]){
        
         self.title = @"等待收货";
        
    }else if ([_orderModel.status isEqualToString:@"4"]){
        
         self.title = @"已完成";
        
    }else if ([_orderModel.status isEqualToString:@"5"]){
        
         self.title = @"已取消";
        
    }
}
- (void)setCustomUI{
    // scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kMainWidth, kMainHeight - 108)];
    [self.view addSubview:scrollView];
    scrollView.backgroundColor = [UIColor colorWithRGB:230 G:230 B:230];
    
    // 订单号
    UIView *orderNumView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, 40)];
    [scrollView addSubview:orderNumView];
    UILabel *orderNum = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kMainWidth, 40)];
    [orderNumView addSubview:orderNum];
    orderNumView.backgroundColor = [UIColor whiteColor];
    orderNum.textAlignment = 0;
    orderNum.text = [NSString stringWithFormat:@"订单号：%@",_orderModel.parentOrderNo];
    

    // 快递单号
    UIView *expressNumView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kMainWidth, 40)];
    expressNumView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:expressNumView];
    UILabel *expressNum = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kMainWidth, 40)];
    [expressNumView addSubview:expressNum];
    expressNum.textAlignment = 0;
    expressNum.text = [NSString stringWithFormat:@"%@单号：%@",_orderModel.expressName,_orderModel.expressNo];
    if ([_orderModel.status isEqualToString:@"1"] || [_orderModel.status isEqualToString:@"2"] ||[_orderModel.status isEqualToString:@"5"]) {
        expressNumView.hidden = YES;
    }else{
        expressNumView.hidden = NO;
    }
    
    // 第一个view
    CGFloat marginX = 20;
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(expressNumView.frame) + 10, kMainWidth, kMainWidth * 0.3)];
    firstView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:firstView];
    if ([_orderModel.status isEqualToString:@"1"] || [_orderModel.status isEqualToString:@"2"] ||[_orderModel.status isEqualToString:@"5"]) {
        firstView.y_wcr = CGRectGetMaxY(orderNumView.frame)+ 10;
    }else{
        firstView.y_wcr = CGRectGetMaxY(expressNumView.frame)+ 10;
    }
    CGFloat firstH = firstView.bounds.size.height * 0.5 - 20;
    UIView *iconView = [[UIView alloc] initWithFrame:CGRectMake(marginX, 10, kMainWidth * 0.5 - marginX, firstH)];
    [firstView addSubview:iconView];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iconView.bounds.size.height , iconView.bounds.size.height)];
    icon.layer.cornerRadius = iconView.bounds.size.height * 0.5;
    icon.layer.masksToBounds = YES;
    icon.image = [UIImage imageNamed:@"头像"];
    [iconView addSubview:icon];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame) + 5, 0, iconView.bounds.size.width - icon.bounds.size.width, iconView.bounds.size.height)];
    [iconView addSubview:nameLabel];
    nameLabel.text = _orderModel.name;
    
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame), 10, kMainWidth * 0.5, firstH)];
    [firstView addSubview:phoneView];
    UIImageView *phonePic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, iconView.bounds.size.height - 10, iconView.bounds.size.height - 10)];
    phonePic.contentMode = UIViewContentModeScaleAspectFit;
    phonePic.image = [UIImage imageNamed:@"iconfont-phone-2"];
    [phoneView addSubview:phonePic];
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame) + 5, 0, iconView.bounds.size.width - icon.bounds.size.width, iconView.bounds.size.height)];
    [phoneView addSubview:phoneLabel];
    phoneLabel.text = _orderModel.phone;
    
    UILabel *addressLabel = [[UILabel alloc ]initWithFrame:CGRectMake(marginX, CGRectGetMaxY(iconView.frame) + 10, kMainWidth - marginX - 20, firstH)];
    [firstView addSubview:addressLabel];
    addressLabel.text = _orderModel.address;
    addressLabel.numberOfLines = 0;
    addressLabel.textColor = [UIColor grayColor];
    addressLabel.font = [UIFont systemFontOfSize:14];
    
    
    // 取出选中的产品模型
    NSMutableArray *shoppingCartSelectA = [BZShoppingCartModelSelected decode];
    _shoppingCartSelectA = shoppingCartSelectA;
    // 第二个view
    UIView *secondView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(firstView.frame) + 10, kMainWidth, kMainWidth * 0.2)];
    secondView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:secondView];
    [self setSecondView:secondView];
    
    
    
    // 第三个view
    UIView *thridView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(secondView.frame) + 10, kMainWidth, kMainWidth * 0.2)];
    thridView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:thridView];
    
    UILabel *productCost = [[UILabel alloc ]initWithFrame:CGRectMake(marginX, 0, 70, thridView.bounds.size.height * 0.5)];
    [thridView addSubview:productCost];
    productCost.text = @"商品金额";
    productCost.textAlignment = 0;
    productCost.textColor = [UIColor grayColor];
    productCost.font = [UIFont systemFontOfSize:14];
    
    UILabel *yunfei = [[UILabel alloc ]initWithFrame:CGRectMake(marginX, CGRectGetMaxY(productCost.frame), 70, thridView.bounds.size.height * 0.5)];
    [thridView addSubview:yunfei];
    yunfei.text = @"运费";
    yunfei.textAlignment = 0;
    yunfei.textColor = [UIColor grayColor];
    yunfei.font = [UIFont systemFontOfSize:14];
    
    UILabel *productCostNum = [[UILabel alloc ]initWithFrame:CGRectMake(kMainWidth - 100, 0, 80, thridView.bounds.size.height * 0.5)];
    [thridView addSubview:productCostNum];
    
    productCostNum.text = [NSString stringWithFormat:@"￥%@",_orderModel.totalAmount];
    productCostNum.textAlignment = NSTextAlignmentRight;
    productCostNum.textColor = [UIColor redColor];
    productCostNum.font = [UIFont systemFontOfSize:14];
    
    UILabel *yunfeiNum = [[UILabel alloc ]initWithFrame:CGRectMake(kMainWidth - 100, CGRectGetMaxY(productCostNum.frame), 80, thridView.bounds.size.height * 0.5)];
    [thridView addSubview:yunfeiNum];
    _yunfeiCost = @"";
    yunfeiNum.text = [NSString stringWithFormat:@"+ ￥%@",_yunfeiCost];
    
    yunfeiNum.textAlignment = NSTextAlignmentRight;
    yunfeiNum.textColor = [UIColor redColor];
    yunfeiNum.font = [UIFont systemFontOfSize:14];
    
    scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(thridView.frame));
    
    [self setBottomView];
}
// 底部的view
- (void)setBottomView{
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kMainHeight - 44, kMainWidth, 44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    // 底部栏的子控件
    //  取消订单
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainWidth - 180, 5, 80, bottomView.bounds.size.height - 10)];
    [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.layer.borderColor = [UIColor colorWithRGB:230 G:230 B:230].CGColor;
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.cornerRadius = 4;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [bottomView addSubview:cancelBtn];
    
    // 去支付
    UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainWidth - 90, 5,  80, bottomView.bounds.size.height - 10)];
    [payBtn addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
    payBtn.backgroundColor = kNavigationBarColor;
    [payBtn setTitle:@"去支付" forState:UIControlStateNormal];
    payBtn.layer.borderColor = [UIColor colorWithRGB:230 G:230 B:230].CGColor;
    payBtn.layer.borderWidth = 1;
    payBtn.layer.cornerRadius = 4;
    payBtn.layer.masksToBounds = YES;
    payBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomView addSubview:payBtn];
    [self.view addSubview:bottomView];
    
    if ([_orderModel.status isEqualToString:@"1"]) {
        cancelBtn.hidden = NO;
        [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        payBtn.hidden = NO;
        payBtn.enabled = YES;
        payBtn.backgroundColor = kNavigationBarColor;
        [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [payBtn setTitle:@"去支付" forState:UIControlStateNormal];
        
    }else if ([_orderModel.status isEqualToString:@"2"]){
        cancelBtn.hidden = YES;
        payBtn.hidden = NO;
        payBtn.backgroundColor = [UIColor lightGrayColor];
        [payBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        payBtn.enabled = NO;
        
    }else if ([_orderModel.status isEqualToString:@"3"]){
        cancelBtn.hidden = YES;
        payBtn.hidden = NO;
        payBtn.enabled = YES;
        payBtn.backgroundColor = kNavigationBarColor;
        [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [payBtn setTitle:@"确认收货" forState:UIControlStateNormal];
    }else if ([_orderModel.status isEqualToString:@"4"]){
        cancelBtn.hidden = YES;
        payBtn.hidden = NO;
        payBtn.backgroundColor = [UIColor clearColor];
        payBtn.enabled = NO;
        [payBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [payBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else if ([_orderModel.status isEqualToString:@"5"]){
        cancelBtn.hidden = YES;
        payBtn.hidden = NO;
        payBtn.enabled = NO;
        payBtn.backgroundColor = [UIColor clearColor];
        [payBtn setTitle:@"订单已取消" forState:UIControlStateNormal];
        [payBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
    }

}
// 点击取消订单按钮
- (void)cancelOrder{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否要取消订单，取消后不可恢复" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *args = [NSMutableDictionary dictionary];
        args[@"id"] = _orderModel.ID;
        [httpUtil doPostRequest:@"api/orderApiController/cancelOrder" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
// 点击去支付按钮
- (void)payClick:(UIButton *) btn{
    if ([btn.titleLabel.text isEqualToString:@"去支付"]) {
        // 去支付
        BZPayController *payVC = [[BZPayController alloc] init];
        payVC.expenseCost = _yunfeiCost;
        [self.navigationController pushViewController:payVC animated:YES];
        payVC.count = [NSString stringWithFormat:@"共%ld件",_orderModel.items.count];
        payVC.orderID = _orderModel.ID;
        payVC.orderNo = _orderModel.parentOrderNo;
        payVC.totalCost = [NSString stringWithFormat:@"%@",_orderModel.totalAmount];

    }else if ([btn.titleLabel.text isEqualToString:@"确认收货"]){
        // 确定收货
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否要确认收货" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableDictionary *args = [NSMutableDictionary dictionary];
            args[@"num"] = _orderModel.ID;
            [httpUtil doPostRequest:@"api/orderApiController/gotProduct" args:args targetVC:self response:^(ResponseModel *responseMd) {
                if (responseMd.isResultOk) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
           }
}
// 设置第二个view的数据
- (void)setSecondView:(UIView *)secondView{
    // secondView1
    UIView *secondView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth * 0.6, kMainWidth * 0.2)];
    [secondView addSubview:secondView1];
    _secondView1 = secondView1;
    _secondView1.hidden = YES;
    
    UIImageView *picView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, secondView1.height_wcr , secondView1.height_wcr - 10)];
    _picView = picView;
    [secondView1 addSubview:picView];
    _picView = picView;
    
    CGFloat picViewMaxX = CGRectGetMaxX(picView.frame);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(picViewMaxX + 20, 0, kMainWidth - picViewMaxX - 120, kMainWidth * 0.1)];
    [secondView1 addSubview:titleLabel];
    titleLabel.textAlignment = 0;
    titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel = titleLabel;
    
    UILabel *standenLabel = [[UILabel alloc] initWithFrame:CGRectMake(picViewMaxX + 20, CGRectGetMaxY(titleLabel.frame), kMainWidth - picViewMaxX - 120, kMainWidth * 0.1)];
    [secondView1 addSubview:standenLabel];
    standenLabel.textAlignment = 0;
    standenLabel.font = [UIFont systemFontOfSize:14];
    _standenLabel = standenLabel;
    
    
    // secondView2
    UIView *secondView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth * 0.6, kMainWidth * 0.2)];
    [secondView addSubview:secondView2];
    _secondView2 = secondView2;
    _secondView2.hidden = YES;
    
    UIImageView *picView1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, secondView1.height_wcr , secondView1.height_wcr  - 10)];
    _picView1 = picView1;
    [secondView2 addSubview:picView1];
    UIImageView *picView2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(picView1.frame) + 10, 5, secondView1.height_wcr , secondView1.height_wcr  - 10)];
    _picView2 = picView2;
    [secondView2 addSubview:picView2];
    
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainWidth - 120, 0, 70, secondView.bounds.size.height)];
    [secondView addSubview:countLabel];
    countLabel.textAlignment = 2;
    int sum = 0;
    int count = 0;
    for (productInfos *productInfos in _orderModel.items) {
        count = [productInfos.count intValue];
        sum = sum + count;
        countLabel.text = [NSString stringWithFormat:@"共%d件",sum];
    }
    _totalCount = countLabel.text;
    // 右边的小箭头
    CGFloat width = 20.0f;
    CGFloat height = secondView.bounds.size.height;
    CGFloat xPoint = kMainWidth - 40.0f;
    CGFloat yPoint = 0;
    UIButton *arrowIV = [[UIButton alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    arrowIV.backgroundColor = [UIColor clearColor];
    arrowIV.contentMode = UIViewContentModeScaleAspectFit;
    [arrowIV setImage:[UIImage imageNamed:@"后退-拷贝-2"] forState:UIControlStateNormal];
    [arrowIV addTarget:self action:@selector(productList) forControlEvents:UIControlEventTouchUpInside];
    [secondView addSubview:arrowIV];
    
    if (_orderModel.items.count == 1) {
        _secondView1.hidden = NO;
        _secondView2.hidden = YES;
        _titleLabel.text = _orderModel.items[0].productName;
        _standenLabel.text = _orderModel.items[0].standard;
        [_picView sd_setImageWithURL:[NSURL URLWithString:_orderModel.items[0].productPic] placeholderImage:[UIImage imageNamed:@"ic_error"]];
        
    }else if (_orderModel.items.count > 1){
        _secondView1.hidden = YES;
        _secondView2.hidden = NO;
        [_picView1 sd_setImageWithURL:[NSURL URLWithString:_orderModel.items[0].productPic] placeholderImage:[UIImage imageNamed:@"ic_error"]];
        [_picView2 sd_setImageWithURL:[NSURL URLWithString:_orderModel.items[1].productPic] placeholderImage:[UIImage imageNamed:@"ic_error"]];
    }
}

// 产品清单
- (void)productList{
    BZProductListController *productListVC = [[BZProductListController alloc] init];
    productListVC.orderModel = _orderModel;
    productListVC.totalCount = _totalCount;
    productListVC.isFormOrder = YES;
    [self.navigationController pushViewController:productListVC animated:YES];
}
@end
