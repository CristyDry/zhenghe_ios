//
//  HLTSeeCardController.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/28.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLTMRecordModel.h"

@interface HLTSeeCardController : UIViewController

@property (nonatomic, strong) HLTMRecordModel *cordModel;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic) BOOL isPatient;//是否患者跳转
@end
