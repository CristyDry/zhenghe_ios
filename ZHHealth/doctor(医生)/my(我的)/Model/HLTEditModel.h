//
//  HLTEditModel.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/16.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLTEditModel : NSObject
//医生id
@property (nonatomic, strong) NSString *ID;
//专业领域
@property (nonatomic, strong) NSString *professionalField;
//科目
@property (nonatomic, strong) NSString *department;
//头像
@property (nonatomic, strong) NSString *avatar;
//医师
@property (nonatomic, strong) NSString *professional;
//信息
@property (nonatomic, strong) NSString *intro;
//医院
@property (nonatomic, strong) NSString *hospital;
//name
@property (nonatomic, strong) NSString *doctor;

@property (nonatomic, strong) NSString *wmUrl;
@end
