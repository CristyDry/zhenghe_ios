//
//  BZSearchResultCell.h
//  ZHHealth
//
//  Created by pbz on 15/12/1.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZProductListModel.h"

@protocol BZSearchResultCellDelegate <NSObject>

/**
 *  定义协议，跳转到药品详情页面
 *  参数，看实际情况网络请求需要修改
 */
-(void)pushProductDetailController:(NSString *)productId;

@end

@interface BZSearchResultCell : UITableViewCell

@property (nonatomic,assign)  CGFloat typeLabelMaxY;

@property (nonatomic,weak)  id<BZSearchResultCellDelegate>delegate;

+ (instancetype)searchResultCellWithTableView:(UITableView *)tableView;
- (void)setProductInfo:(BZProductListModel *)productListModel atIndex:(NSInteger)index;
@end
