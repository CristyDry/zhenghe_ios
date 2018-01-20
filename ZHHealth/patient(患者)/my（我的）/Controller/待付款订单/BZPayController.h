//
//  BZPayController.h
//  ZHHealth
//
//  Created by pbz on 15/12/31.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZAllOrderModel.h"
#import "WXApi.h"
#import <BaseViewControler.h>
@interface BZPayController : BaseViewControler
@property (nonatomic,strong)  NSString *count;// 商品件数
@property (nonatomic,strong)  NSString *expenseCost;// 运费
@property (nonatomic,strong)  NSString *orderID;// 订单id
@property (nonatomic,strong)  NSString *orderNo;// 订单号
@property (nonatomic,strong)  NSString *orderName;// 订单标题
@property (nonatomic,strong)  NSString *productDescription;// 商品描述
@property (nonatomic,strong)  NSString *totalCost;// 订单总费用

@end
