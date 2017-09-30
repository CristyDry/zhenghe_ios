//
//  BZOrderCell.h
//  ZHHealth
//
//  Created by pbz on 15/12/31.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZAllOrderModel.h"
@protocol BZOrderCellDelegate<NSObject>
// 取消订单
- (void)cancelOeder:(BZAllOrderModel *)orderModel;
// 跳转到支付界面
- (void)pushToPayViewController:(BZAllOrderModel *)orderModel;

@end

@interface BZOrderCell : UITableViewCell
@property (nonatomic,strong)  BZAllOrderModel *allOrderModel;
@property (nonatomic,weak)  id<BZOrderCellDelegate>delegate;
@end
