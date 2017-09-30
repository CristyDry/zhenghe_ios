//
//  BZClassifyInfoCell.h
//  ZHHealth
//
//  Created by pbz on 15/12/1.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZClassifyAccount.h"
@interface BZClassifyInfoCell : UITableViewCell
@property (nonatomic,strong)   BZClassifyAccount *infos;
+ (instancetype)BZClassifyInfoCellWithTableView:(UITableView *)tableView;
@end
