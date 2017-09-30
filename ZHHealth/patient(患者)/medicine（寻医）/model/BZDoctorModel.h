//
//  BZDoctorModel.h
//  ZHHealth
//
//  Created by pbz on 15/12/11.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZDoctorModel : NSObject

@property (nonatomic, copy) NSString *ID;
/** 专家头像*/
@property (nonatomic, copy) NSString *avatar;
/** 专家名字*/
@property (nonatomic, copy) NSString *doctor;
/** 专家所属医院*/
@property (nonatomic, copy) NSString *hospital;
/** 专家职称*/
@property (nonatomic, copy) NSString *professional;
/** 专家简介*/
@property (nonatomic, copy) NSString *intro;
/** 主治领域*/
@property (nonatomic, copy) NSString *professionalField;
/** 专家所属科目*/
@property (nonatomic, copy) NSString *department;

@end
