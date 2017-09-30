//
//  BZFinishedOrderViewController.m
//  ZHHealth
//
//  Created by pbz on 15/11/25.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZFinishedOrderViewController.h"
#import "UIView+Extension.h"
#define screenbounds [UIScreen mainScreen].bounds
@interface BZFinishedOrderViewController ()

@end

@implementation BZFinishedOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRGB:237 G:238 B:240];
    // 添加返回按钮
    [self addLeftBackItem];
    // 添加中间标题--已完成
    [self addTitleView];
    // 添加右边按钮--更多。。。
    [self addRightView];
    // 设置子控件
    [self addChildView];
}
// 添加中间标题--已完成
- (void)addTitleView{
    CGFloat twidth = 100;
    CGFloat theight = 44;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - twidth) * 0.5, 0, twidth, theight)];
    titleLabel.text = @"已完成";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setTextColor:[UIColor whiteColor]];
    self.navigationItem.titleView = titleLabel;
}
// 添加右边按钮--更多
- (void)addRightView{
    // 编辑按钮的图片不对,到时要更换
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] init];
    rightBarButtonItem.image = [[UIImage imageNamed:@"三点"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}
// 点击右边更多的按钮
- (void)moreClick{

}
// 设置子控件
- (void)addChildView{
    // 添加一个scrollView
    // 导航栏的高度
    CGFloat navigationBarHeight = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    CGFloat width = screenbounds.size.width;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -navigationBarHeight, screenbounds.size.width, screenbounds.size.height + 20)];
    scrollView.contentSize = CGSizeMake(0, 736);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:scrollView];

    // 1. 显示订单号的view
    UIView *ordernumberView = [[UIView alloc] initWithFrame:CGRectMake(0, navigationBarHeight,width, 50)];
    ordernumberView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:ordernumberView];
    UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0,width, 50)];
    NSString *orderNumber = @"订单号:1234567ertgs234";
    orderLabel.text = [NSString stringWithFormat:@"%@",orderNumber];
    [ordernumberView addSubview:orderLabel];
    
    // 2. 显示快递单号的view
    UIView *expressmailView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(ordernumberView.frame) + 7,width, 50)];
    expressmailView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:expressmailView];
    UILabel *expressmailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0,width, 50)];
    NSString *expressmailNumber = @"顺丰单号:12345671356de3";
    expressmailLabel.text = [NSString stringWithFormat:@"%@",expressmailNumber];
    [expressmailView addSubview:expressmailLabel];
    
    // 3. 显示个人信息的View
    UIView *personInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(expressmailView.frame) + 7, width, 80)];
    personInfoView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:personInfoView];
        // 显示头像和名字button
    UIButton *nameBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, (width - 40 ) * 0.5, 30)];
    [nameBtn setImage:[UIImage imageNamed:@"iconfont-ertongyouhui@3x"] forState:UIControlStateNormal];
    nameBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [nameBtn setTitle:@"Adale" forState:UIControlStateNormal];
    [nameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    nameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [personInfoView addSubview:nameBtn];
        // 显示手机号的button
    UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameBtn.frame), nameBtn.frame.origin.y, width * 0.5, 30)];
    [phoneBtn setImage:[UIImage imageNamed:@"iconfont-phone-2"] forState:UIControlStateNormal];
    phoneBtn.enabled = YES;
    phoneBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [phoneBtn setTitle:@"15620984184" forState:UIControlStateNormal];
    [phoneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    phoneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    phoneBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [personInfoView addSubview:phoneBtn];
        // 显示地址的label
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameBtn.frame.origin.x + 15, CGRectGetMaxY(nameBtn.frame),width - nameBtn.frame.origin.x,50)];
    NSString *address = @"广州市珠海区新港东路中州中心北塔1305";
    addressLabel.numberOfLines = 0;
    addressLabel.textColor = [UIColor blackColor];
    addressLabel.font = [UIFont systemFontOfSize:14];
    addressLabel.text = [NSString stringWithFormat:@"%@",address];
    addressLabel.textAlignment = NSTextAlignmentLeft;
    [personInfoView addSubview:addressLabel];
    
    // 4. 显示商品的View
    UIView *goodsInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(personInfoView.frame) + 7, width, 80)];
    goodsInfoView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:goodsInfoView];
    // 产品数量
    int count = 3;
    int margin = 8;
    CGFloat showImageBtnW = 60;
    for (int i = 0; i < count; i++) {
         UIButton *showImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(20 + (margin + showImageBtnW) * i, 10, showImageBtnW, showImageBtnW)];
        [showImageBtn setImage:[UIImage imageNamed:@"u23"] forState:UIControlStateNormal];
        [goodsInfoView addSubview:showImageBtn];
    }
    UIButton *showCountBtn = [[UIButton alloc] initWithFrame:CGRectMake(width - 90, 25, 80, 30)];
    [showCountBtn setImage:[UIImage imageNamed:@"后退-拷贝-2@3x"] forState:UIControlStateNormal];
    showCountBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [showCountBtn setTitle:[NSString stringWithFormat:@"共%d件",3] forState:UIControlStateNormal];
    showCountBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [showCountBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    showCountBtn.imageEdgeInsets = UIEdgeInsetsMake(0, showCountBtn.bounds.size.width * 0.8, 0, 0);
    showCountBtn.titleEdgeInsets = UIEdgeInsetsMake(0, - showCountBtn.bounds.size.width * 0.5, 0, 0);
    [goodsInfoView addSubview:showCountBtn];
    
    // 5. 显示费用详情的view
    UIView *detailCostView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(goodsInfoView.frame) + 7, width, 70)];
    detailCostView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:detailCostView];
        // 商品金额的两个label
    UILabel *goodsCostLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5,width * 0.5 - 20, 30)];
    goodsCostLabel.text = @"商品金额";
    goodsCostLabel.font = [UIFont systemFontOfSize:18];
    goodsCostLabel.textAlignment = NSTextAlignmentLeft;
    [detailCostView addSubview:goodsCostLabel];
    
    UILabel *costLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsCostLabel.frame),0,width * 0.5 - 20, 30)];
    NSString *goodsCost = @"￥58";
    costLabel.text = goodsCost;
    costLabel.font = [UIFont systemFontOfSize:18];
    costLabel.textColor = [UIColor redColor];
    costLabel.textAlignment = NSTextAlignmentRight;
    [detailCostView addSubview:costLabel];
    // 运费的两个label
    UILabel *carriageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(goodsCostLabel.frame),width * 0.5 - 20, 30)];
    carriageLabel.text = @"运费";
    carriageLabel.font = [UIFont systemFontOfSize:18];
    carriageLabel.textAlignment = NSTextAlignmentLeft;
    [detailCostView addSubview:carriageLabel];
    
    UILabel *carriageCostLabel = [[UILabel alloc] initWithFrame:CGRectMake(costLabel.frame.origin.x,carriageLabel.frame.origin.y,width * 0.5 - 20, 30)];
    NSString *carriageCost = @"￥10";
    carriageCostLabel.text = carriageCost;
    carriageCostLabel.font = [UIFont systemFontOfSize:18];
    carriageCostLabel.textColor = [UIColor redColor];
    carriageCostLabel.textAlignment = NSTextAlignmentRight;
    [detailCostView addSubview:carriageCostLabel];
    
    // 6. 显示实付款的view
    UIView *actuallyCostView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(detailCostView.frame) + 1, width, 70)];
    actuallyCostView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:actuallyCostView];
    
    UILabel *actuallyCostLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5,width  - 110, 30)];
    actuallyCostLabel.text = @"实付款:";
    actuallyCostLabel.font = [UIFont systemFontOfSize:18];
    actuallyCostLabel.textAlignment = NSTextAlignmentRight;
    [actuallyCostView addSubview:actuallyCostLabel];
    
    UILabel *actuallyCostNumber = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(actuallyCostLabel.frame),5,90, 30)];
    actuallyCostNumber.text = @"￥99";
    actuallyCostNumber.font = [UIFont systemFontOfSize:18];
    actuallyCostNumber.textColor = [UIColor redColor];
    actuallyCostNumber.textAlignment = NSTextAlignmentRight;
    [actuallyCostView addSubview:actuallyCostNumber];
    
    UILabel *buyTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(actuallyCostNumber.frame) + 5,width - 20, 20)];
    buyTimeLabel.text = @"下单时间：2015-11-25 18:22:07";
    buyTimeLabel.font = [UIFont systemFontOfSize:12];
    buyTimeLabel.textColor = [UIColor lightGrayColor];
    buyTimeLabel.textAlignment = NSTextAlignmentRight;
    [actuallyCostView addSubview:buyTimeLabel];
    
    // 7. footView
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) - 44, width, 44)];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    // 删除订单按钮
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(width - 100, 5, 80, 34)];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"u58"] forState:UIControlStateNormal];
    [deleteBtn setTitle:@"删除订单" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];;
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [footView addSubview:deleteBtn];
    [deleteBtn addTarget:self action:@selector(deleteOrderClick)];
}
// 删除订单
- (void)deleteOrderClick{

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"订单删除后不可恢复，是否删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    
}



@end
