//
//  BZWeightModel.h
//  ZHHealth
//
//  Created by pbz on 15/12/18.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZWeightModel : NSObject
/** 体重*/
@property (nonatomic, copy) NSString *weight;
/** 更新时间*/
@property (nonatomic, copy) NSString *updateDate;

@property (nonatomic, copy) NSString *exponent;

@property (nonatomic, copy) NSString *ID;
/** 体重*/
@property (nonatomic, copy) NSString *stature;

@property (nonatomic, copy) NSString *createDate;
/** 患者id*/
@property (nonatomic, copy) NSString *patientId;

@property (nonatomic, assign) BOOL isNewRecord;

@end
