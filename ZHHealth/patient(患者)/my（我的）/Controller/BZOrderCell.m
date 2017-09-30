//
//  BZOrderCell.m
//  ZHHealth
//
//  Created by pbz on 15/12/31.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZOrderCell.h"
#import "BZPayController.h"
@interface BZOrderCell()
@property (nonatomic,strong)  UILabel *dealStatu;// 订单状态
@property (nonatomic,strong)  UILabel *totalAmountLabel;// 实付款
@property (nonatomic,strong)  UIButton *cancelBtn; //取消订单
@property (nonatomic,strong)  UIButton *sureBtn; // 去支付
@property (nonatomic,strong)  UIImageView *picView;// 产品图片
@property (nonatomic,strong)  UILabel *titleLabel; // 产品名称
@property (nonatomic,strong)  UILabel *standenLabel;// 产品规格
@property (nonatomic,strong)  UIView *secondView1;
@property (nonatomic,strong)  UIView *secondView2;
@property (nonatomic,strong)  UIImageView *picView1;
@property (nonatomic,strong)  UIImageView *picView2;
@end
@implementation BZOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 第一个view
        [self setFirstView];
        // 第二个view
        [self setSecondView];
        // 第三个view
        [self setThirdView];
    }
    return self;
}
// 第一个view
- (void)setFirstView{
    
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, 37)];
    [self.contentView addSubview:firstView];
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, 7)];
    topView.backgroundColor = [UIColor colorWithRGB:230 G:230 B:230];
    [firstView addSubview:topView];
    
    UILabel *dealStatuLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(topView.frame), 100, 30)];
    [firstView addSubview:dealStatuLabel];
    dealStatuLabel.textAlignment = 0;
    dealStatuLabel.text = @"交易状态";
    
    UILabel *dealStatu = [[UILabel alloc] initWithFrame:CGRectMake(kMainWidth - 120, CGRectGetMaxY(topView.frame), 100, 30)];
    dealStatu.font = [UIFont systemFontOfSize:14];
    [firstView addSubview:dealStatu];
    dealStatu.textAlignment = NSTextAlignmentRight;
    _dealStatu = dealStatu;
}
// 第二个view
- (void)setSecondView{
    // secondView1
    UIView *secondView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 37, kMainWidth, kMainWidth * 0.32)];
    [self.contentView addSubview:secondView1];
    _secondView1 = secondView1;
    _secondView1.hidden = YES;
    UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, 1)];
    topLine.backgroundColor = [UIColor colorWithRGB:230 G:230 B:230];
    [secondView1 addSubview:topLine];

    UIImageView *picView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, secondView1.height_wcr , secondView1.height_wcr - 30)];
    _picView = picView;
    [secondView1 addSubview:picView];
    
    CGFloat picViewMaxX = CGRectGetMaxX(picView.frame);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(picViewMaxX + 20, 10, kMainWidth - picViewMaxX - 40, 30)];
    [secondView1 addSubview:titleLabel];
    titleLabel.textAlignment = 0;
    titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel = titleLabel;
    
    UILabel *standenLabel = [[UILabel alloc] initWithFrame:CGRectMake(picViewMaxX + 20, CGRectGetMaxY(titleLabel.frame), kMainWidth - picViewMaxX - 40, 30)];
    [secondView1 addSubview:standenLabel];
    standenLabel.textAlignment = 0;
    standenLabel.font = [UIFont systemFontOfSize:14];
    standenLabel.text = @"5g * 10袋";
    _standenLabel = standenLabel;
    
    
    // secondView2
    UIView *secondView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 37, kMainWidth, kMainWidth * 0.32)];
    [self.contentView addSubview:secondView2];
    _secondView2 = secondView2;
    _secondView2.hidden = YES;
    UIView * topLine2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, 1)];
    topLine2.backgroundColor = [UIColor colorWithRGB:230 G:230 B:230];
    [secondView2 addSubview:topLine2];
    
    UIImageView *picView1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, secondView1.height_wcr , secondView1.height_wcr  - 30)];
    _picView1 = picView1;
    [secondView2 addSubview:picView1];
    UIImageView *picView2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(picView1.frame) + 10, 15, secondView1.height_wcr , secondView1.height_wcr  - 30)];
    _picView2 = picView2;
    [secondView2 addSubview:picView2];
}
// 第三个view
- (void)setThirdView{
    UIView *thirdView = [[UIView alloc] initWithFrame:CGRectMake(0, kMainWidth * 0.32 + 37, kMainWidth, 40)];
    [self.contentView addSubview:thirdView];
    UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, 1)];
    topLine.backgroundColor = [UIColor colorWithRGB:230 G:230 B:230];
    [thirdView addSubview:topLine];
    // 取消订单
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainWidth - 180, 5, 80, 30)];
    [thirdView addSubview:cancelBtn];
    cancelBtn.hidden = YES;
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    cancelBtn.layer.borderColor = [UIColor colorWithRGB:230 G:230 B:230].CGColor;
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.cornerRadius = 4;
    cancelBtn.layer.masksToBounds = YES;
    _cancelBtn = cancelBtn;
    [cancelBtn addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
    // 去支付
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainWidth - 90, 5, 80, 30)];
    [thirdView addSubview:sureBtn];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.backgroundColor = kNavigationBarColor;
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    sureBtn.layer.borderColor = [UIColor colorWithRGB:230 G:230 B:230].CGColor;
    sureBtn.layer.borderWidth = 1;
    sureBtn.layer.cornerRadius = 4;
    sureBtn.layer.masksToBounds = YES;
    _sureBtn = sureBtn;
    _sureBtn.hidden = YES;
    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];

    UILabel *totalAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kMainWidth - 220, 40)];
    [thirdView addSubview:totalAmountLabel];
    totalAmountLabel.textAlignment = 0;
    totalAmountLabel.text = @"实付款：￥13.00";
    totalAmountLabel.font = [UIFont systemFontOfSize:14];
    _totalAmountLabel = totalAmountLabel;
}
// 取消订单
- (void)cancelOrder{
    if ([_delegate respondsToSelector:@selector(cancelOeder:)]) {
        [_delegate cancelOeder:_allOrderModel];
    }
}
// 去支付/确认订单
- (void)sureClick{
    if ([_delegate respondsToSelector:@selector(pushToPayViewController:)]) {
        [_delegate pushToPayViewController:_allOrderModel];
    }
}
- (void)setAllOrderModel:(BZAllOrderModel *)allOrderModel{
    _allOrderModel = allOrderModel;
    // 订单状态
    if ([allOrderModel.status isEqualToString:@"1"]) {
        _dealStatu.hidden = NO;
        _dealStatu.text = @"待付款";
        _dealStatu.textColor = [UIColor redColor];
        _cancelBtn.hidden = NO;
        [_cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        _sureBtn.hidden = NO;
        _sureBtn.enabled = YES;
        _sureBtn.backgroundColor = kNavigationBarColor;
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn setTitle:@"去支付" forState:UIControlStateNormal];
        
    }else if ([allOrderModel.status isEqualToString:@"2"]){
        _dealStatu.hidden = NO;
        _dealStatu.text = @"等待卖家发货";
        _dealStatu.textColor = [UIColor redColor];
        _cancelBtn.hidden = YES;
        _sureBtn.hidden = NO;
        _sureBtn.backgroundColor = [UIColor lightGrayColor];
        [_sureBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        _sureBtn.enabled = NO;

    }else if ([allOrderModel.status isEqualToString:@"3"]){
        _dealStatu.hidden = NO;
        _dealStatu.text = @"待收货";
        _dealStatu.textColor = [UIColor redColor];
        _cancelBtn.hidden = YES;
        _sureBtn.hidden = NO;
        _sureBtn.enabled = YES;
        _sureBtn.backgroundColor = kNavigationBarColor;
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn setTitle:@"确认收货" forState:UIControlStateNormal];
    }else if ([allOrderModel.status isEqualToString:@"4"]){
        _dealStatu.hidden = NO;
        _dealStatu.text = @"已完成";
        _dealStatu.textColor = [UIColor blackColor];
        _cancelBtn.hidden = YES;
         _sureBtn.hidden = NO;
        _sureBtn.backgroundColor = [UIColor clearColor];
        _sureBtn.enabled = NO;
        [_sureBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else if ([allOrderModel.status isEqualToString:@"5"]){
        _dealStatu.hidden = YES;
        _cancelBtn.hidden = YES;
        _sureBtn.hidden = NO;
        _sureBtn.enabled = NO;
        _sureBtn.backgroundColor = [UIColor clearColor];
        [_sureBtn setTitle:@"订单已取消" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    }
    // 产品信息
    if (allOrderModel.items.count == 1) {
        _secondView2.hidden = YES;
        _secondView1.hidden = NO;
        [_picView sd_setImageWithURL:[NSURL URLWithString:allOrderModel.items[0].productPic] placeholderImage:[UIImage imageNamed:@"ic_error"]];
        _titleLabel.text = allOrderModel.items[0].productName;
        _standenLabel.text = allOrderModel.items[0].standard;
    }else if (allOrderModel.items.count > 1){
        _secondView1.hidden = YES;
        _secondView2.hidden = NO;
         [_picView1 sd_setImageWithURL:[NSURL URLWithString:allOrderModel.items[0].productPic] placeholderImage:[UIImage imageNamed:@"ic_error"]];
         [_picView2 sd_setImageWithURL:[NSURL URLWithString:allOrderModel.items[1].productPic] placeholderImage:[UIImage imageNamed:@"ic_error"]];
    }
    _totalAmountLabel.text = [NSString stringWithFormat:@"实付款：￥%@",allOrderModel.totalAmount];
}










@end
