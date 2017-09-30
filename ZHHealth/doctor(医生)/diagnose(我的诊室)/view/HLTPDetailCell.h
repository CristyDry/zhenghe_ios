//
//  HLTPDetailCell.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/26.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLTDiagnose.h"

@interface HLTPDetailCell : UITableViewCell

@property (nonatomic, strong) huanzhe *huanzheModel;
@property (nonatomic, strong) NSString *textString;
@property (nonatomic, strong) UILabel *textlabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end
