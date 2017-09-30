//
//  BZRecordBloodController.h
//  ZHHealth
//
//  Created by pbz on 15/12/19.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BZRecordBloodController : UIViewController
@property (nonatomic,strong)  NSString *patientId;//病人id
@property (nonatomic,strong)  NSString *bpId;// 血压id
@property (nonatomic,strong)  NSString *sbp; // 收缩压
@property (nonatomic,strong)  NSString *dpb; // 舒张压
@end
