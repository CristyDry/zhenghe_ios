//
//  BZShoppingCartCell.h
//  ZHHealth
//
//  Created by pbz on 15/11/24.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZShoppingCartModel.h"
@protocol BZShoppingCartCellDelegate<NSObject>
@optional
- (void)isAllSelecteds:(BOOL) isAllSelected;
- (void)calculateCost:(CGFloat ) cost;
- (void)setAllCost;
@end


@interface BZShoppingCartCell : UITableViewCell
@property (nonatomic,strong)  BZShoppingCartModel *shoppingCartModel;
// 创建自定义cell的类方法
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic)  BOOL isAllSelected;
@property (nonatomic,weak)  id<BZShoppingCartCellDelegate> delegate;

@end
