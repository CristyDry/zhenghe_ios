//
//  BZProfessorDetailViewController.h
//  ZHHealth
//
//  Created by pbz on 15/12/12.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZDoctorModel.h"
#import <BaseViewControler.h>

@interface BZProfessorDetailViewController : BaseViewControler
@property (nonatomic, strong) BZDoctorModel *doctor;
@end
