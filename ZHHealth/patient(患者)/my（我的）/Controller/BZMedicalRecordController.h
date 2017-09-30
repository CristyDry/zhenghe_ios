//
//  BZMedicalRecordController.h
//  ZHHealth
//
//  Created by pbz on 15/12/16.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLTDiagnose.h"

@interface BZMedicalRecordController : UIViewController

@property (nonatomic, strong) huanzhe *huanzheModel;
@property (nonatomic) BOOL isPatient;//患者页面跳转

@end
