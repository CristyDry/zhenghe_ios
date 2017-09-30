//
//  BZOrderDetailController.h
//  ZHHealth
//
//  Created by pbz on 16/1/5.
//  Copyright © 2016年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZAllOrderModel.h"
@interface BZOrderDetailController : UIViewController
@property (nonatomic,assign)  CGFloat totalCost;
@property (nonatomic,strong)  BZAllOrderModel *orderModel;
@end
