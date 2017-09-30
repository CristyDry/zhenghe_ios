//
//  WcrDoctor.h
//  ZHMedical
//
//  Created by U1KJ on 15/11/10.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WcrDoctor : NSObject

@property (nonatomic, strong) NSString *imageName;      // 头像

@property (nonatomic, strong) NSString *name;           // 名字

@property (nonatomic, strong) NSString *office;         // 科室

@property (nonatomic, strong) NSString *doctorType;     // 医生类别

@property (nonatomic, strong) NSString *hospital;       // 医院

@property (nonatomic, strong) NSString *profession;     // 专业领域

@property (nonatomic, strong) NSString *skill;          // 主治

@property (nonatomic, strong) NSString *brief;          // 简介

+(NSArray*)createDoctors;

@end
