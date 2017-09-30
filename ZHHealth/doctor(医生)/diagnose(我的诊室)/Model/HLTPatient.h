//
//  HLTPatient.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/14.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLTPatient : NSObject

@property (nonatomic, strong) NSString *ID;//患者id
@property (nonatomic, strong) NSString *avatar;//患者头像
@property (nonatomic, strong) NSString *name;//患者姓名
@property (nonatomic, strong) NSString *verifyContent;//申请内容
@property (nonatomic, strong) NSString *status;//信息状态
@property (nonatomic, strong) NSString *gender;//性别
@property (nonatomic, strong) NSString *age;//患者年龄
@property (nonatomic, strong) NSString *address;//患者地址

@end
