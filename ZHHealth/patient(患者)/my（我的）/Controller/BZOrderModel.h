//
//  BZOrderModel.h
//  ZHHealth
//
//  Created by pbz on 16/1/11.
//  Copyright © 2016年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZOrderModel : NSObject

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *updateDate;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *parentOrderNo;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *totalAmount;

@property (nonatomic, assign) BOOL isNewRecord;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *patientId;

@property (nonatomic, copy) NSString *name;

@end
