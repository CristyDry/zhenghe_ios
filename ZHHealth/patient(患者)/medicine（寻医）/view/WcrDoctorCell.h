//
//  WcrDoctorCell.h
//  ZHMedical
//
//  Created by U1KJ on 15/11/10.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#define kWcrDoctorCellHeight 90

#import <UIKit/UIKit.h>
#import "BZDoctorModel.h"

@interface WcrDoctorCell : UITableViewCell

@property (nonatomic, strong) BZDoctorModel *doctorModel;

@end
