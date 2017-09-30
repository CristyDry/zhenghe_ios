//
//  WCRDoctorDetailController.h
//  ZHMedical
//
//  Created by U1KJ on 15/11/17.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZDoctorModel.h"

@interface WCRDoctorDetailController : UIViewController

@property (nonatomic, strong) BZDoctorModel *doctor;
@property (nonatomic)  BOOL isFormMyDoctor;
@end
