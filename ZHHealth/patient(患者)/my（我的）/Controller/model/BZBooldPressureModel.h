//
//  BZBooldPressureModel.h
//  ZHHealth
//
//  Created by pbz on 15/12/18.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZBooldPressureModel : NSObject

@property (nonatomic, copy) NSString *dbp;

@property (nonatomic, copy) NSString *updateDate;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *sbp;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *patientId;

@property (nonatomic, assign) BOOL isNewRecord;

@end
