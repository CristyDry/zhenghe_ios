//
//  BZLeftRecordCell.h
//  ZHHealth
//
//  Created by pbz on 15/12/22.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZLeftRecordModel.h"
@interface BZLeftRecordCell : UITableViewCell

@property (nonatomic,strong)  BZLeftRecordModel *leftRecordInfo;

// 重写init方法，重新创建cell内部子控件
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier images:(NSArray *) images;

@end
