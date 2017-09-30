//
//  HLTCollectCell.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/16.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLTCollectModel.h"
@interface HLTCollectCell : UITableViewCell

@property (nonatomic, strong) HLTCollectModel *collectModel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageview;
@property (nonatomic, strong) UILabel *contentLabel;

@end

