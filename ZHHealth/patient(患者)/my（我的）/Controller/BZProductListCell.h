//
//  BZProductListCell.h
//  ZHHealth
//
//  Created by pbz on 16/1/5.
//  Copyright © 2016年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZShoppingCartModel.h"
#import "BZAllOrderModel.h"
@interface BZProductListCell : UITableViewCell
@property (nonatomic,strong)  BZShoppingCartModel *shoppingCartModel;
@property (nonatomic,strong)  productInfos *productInfos;
@end
