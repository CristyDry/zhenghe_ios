//
//  BZProductListController.h
//  ZHHealth
//
//  Created by pbz on 16/1/5.
//  Copyright © 2016年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZAllOrderModel.h"
#import <BaseViewControler.h>
@interface BZProductListController : BaseViewControler
@property (nonatomic,strong)  NSMutableArray *shoppingCartSelectA;
@property (nonatomic,strong)  NSString *totalCount;
@property (nonatomic,strong)  BZAllOrderModel *orderModel;
@property (nonatomic)  BOOL isFormOrder;
@end
