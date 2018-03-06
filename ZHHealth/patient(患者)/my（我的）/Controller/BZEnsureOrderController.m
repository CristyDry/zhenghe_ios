//
//  BZEnsureOrderController.m
//  ZHHealth
//
//  Created by pbz on 15/12/30.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZEnsureOrderController.h"
#import "WcrAddressViewController.h"
#import "BZShoppingCartModelSelected.h"
#import "BZShoppingCartModel.h"
#import "BZProductListController.h"
#import "BZProductListTwoController.h"
#import "BZPayController.h"
#import "BZProductDetailInfosModel.h"
#import "BZProductDetailADPictureModel.h"
#import "BZOrderModel.h"
@interface BZEnsureOrderController ()
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
@property (nonatomic,strong)  BZOrderModel *orderModel;

@end

@implementation BZEnsureOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftBackItem];
    self.title = @"确认订单";
    [self setCustomUI];
}

- (void)setCustomUI{
    
    self.view.backgroundColor = [UIColor colorWithRGB:230 G:230 B:230];
    CGFloat marginX = 20;
    // 第一个view
    if (_isFormAddress == YES) {
    }else{
        // 解压地址
        NSArray *addressArray = [BZAddressModel decode];
        // 默认去第一个地址
        BZAddressModel *addressModel = addressArray[0];
        _addressModel = addressModel;
    }
    
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, kMainWidth, kMainWidth * 0.3)];
    firstView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:firstView];
    // 添加手势
    UITapGestureRecognizer *tapAdress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adress)];
    [firstView addGestureRecognizer:tapAdress];
    
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
    nameLabel.text = _addressModel.name;
    
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame), 10, kMainWidth * 0.5, firstH)];
    [firstView addSubview:phoneView];
    UIImageView *phonePic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, iconView.bounds.size.height - 10, iconView.bounds.size.height - 10)];
    phonePic.contentMode = UIViewContentModeScaleAspectFit;
    phonePic.image = [UIImage imageNamed:@"iconfont-phone-2"];
    [phoneView addSubview:phonePic];
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame) + 5, 0, iconView.bounds.size.width - icon.bounds.size.width, iconView.bounds.size.height)];
    [phoneView addSubview:phoneLabel];
    phoneLabel.text = _addressModel.phone;
    
    UILabel *addressLabel = [[UILabel alloc ]initWithFrame:CGRectMake(marginX, CGRectGetMaxY(iconView.frame) + 10, kMainWidth - marginX - 20, firstH)];
    [firstView addSubview:addressLabel];
    addressLabel.text = _addressModel.address;
    addressLabel.numberOfLines = 0;
    addressLabel.textColor = [UIColor grayColor];
    addressLabel.font = [UIFont systemFontOfSize:14];
    
    
    // 取出选中的产品模型
    NSMutableArray *shoppingCartSelectA = [BZShoppingCartModelSelected decode];
    _shoppingCartSelectA = shoppingCartSelectA;
    // 第二个view
    UIView *secondView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(firstView.frame) + 10, kMainWidth, kMainWidth * 0.2)];
    secondView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:secondView];
    [self setSecondView:secondView];
    // 添加一个手势
    
    
    // 第三个view
    UIView *thridView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(secondView.frame) + 10, kMainWidth, kMainWidth * 0.2)];
    thridView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:thridView];
    
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
    
    id obj = _shoppingCartSelectA[0];
    if ([obj isKindOfClass:[BZShoppingCartModel class]]) {
        for (BZShoppingCartModel *shoppingCartSelect in _shoppingCartSelectA) {
            
            _totalCost = _totalCost + shoppingCartSelect.sumPrice;
            productCostNum.text = [NSString stringWithFormat:@"￥%0.2f",_totalCost];
        }
    }else{
        BZProductDetailInfosModel *productDetailInfosModel = _shoppingCartSelectA[0];
        _totalCost = productDetailInfosModel.price;
        productCostNum.text = [NSString stringWithFormat:@"￥%0.2f",productDetailInfosModel.price];
    }
    
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
    
    // 底部的view
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kMainHeight - 44, kMainWidth, 44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    // 底部栏的子控件
    //  显示花费的label
    UILabel *costLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, bottomView.bounds.size.height )];
    costLabel.text = @"应付金额:";
    costLabel.textColor = [UIColor blackColor];
    [bottomView addSubview:costLabel];
    
    UILabel *costLabels = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(costLabel.frame), 0, 100, bottomView.bounds.size.height )];
    CGFloat allCost = _totalCost;
    costLabels.text = [NSString stringWithFormat:@"￥ %0.2f",allCost];
    costLabels.textAlignment = NSTextAlignmentLeft;
    costLabels.textColor = [UIColor redColor];
    [bottomView addSubview:costLabels];
    // 右边的结算按钮
    CGFloat balanceBtnWidth = 80;
    UIButton *balanceBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainWidth - balanceBtnWidth, 0, balanceBtnWidth, bottomView.bounds.size.height)];
    [balanceBtn addTarget:self action:@selector(balanceClick) forControlEvents:UIControlEventTouchUpInside];
    balanceBtn.backgroundColor = [UIColor colorWithRGB:73 G:175 B:188];
    [balanceBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    balanceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [balanceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomView addSubview:balanceBtn];
    [self.view addSubview:bottomView];

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
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(picViewMaxX + 15, 0, kMainWidth - picViewMaxX - 120, kMainWidth * 0.1)];
    [secondView1 addSubview:titleLabel];
    titleLabel.textAlignment = 0;
    titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel = titleLabel;
    
    UILabel *standenLabel = [[UILabel alloc] initWithFrame:CGRectMake(picViewMaxX + 20, CGRectGetMaxY(titleLabel.frame), kMainWidth - picViewMaxX - 120,  kMainWidth * 0.1)];
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
    
    NSMutableArray *shoppingCartSelectA = [BZShoppingCartModelSelected decode];
    id obj = shoppingCartSelectA[0];
    if ([obj isKindOfClass:[BZShoppingCartModel class]]) {
        for (BZShoppingCartModel *shoppingCartSelect in _shoppingCartSelectA) {
            count = [shoppingCartSelect.count intValue];
            sum = sum + count;
            countLabel.text = [NSString stringWithFormat:@"共%d件",sum];
            _totalCount = countLabel.text;
        }
    }else{
        countLabel.text = [NSString stringWithFormat:@"共1件"];
        _totalCount = countLabel.text;
    }

    
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
    
    if ([obj isKindOfClass:[BZShoppingCartModel class]]) {
        if (_shoppingCartSelectA.count == 1) {
            _secondView1.hidden = NO;
            _secondView2.hidden = YES;
            BZShoppingCartModel *model = _shoppingCartSelectA[0];
            _titleLabel.text = model.productName;
            _standenLabel.text = model.standard;
            [_picView sd_setImageWithURL:[NSURL URLWithString:model.productPic] placeholderImage:[UIImage imageNamed:@"ic_error"]];
            
        }else if (_shoppingCartSelectA.count > 1){
            _secondView1.hidden = YES;
            _secondView2.hidden = NO;
            BZShoppingCartModel *model1 = _shoppingCartSelectA[0];
            [_picView1 sd_setImageWithURL:[NSURL URLWithString:model1.productPic] placeholderImage:[UIImage imageNamed:@"ic_error"]];
            BZShoppingCartModel *model2 = _shoppingCartSelectA[0];
            [_picView2 sd_setImageWithURL:[NSURL URLWithString:model2.productPic] placeholderImage:[UIImage imageNamed:@"ic_error"]];
        }
    }else{
        _secondView1.hidden = NO;
        _secondView2.hidden = YES;
        BZProductDetailInfosModel *model = _shoppingCartSelectA[0];
        _titleLabel.text = model.productName;
        _standenLabel.text = model.standard;
        // 解档图片
         NSString *file = [[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"BZProductDetailADPictureModel.data"];
        NSMutableArray *arrayPic = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
       
        if(arrayPic.count ==0 ){
            [_picView setImage:[UIImage imageNamed:@"ic_error"]];
        }else{
            [_picView sd_setImageWithURL:[NSURL URLWithString:arrayPic[0]] placeholderImage:[UIImage imageNamed:@"ic_error"]];
        }
        
    }

}
// 点击第一个view
- (void)adress{
    WcrAddressViewController *wcrAddressVC = [[WcrAddressViewController alloc]init];
    [self.navigationController pushViewController:wcrAddressVC animated:YES];
}
// 产品清单
- (void)productList{
    NSMutableArray *shoppingCartSelectA = [BZShoppingCartModelSelected decode];
    id obj = shoppingCartSelectA[0];
    if ([obj isKindOfClass:[BZShoppingCartModel class]]) {
        BZProductListController *productListVC = [[BZProductListController alloc] init];
        productListVC.shoppingCartSelectA = _shoppingCartSelectA;
        productListVC.totalCount = _totalCount;
        productListVC.isFormOrder = NO;
        [self.navigationController pushViewController:productListVC animated:YES];

    }else{
        BZProductDetailInfosModel *model = _shoppingCartSelectA[0];
        // 解档图片
        NSString *file = [[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"BZProductDetailADPictureModel.data"];
        NSMutableArray *arrayPic = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
        BZProductListTwoController *productListVC = [[BZProductListTwoController alloc] init];
        productListVC.productDetailInfosModel = model;
        productListVC.ADpic = arrayPic[0];
        [self.navigationController pushViewController:productListVC animated:YES];
    }

}
// 点击提交订单按钮
- (void)balanceClick{
    // 生成订单
     NSMutableArray *modelArray = [NSMutableArray array];
    LoginResponseAccount *account = [LoginResponseAccount decode];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"patientId"] = account.Id;
    args[@"addressId"] = _addressModel.ID;
    NSMutableArray *shoppingCartSelectA = [BZShoppingCartModelSelected decode];
    id obj = shoppingCartSelectA[0];
    if ([obj isKindOfClass:[BZShoppingCartModel class]]) {
        for (BZShoppingCartModel *model in _shoppingCartSelectA) {
            [modelArray addObject:model.ID];
        }
        args[@"cartIds"] = [modelArray componentsJoinedByString:@","];
        __weak typeof(self) weakSeaf = self;
        [httpUtil doPostRequest:@"api/orderApiController/addOrder" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                weakSeaf.orderModel = [BZOrderModel mj_objectWithKeyValues:responseMd.response];
                BZPayController *payVC = [[BZPayController alloc] init];
                payVC.totalCost =weakSeaf.orderModel.totalAmount;
                payVC.orderID = weakSeaf.orderModel.ID;
                payVC.orderNo = weakSeaf.orderModel.parentOrderNo;
                payVC.orderName = weakSeaf.orderModel.name;
                payVC.productDescription = weakSeaf.orderModel.address;
                payVC.expenseCost = _yunfeiCost;
                payVC.count = _totalCount;
                
                [self.navigationController pushViewController:payVC animated:YES];
            }
        }];

    }else{
        // 从立即购买跳来
        BZProductDetailInfosModel *model = _shoppingCartSelectA[0];
        args[@"productId"] = model.ID;
        args[@"count"] = @"1";
        args[@"doctorId"] = _doctorID;
        __weak typeof(self) weakSeaf = self;
        [httpUtil doPostRequest:@"api/orderApiController/buyNow" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                
                weakSeaf.orderModel = [BZOrderModel mj_objectWithKeyValues:responseMd.response];
                BZPayController *payVC = [[BZPayController alloc] init];
                payVC.totalCost =weakSeaf.orderModel.totalAmount;
                payVC.orderID = weakSeaf.orderModel.ID;
                payVC.orderNo = weakSeaf.orderModel.parentOrderNo;
                payVC.orderName = weakSeaf.orderModel.name;
                payVC.productDescription = weakSeaf.orderModel.address;
                payVC.expenseCost = _yunfeiCost;
                payVC.count = _totalCount;
                
                [self.navigationController pushViewController:payVC animated:YES];
            }
        }];

    }
    
}










@end
