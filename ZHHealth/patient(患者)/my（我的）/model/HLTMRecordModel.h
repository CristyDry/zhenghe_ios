//
//  HLTMRecordModel.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/29.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class cdList;
@interface HLTMRecordModel : NSObject



@property (nonatomic, copy) NSString *ID;//病历id

@property (nonatomic, copy) NSString *mhName;//患者名

@property (nonatomic, copy) NSString *mhTitle;//病历标题

@property (nonatomic, copy) NSString *Description;//描述

@property (nonatomic, copy) NSString *standby1;//年龄

@property (nonatomic, copy) NSString *birthday2;//

@property (nonatomic, copy) NSString *createDate;//创建日期

@property (nonatomic, copy) NSString *seeadoctorDate2;//看医生时间

@property (nonatomic, strong) NSArray<cdList *> *cdList;//病程

@property (nonatomic, copy) NSString *departmentsName;//科室

@property (nonatomic, copy) NSString *diagnose;//医生诊断

@property (nonatomic, assign) BOOL isNewRecord;

@property (nonatomic, copy) NSString *birthday;//

@property (nonatomic, copy) NSString *updateDate;//更新时间

@property (nonatomic, assign) long long seeadoctorDate;//时间戳

@property (nonatomic, strong) NSArray<NSString *> *image;

@property (nonatomic, copy) NSString *gender;//性别

@property (nonatomic, copy) NSString *patientId;//患者id



@end
@interface cdList : NSObject

@property (nonatomic, copy) NSString *cdDate;//病程时间

@property (nonatomic, copy) NSString *updateDate;//更新时间

@property (nonatomic, copy) NSString *remark;//标记

@property (nonatomic, copy) NSString *ID;//病程id

@property (nonatomic, copy) NSString *incident;//项目

@property (nonatomic, copy) NSString *mhId;

@property (nonatomic, strong) NSArray<NSString *> *image;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, strong) NSString *cdDate2;

@property (nonatomic, assign) BOOL isNewRecord;

@end

