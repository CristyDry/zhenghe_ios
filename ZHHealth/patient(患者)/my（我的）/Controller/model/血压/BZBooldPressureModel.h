//
//  BZBooldPressureModel.h
//  ZHHealth
//
//  Created by pbz on 15/12/18.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZBooldPressureModel : NSObject

@property (nonatomic, copy) NSString *dbp; // 舒张压

@property (nonatomic, copy) NSString *updateDate;

@property (nonatomic, copy) NSString *ID; // 血压id

@property (nonatomic, copy) NSString *sbp; // 收缩压

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *patientId; // 病人id

@property (nonatomic, assign) BOOL isNewRecord;

@end
