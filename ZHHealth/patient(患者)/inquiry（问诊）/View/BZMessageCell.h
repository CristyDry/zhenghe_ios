//
//  BZMessageCell.h
//  ZHHealth
//
//  Created by pbz on 15/12/11.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZRequestAndNotifyModel.h"

@interface BZMessageCell : UITableViewCell

@property (nonatomic,strong)  BZRequestAndNotifyModel *requestAndNotifyModel;

+ (instancetype)BZMessageCellWithTableView:(UITableView *)tableView;

@end
