//
//  BZHeartRateModel.h
//  ZHHealth
//
//  Created by pbz on 15/12/18.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZHeartRateModel : NSObject
/** 更新时间*/
@property (nonatomic, copy) NSString *updateDate;
/** 静息/运动前/运动后 心率*/
@property (nonatomic, copy) NSString *scene;
/** id*/
@property (nonatomic, copy) NSString *ID;
/** 心率*/
@property (nonatomic, copy) NSString *heartRate;
/** 创建时间*/
@property (nonatomic, copy) NSString *createDate;
/** 病人id*/
@property (nonatomic, copy) NSString *patientId;
/** 注释*/
@property (nonatomic, assign) BOOL isNewRecord;

@end
