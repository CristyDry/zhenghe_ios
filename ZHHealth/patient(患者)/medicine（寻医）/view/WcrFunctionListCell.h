//
//  WcrFunctionListCell.h
//  ZHMedical
//
//  Created by U1KJ on 15/11/10.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#define kWcrFunctionCellHeight 70

#import <UIKit/UIKit.h>
#import "WcrFunction.h"

@interface WcrFunctionListCell : UITableViewCell

@property (nonatomic, strong) WcrFunction *function;

@end
